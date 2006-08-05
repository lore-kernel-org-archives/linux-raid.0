From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 010 of 10] md: Allow the write_mostly flag to be set via sysfs.
Date: Sat, 5 Aug 2006 19:43:43 -0400
Message-ID: <170fa0d20608051643o5eabb346x9767c2644f859f4b@mail.gmail.com>
References: <20060601150955.27444.patches@notabene>
	 <1060601051418.27661@suse.de>
	 <170fa0d20608042259u3b6b75fah36c3777dfbf33fa6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_47649_3437986.1154821423748"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20608042259u3b6b75fah36c3777dfbf33fa6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_47649_3437986.1154821423748
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 8/5/06, Mike Snitzer <snitzer@gmail.com> wrote:
> Aside from this write-mostly sysfs support, is there a way to toggle
> the write-mostly bit of an md member with mdadm?  I couldn't identify
> a clear way to do so.
>
> It'd be nice if mdadm --assemble would honor --write-mostly...

I went ahead and implemented the ability to toggle the write-mostly
bit for all disks in an array.  I did so by adding another type of
--update to --assemble.  This is very useful for a 2 disk raid1 (one
disk local, one remote).   When you switch the raidhost you also need
to toggle the write-mostly bit too.

I've tested the attached patch to work with both ver.90 and ver1
superblocks with mdadm 2.4.1 and 2.5.2.  The patch is against mdadm
2.4.1 but applies cleanly (with fuzz) against mdadm 2.5.2).

# cat /proc/mdstat
...
md2 : active raid1 nbd2[0] sdd[1](W)
      390613952 blocks [2/2] [UU]
      bitmap: 0/187 pages [0KB], 1024KB chunk

# mdadm -S /dev/md2
# mdadm --assemble /dev/md2 --run --update=toggle-write-mostly
/dev/sdd /dev/nbd2
mdadm: /dev/md2 has been started with 2 drives.

# cat /proc/mdstat
...
md2 : active raid1 nbd2[0](W) sdd[1]
      390613952 blocks [2/2] [UU]
      bitmap: 0/187 pages [0KB], 1024KB chunk

------=_Part_47649_3437986.1154821423748
Content-Type: text/x-patch; name="mdadm-2.4.1_toggle_write_mostly.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mdadm-2.4.1_toggle_write_mostly.patch"
X-Attachment-Id: f_eqimrox7

ZGlmZiAtTmF1ciBtZGFkbS0yLjQuMS9tZGFkbS5jIG1kYWRtLTIuNC4xX3RvZ2dsZV93cml0ZV9t
b3N0bHkvbWRhZG0uYwotLS0gbWRhZG0tMi40LjEvbWRhZG0uYwkyMDA2LTAzLTI4IDIxOjU1OjM5
LjAwMDAwMDAwMCAtMDUwMAorKysgbWRhZG0tMi40LjFfdG9nZ2xlX3dyaXRlX21vc3RseS9tZGFk
bS5jCTIwMDYtMDgtMDUgMTc6MDE6NDguMDAwMDAwMDAwIC0wNDAwCkBAIC01ODcsNiArNTg3LDgg
QEAKIAkJCQljb250aW51ZTsKIAkJCWlmIChzdHJjbXAodXBkYXRlLCAidXVpZCIpPT0wKQogCQkJ
CWNvbnRpbnVlOworCQkJaWYgKHN0cmNtcCh1cGRhdGUsICJ0b2dnbGUtd3JpdGUtbW9zdGx5Iik9
PTApCisJCQkJY29udGludWU7CiAJCQlpZiAoc3RyY21wKHVwZGF0ZSwgImJ5dGVvcmRlciIpPT0w
KSB7CiAJCQkJaWYgKHNzKSB7CiAJCQkJCWZwcmludGYoc3RkZXJyLCBOYW1lICI6IG11c3Qgbm90
IHNldCBtZXRhZGF0YSB0eXBlIHdpdGggLS11cGRhdGU9Ynl0ZW9yZGVyLlxuIik7CkBAIC02MDEs
NyArNjAzLDcgQEAKIAogCQkJCWNvbnRpbnVlOwogCQkJfQotCQkJZnByaW50ZihzdGRlcnIsIE5h
bWUgIjogJy0tdXBkYXRlICVzJyBpbnZhbGlkLiAgT25seSAnc3BhcmMyLjInLCAnc3VwZXItbWlu
b3InLCAndXVpZCcsICdyZXN5bmMnIG9yICdzdW1tYXJpZXMnIHN1cHBvcnRlZFxuIix1cGRhdGUp
OworCQkJZnByaW50ZihzdGRlcnIsIE5hbWUgIjogJy0tdXBkYXRlICVzJyBpbnZhbGlkLiAgT25s
eSAnc3BhcmMyLjInLCAnc3VwZXItbWlub3InLCAndXVpZCcsICdyZXN5bmMnLCAnc3VtbWFyaWVz
JyBvciAndG9nZ2xlLXdyaXRlLW1vc3RseScgc3VwcG9ydGVkXG4iLHVwZGF0ZSk7CiAJCQlleGl0
KDIpOwogCiAJCWNhc2UgTyhBU1NFTUJMRSwnYycpOiAvKiBjb25maWcgZmlsZSAqLwpkaWZmIC1O
YXVyIG1kYWRtLTIuNC4xL3N1cGVyMC5jIG1kYWRtLTIuNC4xX3RvZ2dsZV93cml0ZV9tb3N0bHkv
c3VwZXIwLmMKLS0tIG1kYWRtLTIuNC4xL3N1cGVyMC5jCTIwMDYtMDMtMjggMDE6MTA6NTEuMDAw
MDAwMDAwIC0wNTAwCisrKyBtZGFkbS0yLjQuMV90b2dnbGVfd3JpdGVfbW9zdGx5L3N1cGVyMC5j
CTIwMDYtMDgtMDUgMTg6MDQ6NDUuMDAwMDAwMDAwIC0wNDAwCkBAIC0zODIsNiArMzgyLDEwIEBA
CiAJCQlydiA9IDE7CiAJCX0KIAl9CisJaWYgKHN0cmNtcCh1cGRhdGUsICJ0b2dnbGUtd3JpdGUt
bW9zdGx5Iik9PTApIHsKKwkJaW50IGQgPSBpbmZvLT5kaXNrLm51bWJlcjsKKwkJc2ItPmRpc2tz
W2RdLnN0YXRlIF49ICgxPDxNRF9ESVNLX1dSSVRFTU9TVExZKTsKKwl9CiAJaWYgKHN0cmNtcCh1
cGRhdGUsICJuZXdkZXYiKSA9PSAwKSB7CiAJCWludCBkID0gaW5mby0+ZGlzay5udW1iZXI7CiAJ
CW1lbXNldCgmc2ItPmRpc2tzW2RdLCAwLCBzaXplb2Yoc2ItPmRpc2tzW2RdKSk7CmRpZmYgLU5h
dXIgbWRhZG0tMi40LjEvc3VwZXIxLmMgbWRhZG0tMi40LjFfdG9nZ2xlX3dyaXRlX21vc3RseS9z
dXBlcjEuYwotLS0gbWRhZG0tMi40LjEvc3VwZXIxLmMJMjAwNi0wNC0wNyAwMDozMjowNi4wMDAw
MDAwMDAgLTA0MDAKKysrIG1kYWRtLTIuNC4xX3RvZ2dsZV93cml0ZV9tb3N0bHkvc3VwZXIxLmMJ
MjAwNi0wOC0wNSAxODozMzoyMS4wMDAwMDAwMDAgLTA0MDAKQEAgLTQ0Niw2ICs0NDYsOSBAQAog
CQkJcnYgPSAxOwogCQl9CiAJfQorCWlmIChzdHJjbXAodXBkYXRlLCAidG9nZ2xlLXdyaXRlLW1v
c3RseSIpPT0wKSB7CisJCXNiLT5kZXZmbGFncyBePSBXcml0ZU1vc3RseTE7CisJfQogI2lmIDAK
IAlpZiAoc3RyY21wKHVwZGF0ZSwgIm5ld2RldiIpID09IDApIHsKIAkJaW50IGQgPSBpbmZvLT5k
aXNrLm51bWJlcjsK
------=_Part_47649_3437986.1154821423748--
