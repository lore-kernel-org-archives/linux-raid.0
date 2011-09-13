From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Tue, 13 Sep 2011 20:56:42 +0200
Message-ID: <4E6FA76A.90206@truschnigg.info>
References: <4E6F13F7.6070507@truschnigg.info> <4E6F4091.7050206@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050200070105030901050506"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E6F4091.7050206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050200070105030901050506
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Phil,

first of all, thanks for replying and providing both technical and moral
support ;) As it turned out today, I won't be able to get my hands on
the box for at least another 12 hours, so I can only speculate what 
happened (at the physical/hardware level, that is) still.

On 09/13/2011 01:37 PM, Phil Turmel wrote:
> Simultaneous failure of that many devices strains credulity, so I
> doubt you've lost your array.  One possible variant of "2" would be a
> failed drive that draws enough current to drop the voltage to its
> sibling drives.

All the drives are located in seperate hot-swap trays with a full,
unoccupied 5.25" slot in between them. If my appartment wasn't set on
fire with half the drives roasting in it, I think bad cooling can be 
ruled out - the drives never went over 40°C even with all case fans 
turned off.

The controller seems alive still - lsdrv (output attached) lists the
kernel still having registered some of the component devices.

> Since some drives are still "alive", they'll have newer event counts
>  than the devices that went offline.  When you fix the root cause,
> you may need to use "--assemble --force" to get mdadm to restart your
> array.

I see - I don't have the interim storage capacity to dump the drives
before trying to do so - is there any advice you can offer to do this
assembly procedure in the safest way possible?

> The output of "lsdrv" [1] would be helpful in offering more specific
>  advice, along with "mdadm -D" of the array and "mdadm -E" of all of
>  its components (when you get them back).

I will provide the components' info asap.

Thanks very much for sharing your input and expertise!

-- 
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www: http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--------------050200070105030901050506
Content-Type: text/plain;
 name="lsdrv.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsdrv.txt"

UENJIFtwYXRhX2FtZF0gMDA6MDYuMCBJREUgaW50ZXJmYWNlOiBuVmlkaWEgQ29ycG9yYXRp
b24gTUNQNzhTIFtHZUZvcmNlIDgyMDBdIElERSAocmV2IGExKQog4pSc4pSAc2NzaSAwOjA6
MDowIEFUQSBUUkFOU0NFTkQgezIwMDkwNjI1X0Q0MEQ1MUJCfQog4pSCICDilJTilIBzZGE6
IFs4OjBdIFBhcnRpdGlvbmVkIChkb3MpIDEuODdnCiDilIIgICAgIOKUlOKUgHNkYTE6IFs4
OjFdIChleHQyKSAxLjg3ZyAnVklSVFVFJyB7ZmY1ODZiY2QtYjFmZC00YzA4LWEwZWEtMDhl
MmUxYzdiOGY5fQog4pSCICAgICAgICDilJzilIBNb3VudGVkIGFzIC9kZXYvcm9vdCBAIC8K
IOKUgiAgICAgICAg4pSU4pSATW91bnRlZCBhcyAvZGV2L3Jvb3QgQCAvc3J2L3dlYi92aXJ0
dWUKIOKUlOKUgHNjc2kgMTp4Ong6eCBbRW1wdHldClBDSSBbYWhjaV0gMDA6MDkuMCBTQVRB
IGNvbnRyb2xsZXI6IG5WaWRpYSBDb3Jwb3JhdGlvbiBNQ1A3OFMgW0dlRm9yY2UgODIwMF0g
QUhDSSBDb250cm9sbGVyIChyZXYgYTIpCiDilJzilIBzY3NpIDI6eDp4OnggW0VtcHR5XQog
4pSc4pSAc2NzaSAzOng6eDp4IFtFbXB0eV0KIOKUlOKUgHNjc2kgNzp4Ong6eCBbRW1wdHld
Ck90aGVyIEJsb2NrIERldmljZXMKIOKUnOKUgGRtLTA6IFsyNTM6MF0gKGV4dDQpIDUuNDZ0
ICdNQUlOX1NUT1JBR0UnIHthZmYzM2YyYS0xZGFjLTQ3ZTUtYTllZC0wNWUyNGQzYmRhMTV9
CiDilIIgIOKUnOKUgE1vdW50ZWQgYXMgL2Rldi9tYXBwZXIvVkdfU1RPUkFHRS1MVl9NQUlO
IEAgL21lZGlhL3ZpcnR1ZV9tYWluCiDilIIgIOKUlOKUgE1vdW50ZWQgYXMgL2Rldi9tYXBw
ZXIvVkdfU1RPUkFHRS1MVl9NQUlOIEAgL3Nydi9maWxlcwog4pSc4pSAbWQwOiBbOTowXSBF
bXB0eS9Vbmtub3duIDUuNDZ0Cgo=
--------------050200070105030901050506
Content-Type: text/plain;
 name="md0-examine.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="md0-examine.txt"

L2Rldi9tZDA6CiAgICAgICAgVmVyc2lvbiA6IDEuMgogIENyZWF0aW9uIFRpbWUgOiBUdWUg
RGVjIDIxIDEwOjI1OjMyIDIwMTAKICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgICBBcnJh
eSBTaXplIDogNTg2MDU0ODYwOCAoNTU4OS4wNSBHaUIgNjAwMS4yMCBHQikKICBVc2VkIERl
diBTaXplIDogMTQ2NTEzNzE1MiAoMTM5Ny4yNiBHaUIgMTUwMC4zMCBHQikKICAgUmFpZCBE
ZXZpY2VzIDogNQogIFRvdGFsIERldmljZXMgOiAzCiAgICBQZXJzaXN0ZW5jZSA6IFN1cGVy
YmxvY2sgaXMgcGVyc2lzdGVudAoKICBJbnRlbnQgQml0bWFwIDogSW50ZXJuYWwKCiAgICBV
cGRhdGUgVGltZSA6IFR1ZSBTZXAgMTMgMTA6MTU6NDkgMjAxMQogICAgICAgICAgU3RhdGUg
OiBhY3RpdmUsIEZBSUxFRAogQWN0aXZlIERldmljZXMgOiAwCldvcmtpbmcgRGV2aWNlcyA6
IDAKIEZhaWxlZCBEZXZpY2VzIDogMwogIFNwYXJlIERldmljZXMgOiAwCgogICAgICAgICBM
YXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwogICAgIENodW5rIFNpemUgOiA1MTJLCgogICAgTnVt
YmVyICAgTWFqb3IgICBNaW5vciAgIFJhaWREZXZpY2UgU3RhdGUKICAgICAgIDAgICAgICAg
MCAgICAgICAgMCAgICAgICAgMCAgICAgIHJlbW92ZWQKICAgICAgIDEgICAgICAgMCAgICAg
ICAgMCAgICAgICAgMSAgICAgIHJlbW92ZWQKICAgICAgIDIgICAgICAgMCAgICAgICAgMCAg
ICAgICAgMiAgICAgIHJlbW92ZWQKICAgICAgIDMgICAgICAgMCAgICAgICAgMCAgICAgICAg
MyAgICAgIHJlbW92ZWQKICAgICAgIDQgICAgICAgMCAgICAgICAgMCAgICAgICAgNCAgICAg
IHJlbW92ZWQKCiAgICAgICAxICAgICAgIDggICAgICAgNjQgICAgICAgIC0gICAgICBmYXVs
dHkgc3BhcmUKICAgICAgIDIgICAgICAgOCAgICAgICA0OCAgICAgICAgLSAgICAgIGZhdWx0
eSBzcGFyZQogICAgICAgNSAgICAgICA4ICAgICAgIDgwICAgICAgICAtICAgICAgZmF1bHR5
IHNwYXJlCg==
--------------050200070105030901050506--
