From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: All spares in Raid 5, default chunk? version of mdadm significant?
Date: Fri, 22 Jun 2012 17:54:11 +0530
Message-ID: <CAK-d5dbPH-LEqqbADuex+S+s4Me8EgR-ixQLehizQP5haAAG_A@mail.gmail.com>
References: <CAK-d5dYwa69wcSGX-u97WmJbMceEX2D1wiXRea-mS+X+i9Dyyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00248c76912edfca5104c30eb690
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dYwa69wcSGX-u97WmJbMceEX2D1wiXRea-mS+X+i9Dyyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--00248c76912edfca5104c30eb690
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
=A0I have a 6 device raid 5 array which had 1 disk go bad and then due to a
power outage, the machine shutdown and when it started all the disks were
showing up as spares with the following mdadm -E output (sample for one
given below and full for all devices attached).

This md device was part a Physical Volume for a LVM Volume Group.

I am trying to recreate the array using mdadm --create --assume-clean using
1 device as missing. I am checking if the device is getting created
correctly by checking the UUID of the created device which would match if
the device gets created correctly.

I have tried a few combinations of the disk order that I believe is right
however I think I'm getting tripped up by the fact that the mdadm I used to
create this md device was some 2.x series and now we are on 3.x (and I may
have taken some of the defaults originally which I don't' remember)
What all 'defaults' have changed over the versions so I can try those? Like
chunk size? Can we manually configure the super/data offset? Are those
significant when we do an mdadm --create --assume-clean?

Thanks,
Anshu

/dev/sda5:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x0
=A0 =A0 =A0Array UUID : b480fe0c:c9e29256:0fcf1b0c:1f8c762c
=A0 =A0 =A0 =A0 =A0 =A0Name : GATEWAY:RAID5_500G
=A0 Creation Time : Wed Apr 28 16:10:43 2010
=A0 =A0 =A0Raid Level : -unknown-
=A0 =A0Raid Devices : 0

=A0Avail Dev Size : 976768002 (465.76 GiB 500.11 GB)
=A0 Used Dev Size : 976765954 (465.76 GiB 500.10 GB)
=A0 =A0 Data Offset : 2048 sectors
=A0 =A0Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0 State : active
=A0 =A0 Device UUID : a8499a91:628ddde8:1cc8f4b9:749136f9

=A0 =A0 Update Time : Sat May 19 23:04:23 2012
=A0 =A0 =A0 =A0Checksum : 9950883c - correct
=A0 =A0 =A0 =A0 =A0Events : 1


=A0 =A0Device Role : spare
=A0 =A0Array State : =A0('A' =3D=3D active, '.' =3D=3D missing)

--00248c76912edfca5104c30eb690
Content-Type: text/plain; charset=US-ASCII; name="md5.txt"
Content-Disposition: attachment; filename="md5.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3r7qyc30

L2Rldi9zZGE1OgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGI0ODBmZTBjOmM5ZTI5
MjU2OjBmY2YxYjBjOjFmOGM3NjJjCiAgICAgICAgICAgTmFtZSA6IEdBVEVXQVk6UkFJRDVfNTAw
RwogIENyZWF0aW9uIFRpbWUgOiBXZWQgQXByIDI4IDE2OjEwOjQzIDIwMTAKICAgICBSYWlkIExl
dmVsIDogLXVua25vd24tCiAgIFJhaWQgRGV2aWNlcyA6IDAKCiBBdmFpbCBEZXYgU2l6ZSA6IDk3
Njc2ODAwMiAoNDY1Ljc2IEdpQiA1MDAuMTEgR0IpCiAgVXNlZCBEZXYgU2l6ZSA6IDk3Njc2NTk1
NCAoNDY1Ljc2IEdpQiA1MDAuMTAgR0IpCiAgICBEYXRhIE9mZnNldCA6IDIwNDggc2VjdG9ycwog
ICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgICAgICAgIFN0YXRlIDogYWN0aXZlCiAgICBE
ZXZpY2UgVVVJRCA6IGE4NDk5YTkxOjYyOGRkZGU4OjFjYzhmNGI5Ojc0OTEzNmY5CgogICAgVXBk
YXRlIFRpbWUgOiBTYXQgTWF5IDE5IDIzOjA0OjIzIDIwMTIKICAgICAgIENoZWNrc3VtIDogOTk1
MDg4M2MgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDEKCgogICBEZXZpY2UgUm9sZSA6IHNw
YXJlCiAgIEFycmF5IFN0YXRlIDogICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZykKL2Rl
di9zZGI1OgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAxLjIK
ICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGI0ODBmZTBjOmM5ZTI5MjU2
OjBmY2YxYjBjOjFmOGM3NjJjCiAgICAgICAgICAgTmFtZSA6IEdBVEVXQVk6UkFJRDVfNTAwRwog
IENyZWF0aW9uIFRpbWUgOiBXZWQgQXByIDI4IDE2OjEwOjQzIDIwMTAKICAgICBSYWlkIExldmVs
IDogLXVua25vd24tCiAgIFJhaWQgRGV2aWNlcyA6IDAKCiBBdmFpbCBEZXYgU2l6ZSA6IDk3Njc2
NTk1NCAoNDY1Ljc2IEdpQiA1MDAuMTAgR0IpCiAgICBEYXRhIE9mZnNldCA6IDIwNDggc2VjdG9y
cwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgICAgICAgIFN0YXRlIDogYWN0aXZlCiAg
ICBEZXZpY2UgVVVJRCA6IDZhOGIyMWQ5OmRiNTNjYTM0OjVjOWExYmFhOjVlNTc4MmFlCgogICAg
VXBkYXRlIFRpbWUgOiBTYXQgTWF5IDE5IDIzOjA0OjIzIDIwMTIKICAgICAgIENoZWNrc3VtIDog
ZDIzNzIwOWUgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDEKCgogICBEZXZpY2UgUm9sZSA6
IHNwYXJlCiAgIEFycmF5IFN0YXRlIDogICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZykK
L2Rldi9zZGM1OgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGI0ODBmZTBjOmM5ZTI5
MjU2OjBmY2YxYjBjOjFmOGM3NjJjCiAgICAgICAgICAgTmFtZSA6IEdBVEVXQVk6UkFJRDVfNTAw
RwogIENyZWF0aW9uIFRpbWUgOiBXZWQgQXByIDI4IDE2OjEwOjQzIDIwMTAKICAgICBSYWlkIExl
dmVsIDogLXVua25vd24tCiAgIFJhaWQgRGV2aWNlcyA6IDAKCiBBdmFpbCBEZXYgU2l6ZSA6IDk3
Njc2NzczMCAoNDY1Ljc2IEdpQiA1MDAuMTEgR0IpCiAgVXNlZCBEZXYgU2l6ZSA6IDk3Njc2NTk1
NCAoNDY1Ljc2IEdpQiA1MDAuMTAgR0IpCiAgICBEYXRhIE9mZnNldCA6IDI3MiBzZWN0b3JzCiAg
IFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBhY3RpdmUKICAgIERl
dmljZSBVVUlEIDogZjZhMTA4OTY6NDUzZGI1MDM6NmVlNzk3ZjY6YzNlODI2NjAKCiAgICBVcGRh
dGUgVGltZSA6IFNhdCBNYXkgMTkgMjM6MDQ6MjMgMjAxMgogICAgICAgQ2hlY2tzdW0gOiA1YzI5
ZmYwOSAtIGNvcnJlY3QKICAgICAgICAgRXZlbnRzIDogMQoKCiAgIERldmljZSBSb2xlIDogc3Bh
cmUKICAgQXJyYXkgU3RhdGUgOiAgKCdBJyA9PSBhY3RpdmUsICcuJyA9PSBtaXNzaW5nKQovZGV2
L3NkZDU6CiAgICAgICAgICBNYWdpYyA6IGE5MmI0ZWZjCiAgICAgICAgVmVyc2lvbiA6IDEuMgog
ICAgRmVhdHVyZSBNYXAgOiAweDAKICAgICBBcnJheSBVVUlEIDogYjQ4MGZlMGM6YzllMjkyNTY6
MGZjZjFiMGM6MWY4Yzc2MmMKICAgICAgICAgICBOYW1lIDogR0FURVdBWTpSQUlENV81MDBHCiAg
Q3JlYXRpb24gVGltZSA6IFdlZCBBcHIgMjggMTY6MTA6NDMgMjAxMAogICAgIFJhaWQgTGV2ZWwg
OiAtdW5rbm93bi0KICAgUmFpZCBEZXZpY2VzIDogMAoKIEF2YWlsIERldiBTaXplIDogOTc2NzY1
OTU0ICg0NjUuNzYgR2lCIDUwMC4xMCBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0OCBzZWN0b3Jz
CiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBhY3RpdmUKICAg
IERldmljZSBVVUlEIDogNTU2ODk1ZWY6ZDY4Mzc4Njg6MmNjYTJjMTc6NDE5NzI1ZTkKCiAgICBV
cGRhdGUgVGltZSA6IFNhdCBNYXkgMTkgMjM6MDQ6MjMgMjAxMgogICAgICAgQ2hlY2tzdW0gOiBj
NDBkOWQzMyAtIGNvcnJlY3QKICAgICAgICAgRXZlbnRzIDogMQoKCiAgIERldmljZSBSb2xlIDog
c3BhcmUKICAgQXJyYXkgU3RhdGUgOiAgKCdBJyA9PSBhY3RpdmUsICcuJyA9PSBtaXNzaW5nKQov
ZGV2L3NkZTU6CiAgICAgICAgICBNYWdpYyA6IGE5MmI0ZWZjCiAgICAgICAgVmVyc2lvbiA6IDEu
MgogICAgRmVhdHVyZSBNYXAgOiAweDAKICAgICBBcnJheSBVVUlEIDogYjQ4MGZlMGM6YzllMjky
NTY6MGZjZjFiMGM6MWY4Yzc2MmMKICAgICAgICAgICBOYW1lIDogR0FURVdBWTpSQUlENV81MDBH
CiAgQ3JlYXRpb24gVGltZSA6IFdlZCBBcHIgMjggMTY6MTA6NDMgMjAxMAogICAgIFJhaWQgTGV2
ZWwgOiAtdW5rbm93bi0KICAgUmFpZCBEZXZpY2VzIDogMAoKIEF2YWlsIERldiBTaXplIDogOTc2
NzY1OTU0ICg0NjUuNzYgR2lCIDUwMC4xMCBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0OCBzZWN0
b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBhY3RpdmUK
ICAgIERldmljZSBVVUlEIDogZTVlMDhiNzM6NzhiNTI4Nzk6MDlhYTc2NWU6MTcwMDVhODIKCiAg
ICBVcGRhdGUgVGltZSA6IFNhdCBNYXkgMTkgMjM6MDQ6MjMgMjAxMgogICAgICAgQ2hlY2tzdW0g
OiAzOTMyOTAxZCAtIGNvcnJlY3QKICAgICAgICAgRXZlbnRzIDogMQoKCiAgIERldmljZSBSb2xl
IDogc3BhcmUKICAgQXJyYXkgU3RhdGUgOiAgKCdBJyA9PSBhY3RpdmUsICcuJyA9PSBtaXNzaW5n
KQo=
--00248c76912edfca5104c30eb690--
