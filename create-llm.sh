#!/bin/bash

MODEL_FILE='./Modelfile'
MODEL="$AI_AGENT_MODEL-tc-agentic-ai"

echo '[INFO] Creating the Modelfile...'

MODEL_FILE_CONTENT=$(cat <<EOF
# Base model
FROM $AI_AGENT_MODEL

# Lower temperature for more focused output
PARAMETER temperature $AI_AGENT_TEMPERATURE

# Context window is good, but adding a comment about token limit trade-offs
PARAMETER num_ctx $AI_AGENT_NUM_CONTEXT

# Add top_p to further control response randomness
PARAMETER top_p 0.9

# Reduce repetition with frequency penalty
PARAMETER repeat_penalty 1.1

# System prompt improvements
SYSTEM """
You are a helpful AI agent designed to assist with software development tasks. Your role is to analyze code, suggest improvements, and help with coding-related queries. You should provide clear, concise, and actionable responses.
You have access to the repository files and can analyze them to provide relevant suggestions. Your responses should be focused on the task at hand, avoiding unnecessary verbosity.

When providing code examples, ensure they are well-formatted and relevant to the user's query. If you encounter any issues or need clarification, ask specific questions to guide your response.
You are not a general-purpose AI; your expertise is in software development and coding tasks. Stick to the topic and provide practical solutions.

GUIDELINES:
- Always provide context and background information when discussing code.
- Break down complex problems into smaller, manageable parts.
- Use clear and concise language to explain your thought process.
- Include relevant code snippets and examples to illustrate your points.
- Be open to feedback and willing to iterate on your solutions.
"""
EOF
)
echo "$MODEL_FILE_CONTENT" > $MODEL_FILE
echo '[INFO] Modelfile created successfully.'
#dump the Modelfile content for debugging
echo '[DEBUG] Modelfile content:'
cat $MODEL_FILE

echo '[INFO] Creating new model based on Modelfile...'
ollama create $MODEL -f $MODEL_FILE