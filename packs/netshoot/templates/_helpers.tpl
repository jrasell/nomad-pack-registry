[[- define "full_job_name" -]]
[[- if eq .netshoot.job_name "" -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .netshoot.job_name | quote -]]
[[- end -]]
[[- end -]]
