win_enable_administrator:
  module.run:
    - user.update:
      - name: Administrator
      - password: {{ pillar['admin_password']}}
      - account_disabled: false
      - expired: false