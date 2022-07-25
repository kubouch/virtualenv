# Setting all environment variables for the venv
let path_name = (if ((sys).host.name == "Windows") { "Path" } { "PATH" })
let virtual_env = "__VIRTUAL_ENV__"
let bin = "__BIN_NAME__"
let path_sep = "__PATH_SEP__"

let old_path = ($nu.path | str collect ($path_sep))

let venv_path = ([$virtual_env $bin] | path join)
let new_path = ($nu.path | prepend $venv_path | str collect ($path_sep))

# environment variables that will be batched loaded to the virtual env
let new_env = ([
    [name, value];
    [$path_name $new_path]
    [_OLD_VIRTUAL_PATH $old_path]
    [VIRTUAL_ENV $virtual_env]
])

load-env $new-env

# Creating the new prompt for the session
let virtual_prompt = (if ("__VIRTUAL_PROMPT__" != "") {
    "(__VIRTUAL_PROMPT__) "
} {
    (build-string '(' ($virtual_env | path basename) ') ')
}
)

# If there is no default prompt, then only the env is printed in the prompt
let new_prompt = (if ( config | select prompt | empty? ) {
    ($"build-string '($virtual_prompt)'")
} {
    ($"build-string '($virtual_prompt)' (config get prompt | str find-replace "build-string" "")")
})
let-env PROMPT_COMMAND = $new_prompt

# We are using alias as the function definitions because only aliases can be
# removed from the scope
alias pydoc = python -m pydoc
alias deactivate = source "__DEACTIVATE_PATH__"
