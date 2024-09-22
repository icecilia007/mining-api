variable "function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "source_file" {
  description = "Arquivo fonte da Lambda (caminho para o código Python)"
  type        = string
}

variable "handler" {
  description = "Handler da função Lambda (ex: file_name.function_name)"
  type        = string
}

variable "runtime" {
  description = "Runtime da Lambda (ex: python3.10)"
  type        = string
  default     = "python3.10"
}

variable "timeout" {
  description = "Timeout da função Lambda em segundos"
  type        = number
  default     = 900
}

variable "memory_size" {
  description = "Tamanho da memória da Lambda em MB"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Variáveis de ambiente para a função Lambda"
  type        = map(string)
  default     = {}
}

variable "max_event_age_in_seconds" {
  description = "Tempo máximo em segundos para eventos Lambda"
  type        = number
  default     = 21600
}

variable "max_retry_attempts" {
  description = "Número máximo de tentativas de re-execução para eventos"
  type        = number
  default     = 0
}

variable "additional_policies" {
  description = "Lista de ARNs de políticas adicionais para anexar à role da Lambda"
  type        = list(string)
  default     = []
}
variable "env" {
  type = string
  default = "prod"
}
variable "s3name" {
  type = string
  default = "exemplo"
}
variable "project" {
  type = string
  default = "mining-api"
}