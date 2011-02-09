From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: Single-drive RAID0
Date: Wed, 9 Feb 2011 14:33:01 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
 <20110209134557.4e607451@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_BE2BFE91933D1B4089447C644860408068C4429Dirsmsx503gercor_"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209134557.4e607451@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--_002_BE2BFE91933D1B4089447C644860408068C4429Dirsmsx503gercor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Steps to reproduce:
1. Create partition on disk (for example: 1 partition, size=3Dhalf of /dev/=
sda disk)
2. Create filesystem on partition (ext3)
3. Mount partition and create some control data on partition
4. Unmount partition
5. Create RAID0 on disk (mdadm -C /dev/md/vol_1 -amd -e 0.9 -c 64 -l 0 -n 1=
 /dev/sda --force)
6. md127 and md127p1 appears in /dev as expected
7. Try to mount md127p1 and verify control data on them

Expected result:
md127p1 device mounted and control data not corrupted

Actual result:
1. Mount command returns error:
mount: special device /dev/md127p1 does not exists
2. md127p1 disappears from /dev/
3. kernel indefinitely shows (until array will be stop):
md126: p1
md126: detected capacity change from 0 to xxxxxxxxxxxxx
md126: p1
md126: detected capacity change from 0 to xxxxxxxxxxxxx
...


Additional Info:
Reproduced on:
- SLES11 SP1
- mdamd 3.2 from top of your devel-3.2 branch
- kernel 2.6.38 RC2

I've attached script that I use to reproduce this issue.
For native metadata run:
./raid_ready_drive native
For imsm metadata just:
./raid_ready_drive

Regards
Krzysztof



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, February 09, 2011 3:46 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Single-drive RAID0
>=20
> On Tue, 8 Feb 2011 16:15:53 +0000 "Wojcik, Krzysztof"
> <krzysztof.wojcik@intel.com> wrote:
>=20
> > Neil,
> >
> > I try to create a single-drive RAID0 array with data preservation.
> > It means I have a single disk with partitions and data on them.
> > I would like to migrate this single disk to RAID0 array and then grow
> it to N devices.
> > Of course I expect partitions with my useful data will be mapped to
> corresponding MD block devices (/dev/md126p1, /dev/md126p2 etc.).
> Indeed they are but when I try to mount new block device it disappears
> from /dev directory and mount is not succeeded.
>=20
> > /var/log/messages shows all the time:
> > md126: p1
> > md126: detected capacity change from 0 to xxxxxxxxxxxxx
> >
> > It is not always reproducible but very often.
> > I try this operation on 0.9 and imsm metadata. Symptoms are similar.
> >
> > Do you have any suggestions? How to fix this issue?
> >
> > Regards
> > Krzysztof
>=20
> It isn't clear to me what the issue is and when I try something that
> might be
> what you are suggesting it works perfectly every time.
>=20
> Maybe if you could provide something more detailed and specific.
> e.g. a series of steps that I can try together with all the messages
> you get
> (both from the kernel and from mdadm) throughout the process.
>=20
> That will probably help.
>=20
> NeilBrown

--_002_BE2BFE91933D1B4089447C644860408068C4429Dirsmsx503gercor_
Content-Type: application/octet-stream; name="raid_ready_drive"
Content-Description: raid_ready_drive
Content-Disposition: attachment; filename="raid_ready_drive"; size=2635;
	creation-date="Wed, 09 Feb 2011 14:31:26 GMT";
	modification-date="Wed, 09 Feb 2011 14:30:25 GMT"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKClYxTU5UPS9tbnQvdm9sMQpWMk1OVD0vbW50L3ZvbDIKQ09OVD0vZGV2L21k
L2ltc20wCkZJTEVfU0laRT0xMDAwMDAwMDAKQ0hVTks9MTI4CgojIGRlZmluZSBkaXNrIGZvciB0
ZXN0cwojZGlzaz0vZGV2L3NkYQoKTjE9L2Rldi9tZC92b2xfMQoKZnVuY3Rpb24gc3RhdCgpIHsK
IwlzZXQgK3gKCWlmIFsgJDEgIT0gJDIgXSA7IHRoZW4KCSAgICBlY2hvIC1lICJcbkNvbW1hbmQg
JDMgcmV0dXJuZWQgd3Jvbmcgc3RhdHVzIChleHBlY3RlZDogJDIsIGdvdDogJDEpXG4iCgkgICAg
ZXhpdCAxCglmaQojCXNldCAteAp9CgppZiBbIC16ICRkaXNrIF0gOyB0aGVuCgllY2hvICJEaXNr
IGZvciB0ZXN0IG5vdCBzcGVjaWZpZWQuIFBsZWFzZSBzZXQgXCJkaXNrXCIgdmFyaWFibGUuIgoJ
ZXhpdApmaQplY2hvICJEaXNrIHRvIHRlc3Q9ICRkaXNrIgoKaWYgWyAhIC1kICRWMU1OVCBdIDsg
dGhlbgogICAgbWtkaXIgJFYxTU5UCmZpCgppZiBbICEgLWQgJFYyTU5UIF0gOyB0aGVuCiAgICBt
a2RpciAkVjJNTlQKZmkKCiNzZXQgLXgKCiMjIyMjIyMjIyMjIyMjIyMjIyBjbGVhbnVwICMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKI3VubW91bnQKdW1vdW50ICRWMU1OVAp1bW91bnQgJFYy
TU5UCgojc3RvcApyZXM9MQp3aGlsZSBbICRyZXMgIT0gMCBdIDsgZG8KCW1kYWRtIC1TcwoJcmVz
PSQ/CmRvbmUKCiNjbGVhbgptZGFkbSAtLXplcm8tc3VwZXJibG9jayAkZGlzawoKCiMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwojIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIE1BSU4gIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCgojIyMj
IyMjIyMjIyMjIyMjIyMgcHJlcGFyZSBkaXNrIGZvciB0ZXN0cyAjIyMjIyMjIyMjIyMjIyMKCnNm
ZGlzayAtdU0gJGRpc2sgPDwgRU9GCiw1MDAwMCxMCiw1MDAwMCxMCkVPRgoKdWRldmFkbSBzZXR0
bGUKCglQMT0kZGlzaycxJwoJUDI9JGRpc2snMicKCW1rZnMgJFAxCglta2ZzICRQMgoKCW1vdW50
ICRQMSAkVjFNTlQKCW1vdW50ICRQMiAkVjJNTlQKCglvcGVuc3NsIHJhbmQgLW91dCAkVjFNTlQv
dGVzdDEuYmluICRGSUxFX1NJWkUKCVNVTTE9JChtZDVzdW0gJFYxTU5UL3Rlc3QxLmJpbiB8IGdh
d2sgJ3twcmludCAkMX0nKQoJb3BlbnNzbCByYW5kIC1vdXQgJFYyTU5UL3Rlc3QxLmJpbiAkRklM
RV9TSVpFCglTVU0yPSQobWQ1c3VtICRWMk1OVC90ZXN0MS5iaW4gfCBnYXdrICd7cHJpbnQgJDF9
JykKCgllY2hvICJTVU0xPSRTVU0xIiA+ICRTVU0KCWVjaG8gIlNVTTI9JFNVTTIiID4+ICRTVU0K
Cgl1bW91bnQgJFYxTU5UCgl1bW91bnQgJFYyTU5UCgojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMg
cnVuIHRlc3QgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCmlmIFtbICQxID0gIm5hdGl2ZSIgXV0g
OyB0aGVuCgkjY3JlYXRlIHZvbAoJbWRhZG0gLUMgJE4xIC1lIDAuOSAtYW1kIC1sIDAgLS1jaHVu
ayAkQ0hVTksgLW4gMSAkZGlzayAtUiAtLWZvcmNlCglzdGF0ICQ/IDAgY3JhZXRlX3ZvbDEKZWxz
ZQoJI2NyZWF0ZSBjb250YWluZXIKCW1kYWRtIC1DICRDT05UIC1hbWQgLWUgaW1zbSAtbiAxICRk
aXNrIC1SIC0tZm9yY2UKCXN0YXQgJD8gMCBjcmVhdGVfY29udGFpbmVyCgoJI2NyZWF0ZSB2b2wK
CW1kYWRtIC1DICROMSAtYW1kIC1sIDAgLS1jaHVuayAkQ0hVTksgLW4gMSAkZGlzayAtUiAtLWZv
cmNlCglzdGF0ICQ/IDAgY3JhZXRlX3ZvbDEKZmkKCiNjaGVjayBzdGF0dXMKY2F0IC9wcm9jL21k
c3RhdAoKdWRldmFkbSBzZXR0bGUKCmxzIC9kZXYgfCBncmVwIG1kCmxzIC9kZXYvbWQKCmxzIC9k
ZXYvbWQgfCBncmVwIHZvbF8xcDEgPiAvZGV2L251bGwKaWYgWyAkPyAhPSAwIF0gOyB0aGVuCgll
Y2hvICJFcnJvci4gUGFydGl0aW9uICMxIG5vdCBtYXBwZWQhIgoJZXhpdApmaQpscyAvZGV2L21k
IHwgZ3JlcCB2b2xfMXAyID4gL2Rldi9udWxsCmlmIFsgJD8gIT0gMCBdIDsgdGhlbgoJZWNobyAi
RXJyb3IuIFBhcnRpdGlvbiAjMiBub3QgbWFwcGVkISIKCWV4aXQKZmkKCiNtb3VudAptb3VudCAk
TjEncDEnICRWMU1OVApzdGF0ICQ/IDAgbW91bnRfdm9sMQoKbW91bnQgJE4xJ3AyJyAkVjJNTlQK
c3RhdCAkPyAwIG1vdW50X3ZvbDIKClNVTTFfQT0kKG1kNXN1bSAkVjFNTlQvdGVzdDEuYmluIHwg
Z2F3ayAne3ByaW50ICQxfScpClNVTTJfQT0kKG1kNXN1bSAkVjJNTlQvdGVzdDEuYmluIHwgZ2F3
ayAne3ByaW50ICQxfScpCgppZiBbWyAkU1VNMSAhPSAkU1VNMV9BIF1dIHx8IFtbICRTVU0yICE9
ICRTVU0yX0EgXV0gOyB0aGVuCiAgICAJZWNobyAiRXJyb3IuIFRlc3QgZmFpbGVkLiBtZDVzdW0g
b2YgZmlsZXMgbm90IGVxdWFsISIKZWxzZQogICAgZWNobyAiVGVzdCBQQVNTRUQhIgpmaQoKIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IwojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMgRU5EICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMKCg==

--_002_BE2BFE91933D1B4089447C644860408068C4429Dirsmsx503gercor_--
