#!/usr/bin/env python3


"""
        github: git@github.com:edanote/system.git
        wechat subscription account : edanote
"""

import re
import xlrd

staff_excel = xlrd.open_workbook("server.xlsx")
sheet_names = staff_excel.sheet_names()

with open("cobbler_hosts.sh", "w") as cobblerfd:
    print("# add cobbler system", file=cobblerfd)
with open("hosts", "w") as hostsfd:
    print("# computer hosts list", file=hostsfd)
with open("ansible.host", "w") as ansiblefd:
    print("# add ansible hosts list", file=ansiblefd)

cobblerfd = open("cobbler_hosts.sh", "a")
hostsfd = open("hosts", "a")
ansiblefd = open("ansible.host", "a")

for sheet_name in sheet_names:
    sheet = staff_excel.sheet_by_name(sheet_name)
    nrows = sheet.nrows
    ncols = sheet.ncols
    print("", file=hostsfd)
    print(f"", file=ansiblefd)
    print(f"[{sheet_name}]", file=ansiblefd)
    for row in range(1, nrows):
        command_add = "cobbler system add"
        hosts = ""
        for col in range(0, ncols):
            command_add = f"{command_add} {sheet.cell(0, col).value}={sheet.cell(row, col).value}"
            if sheet.cell(0, col).value == "--name":
                command_promotion = f"echo setting {sheet.cell(row, col).value}"
                command_remove = f"if [ `cobbler system find | grep \"^{sheet.cell(row, col).value}$\"` ]; then\n    cobbler system remove {sheet.cell(0, col).value}={sheet.cell(row, col).value}\nfi"
            if sheet.cell(0, col).value == "--hostname":
                hosts = f"{hosts} {sheet.cell(row, col).value}"
                hostname = f"{sheet.cell(row, col).value}"
            if sheet.cell(0, col).value == "--ip-address":
                hosts = f"{sheet.cell(row, col).value}  {hosts}"
        print("", file=cobblerfd)
        print(command_promotion, file=cobblerfd)
        print(command_remove, file=cobblerfd)
        print(command_add, file=cobblerfd)

        print(hosts, file=hostsfd)

        print(f"{hostname}", file=ansiblefd)

        # openlava
