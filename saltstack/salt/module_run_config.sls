module_run_config:
  file.append:
    - name: C:\salt\conf\minion
    - text: |
        use_superseded:
          - module.run
  cmd.run:
    - name: 'C:\salt\salt-call.bat service.restart salt-minion'
    - onchanges:
      - file: C:\salt\conf\minion

