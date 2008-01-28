From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: BUG: possible array corruption when adding a component to a degraded
 raid5 (possibly other levels too)
Date: Mon, 28 Jan 2008 11:05:26 +0100
Message-ID: <479DA8E6.6040209@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000907060902080708020200"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000907060902080708020200
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

It seems that mdadm/md do not perform proper sanity checks before adding a 
component to a degraded array. If the size of the new component is just right, 
the superblock information will overlap with the data area. This will happen 
without any error indications in the syslog or otherwise.

I came up with a reproducible scenario which I am attaching to this email 
alongside with the entire test script. I have not tested it for other raid 
levels, or other types of superblocks, but I suspect the same problem will 
occur for many other configurations.

I am willing to test patches, however the attached script is non-intrusive 
enough to be executed anywhere.

The output of the script follows bellow.

Peter

======================================================================
======================================================================
======================================================================

root@Thesaurus:/media/space/testmd# ./md_overlap_test
Creating component 1 (1056768 bytes)... done.
Creating component 2 (1056768 bytes)... done.
Creating component 3 (1056768 bytes)... done.


===============================================================
Creating 3 disk raid5 array with v1.1 superblock
mdadm: array /dev/md9 started.
Waiting for resync to finish... done.

md9 : active raid5 loop3[3] loop2[1] loop1[0]
       2048 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

Initial checksum of raw raid5 device: 4df1921524a3b717a956fceaed0ae691  /dev/md9


===============================================================
Failing first componnent
mdadm: set /dev/loop1 faulty in /dev/md9
mdadm: hot removed /dev/loop1

md9 : active raid5 loop3[3] loop2[1]
       2048 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/2] [_UU]

Checksum of raw raid5 device after failing componnent: 
4df1921524a3b717a956fceaed0ae691  /dev/md9


===============================================================
Re-creating block device with size 1048576 bytes, so both the superblock and 
data start at the same spot
Adding back to array
mdadm: added /dev/loop1
Waiting for resync to finish... done.

md9 : active raid5 loop1[4] loop3[3] loop2[1]
       2048 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

Checksum of raw raid5 device after adding back smaller component: 
bb854f77ad222d224fcdd8c8f96b51f0  /dev/md9


===============================================================
Attempting recovery
Waiting for recovery to finish... done.
Performing check
Waiting for check to finish... done.

Current value of mismatch_cnt: 0

Checksum of raw raid5 device after repair/check: 
146f5c37305c42cda64538782c8c3794  /dev/md9
root@Thesaurus:/media/space/testmd#

--------------000907060902080708020200
Content-Type: text/plain;
 name="md_overlap_test"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="md_overlap_test"

IyEvYmluL2Jhc2gKCmVjaG8gIlBsZWFzZSByZWFkIHRoZSBzY3JpcHQgZmlyc3QsIGFuZCBj
b21tZW50IHRoZSBleGl0IGxpbmUgYXQgdGhlIHRvcC4iCmVjaG8gIlRoaXMgc2NyaXB0IHdp
bGwgcmVxdWlyZSBhYm91dCAzTUIgb2YgZnJlZSBzcGFjZSwgaXQgd2lsbCBmcmVlIChhbmQg
dXNlKSIKZWNobyAibG9vcCBkZXZpY2VzIDEgMiBhbmQgMywgYW5kIHdpbGwgdXNlIHRoZSBt
ZCBkZXZpY2UgbnVtYmVyIHNwZWNpZmllZCBpbiBNRF9ERVYuIgpleGl0IDAKCk1EX0RFVj0i
bWQ5IiAgICAjIG1ha2Ugc3VyZSB0aGlzIGlzIG5vdCBhbiBhcnJheSB5b3UgdXNlCkNPTVBf
TlVNPTMKQ09NUF9TSVpFPSQoKDEgKiAxMDI0ICogMTAyNCArIDgxOTIpKSAgICAgIzFNaUIg
Y29tcCBzaXplcyB3aXRoIHJvb20gZm9yIDhrICgxNiBzZWN0KSBvZiBtZXRhZGF0YQoKbWRh
ZG0gLVMgL2Rldi8kTURfREVWICY+L2Rldi9udWxsCgpERVZTPSIiCmZvciBpIGluICQoc2Vx
ICRDT01QX05VTSk7IGRvCiAgICBlY2hvIC1uICJDcmVhdGluZyBjb21wb25lbnQgJGkgKCRD
T01QX1NJWkUgYnl0ZXMpLi4uICIKICAgIGxvc2V0dXAgLWQgL2Rldi9sb29wJHtpfSAmPi9k
ZXYvbnVsbAogICAgCiAgICBzZXQgLWUKICAgIFBDTUQ9InByaW50IFwiXFx4JHtpfSR7aX1c
IiB4ICRDT01QX1NJWkUiICAgIyBmaWxsIGVudGlyZSBpbWFnZSB3aXRoIHRoZSBjb21wb25l
bnQgbnVtYmVyICgweGlpaWlpaWkuLi4pCiAgICBwZXJsIC1lICIkUENNRCIgPiBkdW1teSR7
aX0uaW1nCiAgICBsb3NldHVwIC9kZXYvbG9vcCR7aX0gZHVtbXkke2l9LmltZwogICAgREVW
Uz0iJERFVlMgL2Rldi9sb29wJHtpfSIKICAgIHNldCArZQogICAgZWNobyAiZG9uZS4iCmRv
bmUKCmVjaG8KZWNobwplY2hvICI9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0iCmVjaG8gIkNyZWF0aW5nICRDT01QX05V
TSBkaXNrIHJhaWQ1IGFycmF5IHdpdGggdjEuMSBzdXBlcmJsb2NrIgojIHN1cGVyYmxvY2sg
YXQgYmVnaW5uaW5nIG9mIGJsb2NrZGV2IGd1YXJhbnRlZXMgdGhhdCBpdCB3aWxsIG92ZXJs
YXAgd2l0aCByZWFsIGRhdGEsIG5vdCB3aXRoIHBhcml0eQptZGFkbSAtQyAvZGV2LyRNRF9E
RVYgLWwgNSAtbiAkQ09NUF9OVU0gLWUgMS4xICRERVZTCgplY2hvIC1uICJXYWl0aW5nIGZv
ciByZXN5bmMgdG8gZmluaXNoLi4uIgp3aGlsZSBbICQoY2F0IC9zeXMvYmxvY2svJE1EX0RF
Vi9tZC9zeW5jX2FjdGlvbikgIT0gImlkbGUiIF0gOyBkbwogICAgZWNobyAtbiAiLiIKICAg
IHNsZWVwIDEKZG9uZQplY2hvICIgZG9uZS4iCmVjaG8KZ3JlcCAtQTEgJE1EX0RFViAvcHJv
Yy9tZHN0YXQgCgplY2hvCmVjaG8gLW4gIkluaXRpYWwgY2hlY2tzdW0gb2YgcmF3IHJhaWQ1
IGRldmljZTogIgptZDVzdW0gL2Rldi8kTURfREVWCgplY2hvCmVjaG8KZWNobyAiPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09IgplY2hvICJGYWlsaW5nIGZpcnN0IGNvbXBvbm5lbnQiCm1kYWRtIC1mIC9kZXYvJE1E
X0RFViAvZGV2L2xvb3AxCm1kYWRtIC1yIC9kZXYvJE1EX0RFViAvZGV2L2xvb3AxCgplY2hv
CmdyZXAgLUExICRNRF9ERVYgL3Byb2MvbWRzdGF0IAoKZWNobwplY2hvIC1uICJDaGVja3N1
bSBvZiByYXcgcmFpZDUgZGV2aWNlIGFmdGVyIGZhaWxpbmcgY29tcG9ubmVudDogIgptZDVz
dW0gL2Rldi8kTURfREVWCgplY2hvCmVjaG8KZWNobyAiPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09IgpORVdTSVpFPSQo
KCAkQ09NUF9TSVpFIC0gJChjYXQgL3N5cy9ibG9jay8kTURfREVWL21kL3JkMS9vZmZzZXQp
ICogNTEyICkpCmVjaG8gIlJlLWNyZWF0aW5nIGJsb2NrIGRldmljZSB3aXRoIHNpemUgJE5F
V1NJWkUgYnl0ZXMsIHNvIGJvdGggdGhlIHN1cGVyYmxvY2sgYW5kIGRhdGEgc3RhcnQgYXQg
dGhlIHNhbWUgc3BvdCIKbG9zZXR1cCAtZCAvZGV2L2xvb3AxICY+L2Rldi9udWxsClBDTUQ9
InByaW50IFwiXFx4MTFcIiB4ICRORVdTSVpFIgpwZXJsIC1lICIkUENNRCIgPiBkdW1teTEu
aW1nCmxvc2V0dXAgL2Rldi9sb29wMSBkdW1teTEuaW1nCgplY2hvICJBZGRpbmcgYmFjayB0
byBhcnJheSIKbWRhZG0gLWEgL2Rldi8kTURfREVWIC9kZXYvbG9vcDEKCmVjaG8gLW4gIldh
aXRpbmcgZm9yIHJlc3luYyB0byBmaW5pc2guLi4iCndoaWxlIFsgJChjYXQgL3N5cy9ibG9j
ay8kTURfREVWL21kL3N5bmNfYWN0aW9uKSAhPSAiaWRsZSIgXSA7IGRvCiAgICBlY2hvIC1u
ICIuIgogICAgc2xlZXAgMQpkb25lCmVjaG8gIiBkb25lLiIKCmVjaG8KZ3JlcCAtQTEgJE1E
X0RFViAvcHJvYy9tZHN0YXQgCgplY2hvCmVjaG8gLW4gIkNoZWNrc3VtIG9mIHJhdyByYWlk
NSBkZXZpY2UgYWZ0ZXIgYWRkaW5nIGJhY2sgc21hbGxlciBjb21wb25lbnQ6ICIKbWQ1c3Vt
IC9kZXYvJE1EX0RFVgoKZWNobwplY2hvIAplY2hvICI9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0iCmVjaG8gIkF0dGVt
cHRpbmcgcmVjb3ZlcnkiCmVjaG8gcmVwYWlyID4gL3N5cy9ibG9jay8kTURfREVWL21kL3N5
bmNfYWN0aW9uCmVjaG8gLW4gIldhaXRpbmcgZm9yIHJlY292ZXJ5IHRvIGZpbmlzaC4uLiIK
d2hpbGUgWyAkKGNhdCAvc3lzL2Jsb2NrLyRNRF9ERVYvbWQvc3luY19hY3Rpb24pICE9ICJp
ZGxlIiBdIDsgZG8KICAgIGVjaG8gLW4gIi4iCiAgICBzbGVlcCAxCmRvbmUKZWNobyAiIGRv
bmUuIgoKZWNobyAiUGVyZm9ybWluZyBjaGVjayIKZWNobyBjaGVjayA+IC9zeXMvYmxvY2sv
JE1EX0RFVi9tZC9zeW5jX2FjdGlvbgplY2hvIC1uICJXYWl0aW5nIGZvciBjaGVjayB0byBm
aW5pc2guLi4iCndoaWxlIFsgJChjYXQgL3N5cy9ibG9jay8kTURfREVWL21kL3N5bmNfYWN0
aW9uKSAhPSAiaWRsZSIgXSA7IGRvCiAgICBlY2hvIC1uICIuIgogICAgc2xlZXAgMQpkb25l
CmVjaG8gIiBkb25lLiIKCmVjaG8KZWNobyAtbiAiQ3VycmVudCB2YWx1ZSBvZiBtaXNtYXRj
aF9jbnQ6ICIKY2F0IC9zeXMvYmxvY2svJE1EX0RFVi9tZC9taXNtYXRjaF9jbnQKCmVjaG8K
ZWNobyAtbiAiQ2hlY2tzdW0gb2YgcmF3IHJhaWQ1IGRldmljZSBhZnRlciByZXBhaXIvY2hl
Y2s6ICIKbWQ1c3VtIC9kZXYvJE1EX0RFVgo=
--------------000907060902080708020200--
