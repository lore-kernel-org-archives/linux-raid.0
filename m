From: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Subject: Promise RAID PDC20378 performance (Asus K8V SE Deluxe) (fwd)
Date: Thu, 24 Feb 2005 17:24:53 +0200 (EET)
Message-ID: <Pine.OSF.4.61.0502241723260.1512@soul.it.helsinki.fi>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="1824380544-815171706-1109253856=:523781"
Content-ID: <Pine.OSF.4.61.0502241723261.1512@soul.it.helsinki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1824380544-815171706-1109253856=:523781
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Pine.OSF.4.61.0502241723262.1512@soul.it.helsinki.fi>


Hello All!

Perhaps there's interest for the below on this list also:

---------- Forwarded message ----------

On ???, ?? Feb 2005, Goswin von Brederlow wrote:

>>> I got 2 new SATA drives and pluged them into the onboard Promise
>>> PDC20376 (FastTrak 376) and run badblocks on them (both in
>>> parallel). The write test completed fine but read&compare locked up my
>>> system.
>>> I repeated with a read-only test and again it locked up with an DMA
>>> timeout.
>>> Does anyone have the onboard Promise successfully in use on an Asus
>>> K8V board?

I tested the performance of the Promise controller on an Asus K8V SE Deluxe 
M/B, comparing to the on-board VIA VT8237. The Promise controller is slightly 
different from yours, being PDC20378.

The system was installed with the latest netinst image, sid-amd64-netinst.iso, 
19-Feb-2005, kernel 2.6.8-10. The disk test was run on an XFS software RAID-0 
partition. The two SATA disks are 200 GB Seagate Barracudas. Testing was done 
with bonnie++, using a 1 GB file size with the system RAM set to 256 MB 
(bonnie++ -u root -s 1g).

The tests did run smoothly on both the on-board and Promise SATA controllers. 
The Promise controller is, however, greatly inferior in speed. For example, VIA 
write speed is over 60% higher! The CPU load, on the other hand, is 
substantially higher with VIA.

Summary (average of two runs):
              VIA VT8237  Promise PDC20378
write speed:   131 MB/s     80 MB/s
  read speed:   124 MB/s    101 MB/s

I've attached the full bonnie++ outputs to this mail.

Have a nice day,
     Mikael J.
     http://www.helsinki.fi/~mpjohans/
--1824380544-815171706-1109253856=:523781
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="bonnie-via-1.out"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.OSF.4.61.0502241604150.523781@soul.it.helsinki.fi>
Content-Description: via-1
Content-Disposition: ATTACHMENT; FILENAME="bonnie-via-1.out"

VmVyc2lvbiAgMS4wMyAgICAgICAtLS0tLS1TZXF1ZW50aWFsIE91dHB1dC0t
LS0tLSAtLVNlcXVlbnRpYWwgSW5wdXQtIC0tUmFuZG9tLQ0KICAgICAgICAg
ICAgICAgICAgICAtUGVyIENoci0gLS1CbG9jay0tIC1SZXdyaXRlLSAtUGVy
IENoci0gLS1CbG9jay0tIC0tU2Vla3MtLQ0KTWFjaGluZSAgICAgICAgU2l6
ZSBLL3NlYyAlQ1AgSy9zZWMgJUNQIEsvc2VjICVDUCBLL3NlYyAlQ1AgSy9z
ZWMgJUNQICAvc2VjICVDUA0KbWFnbmVzaXVtICAgICAgICAxRyA2MzQwMyAg
OTYgMTM2NDU5ICAzMCA0MzIyMSAgMTAgNTY5MTkgIDg2IDEyNjMzNyAgMTQg
MjU0LjUgICAwDQogICAgICAgICAgICAgICAgICAgIC0tLS0tLVNlcXVlbnRp
YWwgQ3JlYXRlLS0tLS0tIC0tLS0tLS0tUmFuZG9tIENyZWF0ZS0tLS0tLS0t
DQogICAgICAgICAgICAgICAgICAgIC1DcmVhdGUtLSAtLVJlYWQtLS0gLURl
bGV0ZS0tIC1DcmVhdGUtLSAtLVJlYWQtLS0gLURlbGV0ZS0tDQogICAgICAg
ICAgICAgIGZpbGVzICAvc2VjICVDUCAgL3NlYyAlQ1AgIC9zZWMgJUNQICAv
c2VjICVDUCAgL3NlYyAlQ1AgIC9zZWMgJUNQDQogICAgICAgICAgICAgICAg
IDE2ICA2NTc3ICAzMiArKysrKyArKysgIDY2NjQgIDIyICA0MzYxICAyNCAr
KysrKyArKysgIDUzNzEgIDIwDQptYWduZXNpdW0sMUcsNjM0MDMsOTYsMTM2
NDU5LDMwLDQzMjIxLDEwLDU2OTE5LDg2LDEyNjMzNywxNCwyNTQuNSwwLDE2
LDY1NzcsMzIsKysrKyssKysrLDY2NjQsMjIsNDM2MSwyNCwrKysrKywrKyss
NTM3MSwyMA0K

--1824380544-815171706-1109253856=:523781
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="bonnie-via-2.out"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.OSF.4.61.0502241604151.523781@soul.it.helsinki.fi>
Content-Description: via-2
Content-Disposition: ATTACHMENT; FILENAME="bonnie-via-2.out"

VmVyc2lvbiAgMS4wMyAgICAgICAtLS0tLS1TZXF1ZW50aWFsIE91dHB1dC0t
LS0tLSAtLVNlcXVlbnRpYWwgSW5wdXQtIC0tUmFuZG9tLQ0KICAgICAgICAg
ICAgICAgICAgICAtUGVyIENoci0gLS1CbG9jay0tIC1SZXdyaXRlLSAtUGVy
IENoci0gLS1CbG9jay0tIC0tU2Vla3MtLQ0KTWFjaGluZSAgICAgICAgU2l6
ZSBLL3NlYyAlQ1AgSy9zZWMgJUNQIEsvc2VjICVDUCBLL3NlYyAlQ1AgSy9z
ZWMgJUNQICAvc2VjICVDUA0KbWFnbmVzaXVtICAgICAgICAxRyA2MzE1MiAg
OTYgMTMyNjQyICAzMCA0ODU2NSAgMTIgNTc5NzMgIDg4IDEyNzA1MiAgMTQg
MjY1LjIgICAwDQogICAgICAgICAgICAgICAgICAgIC0tLS0tLVNlcXVlbnRp
YWwgQ3JlYXRlLS0tLS0tIC0tLS0tLS0tUmFuZG9tIENyZWF0ZS0tLS0tLS0t
DQogICAgICAgICAgICAgICAgICAgIC1DcmVhdGUtLSAtLVJlYWQtLS0gLURl
bGV0ZS0tIC1DcmVhdGUtLSAtLVJlYWQtLS0gLURlbGV0ZS0tDQogICAgICAg
ICAgICAgIGZpbGVzICAvc2VjICVDUCAgL3NlYyAlQ1AgIC9zZWMgJUNQICAv
c2VjICVDUCAgL3NlYyAlQ1AgIC9zZWMgJUNQDQogICAgICAgICAgICAgICAg
IDE2ICA1NTIxICAyOCArKysrKyArKysgIDYyNDQgIDIwICA0NTU3ICAyNCAr
KysrKyArKysgIDQ4NTEgIDE5DQptYWduZXNpdW0sMUcsNjMxNTIsOTYsMTMy
NjQyLDMwLDQ4NTY1LDEyLDU3OTczLDg4LDEyNzA1MiwxNCwyNjUuMiwwLDE2
LDU1MjEsMjgsKysrKyssKysrLDYyNDQsMjAsNDU1NywyNCwrKysrKywrKyss
NDg1MSwxOQ0K

--1824380544-815171706-1109253856=:523781
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="bonnie-promise-1.out"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.OSF.4.61.0502241604152.523781@soul.it.helsinki.fi>
Content-Description: promise-1
Content-Disposition: ATTACHMENT; FILENAME="bonnie-promise-1.out"

VmVyc2lvbiAgMS4wMyAgICAgICAtLS0tLS1TZXF1ZW50aWFsIE91dHB1dC0t
LS0tLSAtLVNlcXVlbnRpYWwgSW5wdXQtIC0tUmFuZG9tLQ0KICAgICAgICAg
ICAgICAgICAgICAtUGVyIENoci0gLS1CbG9jay0tIC1SZXdyaXRlLSAtUGVy
IENoci0gLS1CbG9jay0tIC0tU2Vla3MtLQ0KTWFjaGluZSAgICAgICAgU2l6
ZSBLL3NlYyAlQ1AgSy9zZWMgJUNQIEsvc2VjICVDUCBLL3NlYyAlQ1AgSy9z
ZWMgJUNQICAvc2VjICVDUA0KbWFnbmVzaXVtICAgICAgICAxRyA2Mjc4MSAg
OTYgODE3NzMgIDE3IDMyODAwICAgNyA0ODEyOSAgNjAgMTAzNDYyICAgOSAy
NjEuNiAgIDANCiAgICAgICAgICAgICAgICAgICAgLS0tLS0tU2VxdWVudGlh
bCBDcmVhdGUtLS0tLS0gLS0tLS0tLS1SYW5kb20gQ3JlYXRlLS0tLS0tLS0N
CiAgICAgICAgICAgICAgICAgICAgLUNyZWF0ZS0tIC0tUmVhZC0tLSAtRGVs
ZXRlLS0gLUNyZWF0ZS0tIC0tUmVhZC0tLSAtRGVsZXRlLS0NCiAgICAgICAg
ICAgICAgZmlsZXMgIC9zZWMgJUNQICAvc2VjICVDUCAgL3NlYyAlQ1AgIC9z
ZWMgJUNQICAvc2VjICVDUCAgL3NlYyAlQ1ANCiAgICAgICAgICAgICAgICAg
MTYgIDU1MDggIDIxICsrKysrICsrKyAgMzY0OCAgMTAgIDQ1NTcgIDE5ICsr
KysrICsrKyAgMzE5MiAgMTENCm1hZ25lc2l1bSwxRyw2Mjc4MSw5Niw4MTc3
MywxNywzMjgwMCw3LDQ4MTI5LDYwLDEwMzQ2Miw5LDI2MS42LDAsMTYsNTUw
OCwyMSwrKysrKywrKyssMzY0OCwxMCw0NTU3LDE5LCsrKysrLCsrKywzMTky
LDExDQo=

--1824380544-815171706-1109253856=:523781
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="bonnie-promise-2.out"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.OSF.4.61.0502241604160.523781@soul.it.helsinki.fi>
Content-Description: promise-2
Content-Disposition: ATTACHMENT; FILENAME="bonnie-promise-2.out"

VmVyc2lvbiAgMS4wMyAgICAgICAtLS0tLS1TZXF1ZW50aWFsIE91dHB1dC0t
LS0tLSAtLVNlcXVlbnRpYWwgSW5wdXQtIC0tUmFuZG9tLQ0KICAgICAgICAg
ICAgICAgICAgICAtUGVyIENoci0gLS1CbG9jay0tIC1SZXdyaXRlLSAtUGVy
IENoci0gLS1CbG9jay0tIC0tU2Vla3MtLQ0KTWFjaGluZSAgICAgICAgU2l6
ZSBLL3NlYyAlQ1AgSy9zZWMgJUNQIEsvc2VjICVDUCBLL3NlYyAlQ1AgSy9z
ZWMgJUNQICAvc2VjICVDUA0KbWFnbmVzaXVtICAgICAgICAxRyA2MjUyNiAg
OTYgODE5ODUgIDE3IDMyNzYwICAgNyA0OTEyMCAgNjIgMTAzMDM1ICAgOSAy
NTkuOCAgIDANCiAgICAgICAgICAgICAgICAgICAgLS0tLS0tU2VxdWVudGlh
bCBDcmVhdGUtLS0tLS0gLS0tLS0tLS1SYW5kb20gQ3JlYXRlLS0tLS0tLS0N
CiAgICAgICAgICAgICAgICAgICAgLUNyZWF0ZS0tIC0tUmVhZC0tLSAtRGVs
ZXRlLS0gLUNyZWF0ZS0tIC0tUmVhZC0tLSAtRGVsZXRlLS0NCiAgICAgICAg
ICAgICAgZmlsZXMgIC9zZWMgJUNQICAvc2VjICVDUCAgL3NlYyAlQ1AgIC9z
ZWMgJUNQICAvc2VjICVDUCAgL3NlYyAlQ1ANCiAgICAgICAgICAgICAgICAg
MTYgIDU4MDAgIDIyICsrKysrICsrKyAgMzc0NiAgMTEgIDQ1MTQgIDE3ICsr
KysrICsrKyAgMzE1NCAgMTENCm1hZ25lc2l1bSwxRyw2MjUyNiw5Niw4MTk4
NSwxNywzMjc2MCw3LDQ5MTIwLDYyLDEwMzAzNSw5LDI1OS44LDAsMTYsNTgw
MCwyMiwrKysrKywrKyssMzc0NiwxMSw0NTE0LDE3LCsrKysrLCsrKywzMTU0
LDExDQo=

--1824380544-815171706-1109253856=:523781--
