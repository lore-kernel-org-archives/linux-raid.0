From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Array over arrays - how to autoassemble correctly?
Date: Wed, 27 Jan 2010 18:32:57 +0000
Message-ID: <73e903671001271032q1802c678i860744c72e2a92f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485f33abad07221047e29a2e6
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--001485f33abad07221047e29a2e6
Content-Type: text/plain; charset=ISO-8859-1

Hi all,

I'm running a RAID-60 array with mdadm. There are two RAID6 arrays,
/dev/md/d0 and d1, and then a RAID0 "meta-array" over that,
/dev/md/tank.

What happens on boot is that the d0 and d1 arrays are assembled, but
the tank array isn't - Ubuntu drops me to a root shell because it
couldn't find the tank partition for mounting from fstab. However, I
just have to do a simple 'mdadm --assemble --scan', and the tank array
pops up instantly and everything is fine.

How do I instruct mdadm to wait for d0 and d1 and do kind of a second
assembly pass to construct tank over them?

/proc/mdstat, output of 'mdadm --detail --scan' and
/etc/mdadm/mdadm.conf are included. I hope that's enough background
information.

Thanks!

-- Kristleifur

--001485f33abad07221047e29a2e6
Content-Type: text/plain; charset=US-ASCII; name="proc.mdstat.txt"
Content-Disposition: attachment; filename="proc.mdstat.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4yg9ud30

UGVyc29uYWxpdGllcyA6IFtsaW5lYXJdIFttdWx0aXBhdGhdIFtyYWlkMF0gW3JhaWQxXSBbcmFp
ZDZdIFtyYWlkNV0gW3JhaWQ0XSBbcmFpZDEwXQptZDEyNyA6IGFjdGl2ZSByYWlkMCBtZF9kMFsw
XSBtZF9kMVsxXQogICAgICAxMTcyMDMxNDM2OCBibG9ja3Mgc3VwZXIgMS4xIDI1NmsgY2h1bmtz
CgptZF9kMCA6IGFjdGl2ZSByYWlkNiBzZGgxWzJdIHNkZzFbMF0gc2RtMVs0XSBzZGsxWzVdIHNk
ajFbM10gc2RpMVsxXQogICAgICA1ODYwMTU3NDQwIGJsb2NrcyBzdXBlciAxLjEgbGV2ZWwgNiwg
MjU2ayBjaHVuaywgYWxnb3JpdGhtIDIgWzYvNl0gW1VVVVVVVV0KCm1kX2QxIDogYWN0aXZlIHJh
aWQ2IHNkZjFbMV0gc2RlMVswXSBzZGwxWzNdIHNkZDFbNl0gc2RjMVs1XSBzZGIxWzRdCiAgICAg
IDU4NjAxNTc0NDAgYmxvY2tzIHN1cGVyIDEuMSBsZXZlbCA2LCAyNTZrIGNodW5rLCBhbGdvcml0
aG0gMiBbNi82XSBbVVVVVVVVXQoKdW51c2VkIGRldmljZXM6IDxub25lPgoK
--001485f33abad07221047e29a2e6
Content-Type: text/plain; charset=US-ASCII; name="mdadm.detail.scan.txt"
Content-Disposition: attachment; filename="mdadm.detail.scan.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4yg9vfy1

QVJSQVkgL2Rldi9tZC9kMSBtZXRhZGF0YT0xLjAxIG5hbWU9bWFtbWE6ZDEgVVVJRD1kYTU0NzAy
MjowNDJhNmY2ODpkNWZlMjUxZTo1ZTg5ZjI2MwpBUlJBWSAvZGV2L21kL2QwIG1ldGFkYXRhPTEu
MDEgbmFtZT1tYW1tYTpkMCBVVUlEPTdmOThlOTI2OjIwNmE4ZWJlOjU5ZmM4ZDdiOjQ2NDRhODgz
CkFSUkFZIC9kZXYvbWQvdGFuayBtZXRhZGF0YT0xLjAxIG5hbWU9bWFtbWE6dGFuayBVVUlEPTZm
OThhN2E4OmQ3YjUwMTgxOjU4N2MyN2QxOjU5ZDZkMTM3Cgo=
--001485f33abad07221047e29a2e6
Content-Type: text/plain; charset=US-ASCII; name="mdadm.conf.txt"
Content-Disposition: attachment; filename="mdadm.conf.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4yg9w8n2

IyBtZGFkbS5jb25mCiMKCiMgYnkgZGVmYXVsdCwgc2NhbiBhbGwgcGFydGl0aW9ucyAoL3Byb2Mv
cGFydGl0aW9ucykgZm9yIE1EIHN1cGVyYmxvY2tzLgojIGFsdGVybmF0aXZlbHksIHNwZWNpZnkg
ZGV2aWNlcyB0byBzY2FuLCB1c2luZyB3aWxkY2FyZHMgaWYgZGVzaXJlZC4KREVWSUNFIHBhcnRp
dGlvbnMgL2Rldi9tZC9kMCAvZGV2L21kL2QxCgojIGF1dG8tY3JlYXRlIGRldmljZXMgd2l0aCBE
ZWJpYW4gc3RhbmRhcmQgcGVybWlzc2lvbnMKIyBDUkVBVEUgb3duZXI9cm9vdCBncm91cD1kaXNr
IG1vZGU9MDY2MCBhdXRvPW1kcAoKIyBhdXRvbWF0aWNhbGx5IHRhZyBuZXcgYXJyYXlzIGFzIGJl
bG9uZ2luZyB0byB0aGUgbG9jYWwgc3lzdGVtCkhPTUVIT1NUIDxzeXN0ZW0+CgojIGRlZmluaXRp
b25zIG9mIGV4aXN0aW5nIE1EIGFycmF5cwoKQVJSQVkgL2Rldi9tZC9kMCBtZXRhZGF0YT0xLjEg
bmFtZT1tYW1tYTpkMCBVVUlEPTdmOThlOTI2OjIwNmE4ZWJlOjU5ZmM4ZDdiOjQ2NDRhODgzIGxl
dmVsPXJhaWQ2IG51bS1kZXZpY2VzPTYgIyBjb250YWluZXI9NmY5OGE3YTg6ZDdiNTAxODE6NTg3
YzI3ZDE6NTlkNmQxMzcKCkFSUkFZIC9kZXYvbWQvZDEgbWV0YWRhdGE9MS4xIG5hbWU9bWFtbWE6
ZDEgVVVJRD1kYTU0NzAyMjowNDJhNmY2ODpkNWZlMjUxZTo1ZTg5ZjI2MyBsZXZlbD1yYWlkNiBu
dW0tZGV2aWNlcz02ICMgY29udGFpbmVyPTZmOThhN2E4OmQ3YjUwMTgxOjU4N2MyN2QxOjU5ZDZk
MTM3CgpBUlJBWSAvZGV2L21kL3RhbmsgbWV0YWRhdGE9MS4xIG5hbWU9bWFtbWE6dGFuayBVVUlE
PTZmOThhN2E4OmQ3YjUwMTgxOjU4N2MyN2QxOjU5ZDZkMTM3IGxldmVsPXJhaWQwIG51bS1kZXZp
Y2VzPTIgZGV2aWNlcz0vZGV2L21kL2QwLC9kZXYvbWQvZDEKCg==
--001485f33abad07221047e29a2e6--
