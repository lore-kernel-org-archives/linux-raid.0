From: Andreas Baer <synthetic.gods@gmail.com>
Subject: Re: Update to mdadm V3.2.5 => RAID starts to recover (reproducible)
Date: Thu, 29 Aug 2013 11:55:09 +0200
Message-ID: <CAE65G7kb_xveCrzqedbkFUc=OUh-KDJ-K58SrmTWeGhgkN1vEQ@mail.gmail.com>
References: <CAE65G7kMP2rFLGuO1rfsFp7V-rHGz-3K+VWuLMZqmGUPANyqcQ@mail.gmail.com>
	<20130826155202.7a11dff5@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b450a42fda2a104e51319d8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130826155202.7a11dff5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--047d7b450a42fda2a104e51319d8
Content-Type: text/plain; charset=ISO-8859-1

On 8/26/13, NeilBrown <neilb@suse.de> wrote:
> On Thu, 22 Aug 2013 15:20:06 +0200 Andreas Baer <synthetic.gods@gmail.com>
> wrote:
>
>> Short description:
>> I've discovered a problem during re-assembly of a clean RAID. mdadm
>> throws one disk out because this disk apparently shows another disk as
>> failed. After assembly, RAID starts to recover on existing spare disk.
>>
>> In detail:
>> 1. RAID-6 (Superblock V0.90.00) created with mdadm V2.6.4 and with 7
>> active disks and 1 spare disk (disk size: 1 TB), fully synced and
>> clean.
>> 2. RAID-6 stopped and re-assembled with mdadm V3.2.5, but during that
>> one disk is thrown out.
>>
>> Manual assembly command for /dev/md0, relevant partitions are
>> /dev/sd[b-i]1:
>> # mdadm --assemble --scan -vvv
>> mdadm: looking for devices for /dev/md0
>> mdadm: no RAID superblock on /dev/sdi
>> mdadm: no RAID superblock on /dev/sdh
>> mdadm: no RAID superblock on /dev/sdg
>> mdadm: no RAID superblock on /dev/sdf
>> mdadm: no RAID superblock on /dev/sde
>> mdadm: no RAID superblock on /dev/sdd
>> mdadm: no RAID superblock on /dev/sdc
>> mdadm: no RAID superblock on /dev/sdb
>> mdadm: no RAID superblock on /dev/sda1
>> mdadm: no RAID superblock on /dev/sda
>> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 7.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 6.
>> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
>> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
>> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
>> mdadm: ignoring /dev/sdb1 as it reports /dev/sdi1 as failed
>> mdadm: no uptodate device for slot 0 of /dev/md0
>> mdadm: added /dev/sdd1 to /dev/md0 as 2
>> mdadm: added /dev/sde1 to /dev/md0 as 3
>> mdadm: added /dev/sdf1 to /dev/md0 as 4
>> mdadm: added /dev/sdg1 to /dev/md0 as 5
>> mdadm: added /dev/sdh1 to /dev/md0 as 6
>> mdadm: added /dev/sdi1 to /dev/md0 as 7
>> mdadm: added /dev/sdc1 to /dev/md0 as 1
>> mdadm: /dev/md0 has been started with 6 drives (out of 7) and 1 spare.
>>
>> I finally made a test by modifying mdadm V3.2.5 sources to not write
>> any data to any superblock and to simply exit() somewhere in the
>> middle of assembly process to be able to reproduce this behavior
>> without any RAID re-creation/synchronization.
>> So using mdadm V2.6.4 /dev/md0 assembles without problems and if I
>> switch to mdadm V3.2.5 it shows the same messages as above.
>>
>> The real problem:
>> I have more than a single machine receiving a similar software update
>> so I need to find a solution or workaround around this problem. By the
>> way, from another test without an existing spare disk, there seems to
>> be no 'throwing out'-problem when switching from V2.6.4 to V3.2.5.
>>
>> It would also be a great help if someone could explain the reason
>> behind the relevant code fragment for rejecting a device, e.g. why is
>> only the 'most_recent' device important?
>>
>> /* If this device thinks that 'most_recent' has failed, then
>>   * we must reject this device.
>>   */
>> if (j != most_recent &&
>>     content->array.raid_disks > 0 &&
>>     devices[most_recent].i.disk.raid_disk >= 0 &&
>>     devmap[j * content->array.raid_disks +
>> devices[most_recent].i.disk.raid_disk] == 0) {
>>     if (verbose > -1)
>>         fprintf(stderr, Name ": ignoring %s as it reports %s as
>> failed\n",
>>             devices[j].devname, devices[most_recent].devname);
>>     best[i] = -1;
>>     continue;
>> }
>>
>> I also attached some files showing some details about related
>> superblocks before and after assembly as well as about RAID status
>> itself.
>
>
> Thanks for the thorough report.  I think this issue has been fixed in
> 3.3-rc1
> You can fix it for 3.2.5 by applying the following patch:
>
> diff --git a/Assemble.c b/Assemble.c
> index 227d66f..bc65c29 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -849,7 +849,8 @@ int Assemble(struct supertype *st, char *mddev,
>  		devices[devcnt].i.disk.minor = minor(stb.st_rdev);
>  		if (most_recent < devcnt) {
>  			if (devices[devcnt].i.events
> -			    > devices[most_recent].i.events)
> +			    > devices[most_recent].i.events &&
> +			    devices[devcnt].i.disk.state == 6)
>  				most_recent = devcnt;
>  		}
>  		if (content->array.level == LEVEL_MULTIPATH)
>
> The "most recent" device is important as we need to choose one to compare
> all
> others again.  The problem is that the code in 3.2.5 can sometimes choose a
> spare, which isn't such a good idea.
>
> The "most recent" is also important because when a collection of devices is
> given to the kernel it will give priority to some information which is on
> the
> last device passed in.  So we make sure that the last device given to the
> kernel is the "most recent".
>
> Please let me know if the patch fixes your problem.
>
> NeilBrown

First of all, thanks for your very helpful 'most recent disk' explanation.

Sadly, the patch didn't fix my problem because the event counters are
really equal on all disks (inclusive spare) and the first disk that is
checked is the spare disk so there is no reason to set another disk as
'most recent disk', but I improved your patch a little bit by
providing more output and created also an own solution, but that needs
review because I'm not sure if it can be done like that.

Patch 1: Your solution with more output
Diff: mdadm-3.2.5-noassemble-patch1.diff
Assembly: mdadm-3.2.5-noassemble-patch1.txt

Patch 2: My proposed solution
Diff: mdadm-3.2.5-noassemble-patch2.diff
Assembly: mdadm-3.2.5-noassemble-patch2.txt

--047d7b450a42fda2a104e51319d8
Content-Type: text/plain; charset=US-ASCII; name="mdadm-3.2.5-noassemble-patch1.txt"
Content-Disposition: attachment;
	filename="mdadm-3.2.5-noassemble-patch1.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: file3

IyAuL21kYWRtLTMuMi41LW5vYXNzZW1ibGUtcGF0Y2gxIC0tYXNzZW1ibGUgLS1zY2FuIC12Cm1k
YWRtIG1haW46IGZhaWxlZCB0byBnZXQgZXhjbHVzaXZlIGxvY2sgb24gbWFwZmlsZQptZGFkbTog
bG9va2luZyBmb3IgZGV2aWNlcyBmb3IgL2Rldi9tZDAKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9j
ayBvbiAvZGV2L3NkZwptZGFkbTogbm8gUkFJRCBzdXBlcmJsb2NrIG9uIC9kZXYvc2RmCm1kYWRt
OiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9zZGUKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9j
ayBvbiAvZGV2L3NkZAptZGFkbTogbm8gUkFJRCBzdXBlcmJsb2NrIG9uIC9kZXYvc2RjCm1kYWRt
OiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9zZGIKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9j
ayBvbiAvZGV2L3NkYTEKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9jayBvbiAvZGV2L3NkYQptZGFk
bTogL2Rldi9zZGcxIGlzIGlkZW50aWZpZWQgYXMgYSBtZW1iZXIgb2YgL2Rldi9tZDAsIHNsb3Qg
NS4KIyBtb3N0X3JlY2VudD0wOyBkZXZjbnQ9MDsgZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzPTQy
OyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmV2ZW50cz00MjsgZGlzay5zdGF0ZT0wCm1kYWRtOiAv
ZGV2L3NkZjEgaXMgaWRlbnRpZmllZCBhcyBhIG1lbWJlciBvZiAvZGV2L21kMCwgc2xvdCA0Lgoj
IG1vc3RfcmVjZW50PTA7IGRldmNudD0xOyBkZXZpY2VzW2RldmNudF0uaS5ldmVudHM9NDI7IGRl
dmljZXNbbW9zdF9yZWNlbnRdLmkuZXZlbnRzPTQyOyBkaXNrLnN0YXRlPTYKbWRhZG06IC9kZXYv
c2RlMSBpcyBpZGVudGlmaWVkIGFzIGEgbWVtYmVyIG9mIC9kZXYvbWQwLCBzbG90IDMuCiMgbW9z
dF9yZWNlbnQ9MDsgZGV2Y250PTI7IGRldmljZXNbZGV2Y250XS5pLmV2ZW50cz00MjsgZGV2aWNl
c1ttb3N0X3JlY2VudF0uaS5ldmVudHM9NDI7IGRpc2suc3RhdGU9NgptZGFkbTogL2Rldi9zZGQx
IGlzIGlkZW50aWZpZWQgYXMgYSBtZW1iZXIgb2YgL2Rldi9tZDAsIHNsb3QgMi4KIyBtb3N0X3Jl
Y2VudD0wOyBkZXZjbnQ9MzsgZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzPTQyOyBkZXZpY2VzW21v
c3RfcmVjZW50XS5pLmV2ZW50cz00MjsgZGlzay5zdGF0ZT02Cm1kYWRtOiAvZGV2L3NkYzEgaXMg
aWRlbnRpZmllZCBhcyBhIG1lbWJlciBvZiAvZGV2L21kMCwgc2xvdCAxLgojIG1vc3RfcmVjZW50
PTA7IGRldmNudD00OyBkZXZpY2VzW2RldmNudF0uaS5ldmVudHM9NDI7IGRldmljZXNbbW9zdF9y
ZWNlbnRdLmkuZXZlbnRzPTQyOyBkaXNrLnN0YXRlPTYKbWRhZG06IC9kZXYvc2RiMSBpcyBpZGVu
dGlmaWVkIGFzIGEgbWVtYmVyIG9mIC9kZXYvbWQwLCBzbG90IDAuCiMgbW9zdF9yZWNlbnQ9MDsg
ZGV2Y250PTU7IGRldmljZXNbZGV2Y250XS5pLmV2ZW50cz00MjsgZGV2aWNlc1ttb3N0X3JlY2Vu
dF0uaS5ldmVudHM9NDI7IGRpc2suc3RhdGU9NgojIGo9NTsgbW9zdF9yZWNlbnQ9MDsgY29udGVu
dC0+YXJyYXkucmFpZF9kaXNrcz01OyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmRpc2sucmFpZF9k
aXNrPTU7IGRldm1hcFszMF0gPSAwCm1kYWRtOiBpZ25vcmluZyAvZGV2L3NkYjEgYXMgaXQgcmVw
b3J0cyAvZGV2L3NkZzEgYXMgZmFpbGVkCiMgaj00OyBtb3N0X3JlY2VudD0wOyBjb250ZW50LT5h
cnJheS5yYWlkX2Rpc2tzPTU7IGRldmljZXNbbW9zdF9yZWNlbnRdLmkuZGlzay5yYWlkX2Rpc2s9
NTsgZGV2bWFwWzI1XSA9IDEKIyBqPTM7IG1vc3RfcmVjZW50PTA7IGNvbnRlbnQtPmFycmF5LnJh
aWRfZGlza3M9NTsgZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5kaXNrLnJhaWRfZGlzaz01OyBkZXZt
YXBbMjBdID0gMQojIGo9MjsgbW9zdF9yZWNlbnQ9MDsgY29udGVudC0+YXJyYXkucmFpZF9kaXNr
cz01OyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmRpc2sucmFpZF9kaXNrPTU7IGRldm1hcFsxNV0g
PSAxCiMgaj0xOyBtb3N0X3JlY2VudD0wOyBjb250ZW50LT5hcnJheS5yYWlkX2Rpc2tzPTU7IGRl
dmljZXNbbW9zdF9yZWNlbnRdLmkuZGlzay5yYWlkX2Rpc2s9NTsgZGV2bWFwWzEwXSA9IDEK
--047d7b450a42fda2a104e51319d8
Content-Type: application/octet-stream;
	name="mdadm-3.2.5-noassemble-patch1.diff"
Content-Disposition: attachment;
	filename="mdadm-3.2.5-noassemble-patch1.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTnVyIG1kYWRtLTMuMi41LW9yaWcvQXNzZW1ibGUuYyBtZGFkbS0zLjIuNS1ub2Fzc2Vt
YmxlLXBhdGNoMS9Bc3NlbWJsZS5jCi0tLSBtZGFkbS0zLjIuNS1vcmlnL0Fzc2VtYmxlLmMJMjAx
Mi0wNS0xOCAwOToxMDowMy4wMDAwMDAwMDAgKzAyMDAKKysrIG1kYWRtLTMuMi41LW5vYXNzZW1i
bGUtcGF0Y2gxL0Fzc2VtYmxlLmMJMjAxMy0wOC0yOSAxMDo1Nzo1OC4wMDAwMDAwMDAgKzAyMDAK
QEAgLTIyMCw3ICsyMjAsNyBAQAogCWludCBjaGFuZ2UgPSAwOwogCWludCBpbmFyZ3YgPSAwOwog
CWludCByZXBvcnRfbWlzc21hdGNoOwotI2lmbmRlZiBNREFTU0VNQkxFCisjaWYgMAogCWludCBi
aXRtYXBfZG9uZTsKICNlbmRpZgogCWludCBzdGFydF9wYXJ0aWFsX29rID0gKHJ1bnN0b3AgPj0g
MCkgJiYgCkBAIC03MTYsNyArNzE2LDcgQEAKIAl9CiAJaW9jdGwobWRmZCwgU1RPUF9BUlJBWSwg
TlVMTCk7IC8qIGp1c3QgaW5jYXNlIGl0IHdhcyBzdGFydGVkIGJ1dCBoYXMgbm8gY29udGVudCAq
LwogCi0jaWZuZGVmIE1EQVNTRU1CTEUKKyNpZiAwCiAJaWYgKGNvbnRlbnQgIT0gJmluZm8pIHsK
IAkJLyogVGhpcyBpcyBhIG1lbWJlciBvZiBhIGNvbnRhaW5lci4gIFRyeSBzdGFydGluZyB0aGUg
YXJyYXkuICovCiAJCWludCBlcnI7CkBAIC03MzUsNyArNzM1LDcgQEAKIAkJY2hhciAqZGV2bmFt
ZSA9IHRtcGRldi0+ZGV2bmFtZTsKIAkJc3RydWN0IHN0YXQgc3RiOwogCQkvKiBsb29rcyBsaWtl
IGEgZ29vZCBlbm91Z2ggbWF0Y2ggdG8gdXBkYXRlIHRoZSBzdXBlciBibG9jayBpZiBuZWVkZWQg
Ki8KLSNpZm5kZWYgTURBU1NFTUJMRQorI2lmIDAKIAkJaWYgKHVwZGF0ZSkgewogCQkJaW50IGRm
ZDsKIAkJCS8qIHByZXBhcmUgdXNlZnVsIGluZm9ybWF0aW9uIGluIGluZm8gc3RydWN0dXJlcyAq
LwpAQCAtODQ3LDEwICs4NDcsMTQgQEAKIAkJZGV2aWNlc1tkZXZjbnRdLmkgPSAqY29udGVudDsK
IAkJZGV2aWNlc1tkZXZjbnRdLmkuZGlzay5tYWpvciA9IG1ham9yKHN0Yi5zdF9yZGV2KTsKIAkJ
ZGV2aWNlc1tkZXZjbnRdLmkuZGlzay5taW5vciA9IG1pbm9yKHN0Yi5zdF9yZGV2KTsKKwkJZnBy
aW50Ziggc3RkZXJyLCAiIyBtb3N0X3JlY2VudD0lZDsgZGV2Y250PSVkOyBkZXZpY2VzW2RldmNu
dF0uaS5ldmVudHM9JWxsdTsgZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5ldmVudHM9JWxsdTsgZGlz
ay5zdGF0ZT0lZFxuIiwKKwkJICAgICAgICAgbW9zdF9yZWNlbnQsIGRldmNudCwgZGV2aWNlc1tk
ZXZjbnRdLmkuZXZlbnRzLCBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmV2ZW50cywgZGV2aWNlc1tk
ZXZjbnRdLmkuZGlzay5zdGF0ZSApOwogCQlpZiAobW9zdF9yZWNlbnQgPCBkZXZjbnQpIHsKLQkJ
CWlmIChkZXZpY2VzW2RldmNudF0uaS5ldmVudHMKLQkJCSAgICA+IGRldmljZXNbbW9zdF9yZWNl
bnRdLmkuZXZlbnRzKQorCQkJaWYgKGRldmljZXNbZGV2Y250XS5pLmV2ZW50cyA+IGRldmljZXNb
bW9zdF9yZWNlbnRdLmkuZXZlbnRzICYmCisJCQkgICAgZGV2aWNlc1tkZXZjbnRdLmkuZGlzay5z
dGF0ZSA9PSA2KSB7CiAJCQkJbW9zdF9yZWNlbnQgPSBkZXZjbnQ7CisJCQkJZnByaW50Ziggc3Rk
ZXJyLCAiICBuZXc6IG1vc3RfcmVjZW50PSVkOyBkaXNrLnN0YXRlPSVkXG4iLCBtb3N0X3JlY2Vu
dCwgZGV2aWNlc1tkZXZjbnRdLmkuZGlzay5zdGF0ZSApOworCQkJfQogCQl9CiAJCWlmIChjb250
ZW50LT5hcnJheS5sZXZlbCA9PSBMRVZFTF9NVUxUSVBBVEgpCiAJCQkvKiB3aXRoIG11bHRpcGF0
aCwgdGhlIHJhaWRfZGlzayBmcm9tIHRoZSBzdXBlcmJsb2NrIGlzIG1lYW5pbmdsZXNzICovCkBA
IC05NjAsNiArOTY0LDEwIEBACiAJCS8qIElmIHRoaXMgZGV2aWNlIHRoaW5rcyB0aGF0ICdtb3N0
X3JlY2VudCcgaGFzIGZhaWxlZCwgdGhlbgogCQkgKiB3ZSBtdXN0IHJlamVjdCB0aGlzIGRldmlj
ZS4KIAkJICovCisJCWZwcmludGYoIHN0ZGVyciwgIiMgaj0lZDsgbW9zdF9yZWNlbnQ9JWQ7IGNv
bnRlbnQtPmFycmF5LnJhaWRfZGlza3M9JWQ7IGRldmljZXNbbW9zdF9yZWNlbnRdLmkuZGlzay5y
YWlkX2Rpc2s9JWQ7IGRldm1hcFslZF0gPSAlZFxuIiwKKwkJICAgICAgICAgaiwgbW9zdF9yZWNl
bnQsIGNvbnRlbnQtPmFycmF5LnJhaWRfZGlza3MsIGRldmljZXNbbW9zdF9yZWNlbnRdLmkuZGlz
ay5yYWlkX2Rpc2ssCisJCSAgICAgICAgIGogKiBjb250ZW50LT5hcnJheS5yYWlkX2Rpc2tzICsg
ZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5kaXNrLnJhaWRfZGlzaywKKwkJICAgICAgICAgZGV2bWFw
W2ogKiBjb250ZW50LT5hcnJheS5yYWlkX2Rpc2tzICsgZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5k
aXNrLnJhaWRfZGlza10gKTsKIAkJaWYgKGogIT0gbW9zdF9yZWNlbnQgJiYKIAkJICAgIGNvbnRl
bnQtPmFycmF5LnJhaWRfZGlza3MgPiAwICYmCiAJCSAgICBkZXZpY2VzW21vc3RfcmVjZW50XS5p
LmRpc2sucmFpZF9kaXNrID49IDAgJiYKQEAgLTk4OCw2ICs5OTYsNyBAQAogCQl9CiAJfQogCWZy
ZWUoZGV2bWFwKTsKK2V4aXQoIDI1NSApOwogCXdoaWxlIChmb3JjZSAmJgogCSAgICAgICAoIWVu
b3VnaChjb250ZW50LT5hcnJheS5sZXZlbCwgY29udGVudC0+YXJyYXkucmFpZF9kaXNrcywKIAkJ
CWNvbnRlbnQtPmFycmF5LmxheW91dCwgMSwK
--047d7b450a42fda2a104e51319d8
Content-Type: application/octet-stream;
	name="mdadm-3.2.5-noassemble-patch2.diff"
Content-Disposition: attachment;
	filename="mdadm-3.2.5-noassemble-patch2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: file2

ZGlmZiAtTnVyIG1kYWRtLTMuMi41LW9yaWcvQXNzZW1ibGUuYyBtZGFkbS0zLjIuNS1ub2Fzc2Vt
YmxlLXBhdGNoMi9Bc3NlbWJsZS5jCi0tLSBtZGFkbS0zLjIuNS1vcmlnL0Fzc2VtYmxlLmMJMjAx
Mi0wNS0xOCAwOToxMDowMy4wMDAwMDAwMDAgKzAyMDAKKysrIG1kYWRtLTMuMi41LW5vYXNzZW1i
bGUtcGF0Y2gyL0Fzc2VtYmxlLmMJMjAxMy0wOC0yOSAxMDo0MDo0Mi4wMDAwMDAwMDAgKzAyMDAK
QEAgLTIyMCw3ICsyMjAsNyBAQAogCWludCBjaGFuZ2UgPSAwOwogCWludCBpbmFyZ3YgPSAwOwog
CWludCByZXBvcnRfbWlzc21hdGNoOwotI2lmbmRlZiBNREFTU0VNQkxFCisjaWYgMAogCWludCBi
aXRtYXBfZG9uZTsKICNlbmRpZgogCWludCBzdGFydF9wYXJ0aWFsX29rID0gKHJ1bnN0b3AgPj0g
MCkgJiYgCkBAIC0yMzUsNiArMjM1LDcgQEAKIAlpbnQgdHJ1c3R3b3J0aHk7CiAJY2hhciBjaG9z
ZW5fbmFtZVsxMDI0XTsKIAlzdHJ1Y3QgZG9tYWlubGlzdCAqZG9tYWlucyA9IE5VTEw7CisJaW50
IGdldF9uZXdfcmVjZW50X2Rpc2sgPSAwOwogCiAJaWYgKGdldF9saW51eF92ZXJzaW9uKCkgPCAy
MDA0MDAwKQogCQlvbGRfbGludXggPSAxOwpAQCAtNzE2LDcgKzcxNyw3IEBACiAJfQogCWlvY3Rs
KG1kZmQsIFNUT1BfQVJSQVksIE5VTEwpOyAvKiBqdXN0IGluY2FzZSBpdCB3YXMgc3RhcnRlZCBi
dXQgaGFzIG5vIGNvbnRlbnQgKi8KIAotI2lmbmRlZiBNREFTU0VNQkxFCisjaWYgMAogCWlmIChj
b250ZW50ICE9ICZpbmZvKSB7CiAJCS8qIFRoaXMgaXMgYSBtZW1iZXIgb2YgYSBjb250YWluZXIu
ICBUcnkgc3RhcnRpbmcgdGhlIGFycmF5LiAqLwogCQlpbnQgZXJyOwpAQCAtNzM1LDcgKzczNiw3
IEBACiAJCWNoYXIgKmRldm5hbWUgPSB0bXBkZXYtPmRldm5hbWU7CiAJCXN0cnVjdCBzdGF0IHN0
YjsKIAkJLyogbG9va3MgbGlrZSBhIGdvb2QgZW5vdWdoIG1hdGNoIHRvIHVwZGF0ZSB0aGUgc3Vw
ZXIgYmxvY2sgaWYgbmVlZGVkICovCi0jaWZuZGVmIE1EQVNTRU1CTEUKKyNpZiAwCiAJCWlmICh1
cGRhdGUpIHsKIAkJCWludCBkZmQ7CiAJCQkvKiBwcmVwYXJlIHVzZWZ1bCBpbmZvcm1hdGlvbiBp
biBpbmZvIHN0cnVjdHVyZXMgKi8KQEAgLTg0NywxMCArODQ4LDE3IEBACiAJCWRldmljZXNbZGV2
Y250XS5pID0gKmNvbnRlbnQ7CiAJCWRldmljZXNbZGV2Y250XS5pLmRpc2subWFqb3IgPSBtYWpv
cihzdGIuc3RfcmRldik7CiAJCWRldmljZXNbZGV2Y250XS5pLmRpc2subWlub3IgPSBtaW5vcihz
dGIuc3RfcmRldik7CisJCWZwcmludGYoIHN0ZGVyciwgIiMgbW9zdF9yZWNlbnQ9JWQ7IGRldmNu
dD0lZDsgZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzPSVsbHU7IGRldmljZXNbbW9zdF9yZWNlbnRd
LmkuZXZlbnRzPSVsbHU7IGRpc2suc3RhdGU9JWRcbiIsCisJCSAgICAgICAgIG1vc3RfcmVjZW50
LCBkZXZjbnQsIGRldmljZXNbZGV2Y250XS5pLmV2ZW50cywgZGV2aWNlc1ttb3N0X3JlY2VudF0u
aS5ldmVudHMsIGRldmljZXNbZGV2Y250XS5pLmRpc2suc3RhdGUgKTsKIAkJaWYgKG1vc3RfcmVj
ZW50IDwgZGV2Y250KSB7Ci0JCQlpZiAoZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzCi0JCQkgICAg
PiBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmV2ZW50cykKKwkJCWlmICgoZGV2aWNlc1tkZXZjbnRd
LmkuZXZlbnRzID4gZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5ldmVudHMgJiYgZGV2aWNlc1tkZXZj
bnRdLmkuZGlzay5zdGF0ZSA9PSA2KSB8fAorCQkJICAgIChnZXRfbmV3X3JlY2VudF9kaXNrID09
IDEgJiYgZGV2aWNlc1tkZXZjbnRdLmkuZGlzay5zdGF0ZSA9PSA2KSkgewogCQkJCW1vc3RfcmVj
ZW50ID0gZGV2Y250OworCQkJCWdldF9uZXdfcmVjZW50X2Rpc2sgPSAwOworCQkJCWZwcmludGYo
IHN0ZGVyciwgIiAgbmV3OiBtb3N0X3JlY2VudD0lZDsgZGlzay5zdGF0ZT0lZFxuIiwgbW9zdF9y
ZWNlbnQsIGRldmljZXNbZGV2Y250XS5pLmRpc2suc3RhdGUgKTsKKwkJCX0KKwkJfSBlbHNlIGlm
IChtb3N0X3JlY2VudCA9PSBkZXZjbnQgJiYgZGV2aWNlc1tkZXZjbnRdLmkuZGlzay5zdGF0ZSAh
PSA2KSB7CisJCQlnZXRfbmV3X3JlY2VudF9kaXNrID0gMTsKIAkJfQogCQlpZiAoY29udGVudC0+
YXJyYXkubGV2ZWwgPT0gTEVWRUxfTVVMVElQQVRIKQogCQkJLyogd2l0aCBtdWx0aXBhdGgsIHRo
ZSByYWlkX2Rpc2sgZnJvbSB0aGUgc3VwZXJibG9jayBpcyBtZWFuaW5nbGVzcyAqLwpAQCAtOTYw
LDYgKzk2OCwxMCBAQAogCQkvKiBJZiB0aGlzIGRldmljZSB0aGlua3MgdGhhdCAnbW9zdF9yZWNl
bnQnIGhhcyBmYWlsZWQsIHRoZW4KIAkJICogd2UgbXVzdCByZWplY3QgdGhpcyBkZXZpY2UuCiAJ
CSAqLworCQlmcHJpbnRmKCBzdGRlcnIsICIjIGo9JWQ7IG1vc3RfcmVjZW50PSVkOyBjb250ZW50
LT5hcnJheS5yYWlkX2Rpc2tzPSVkOyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmRpc2sucmFpZF9k
aXNrPSVkOyBkZXZtYXBbJWRdID0gJWRcbiIsCisJCSAgICAgICAgIGosIG1vc3RfcmVjZW50LCBj
b250ZW50LT5hcnJheS5yYWlkX2Rpc2tzLCBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmRpc2sucmFp
ZF9kaXNrLAorCQkgICAgICAgICBqICogY29udGVudC0+YXJyYXkucmFpZF9kaXNrcyArIGRldmlj
ZXNbbW9zdF9yZWNlbnRdLmkuZGlzay5yYWlkX2Rpc2ssCisJCSAgICAgICAgIGRldm1hcFtqICog
Y29udGVudC0+YXJyYXkucmFpZF9kaXNrcyArIGRldmljZXNbbW9zdF9yZWNlbnRdLmkuZGlzay5y
YWlkX2Rpc2tdICk7CiAJCWlmIChqICE9IG1vc3RfcmVjZW50ICYmCiAJCSAgICBjb250ZW50LT5h
cnJheS5yYWlkX2Rpc2tzID4gMCAmJgogCQkgICAgZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5kaXNr
LnJhaWRfZGlzayA+PSAwICYmCkBAIC05ODgsNiArMTAwMCw3IEBACiAJCX0KIAl9CiAJZnJlZShk
ZXZtYXApOworZXhpdCggMjU1ICk7CiAJd2hpbGUgKGZvcmNlICYmCiAJICAgICAgICghZW5vdWdo
KGNvbnRlbnQtPmFycmF5LmxldmVsLCBjb250ZW50LT5hcnJheS5yYWlkX2Rpc2tzLAogCQkJY29u
dGVudC0+YXJyYXkubGF5b3V0LCAxLAo=
--047d7b450a42fda2a104e51319d8
Content-Type: text/plain; charset=US-ASCII; name="mdadm-3.2.5-noassemble-patch2.txt"
Content-Disposition: attachment;
	filename="mdadm-3.2.5-noassemble-patch2.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: file4

IyAuL21kYWRtLTMuMi41LW5vYXNzZW1ibGUtcGF0Y2gyIC0tYXNzZW1ibGUgLS1zY2FuIC12Cm1k
YWRtIG1haW46IGZhaWxlZCB0byBnZXQgZXhjbHVzaXZlIGxvY2sgb24gbWFwZmlsZQptZGFkbTog
bG9va2luZyBmb3IgZGV2aWNlcyBmb3IgL2Rldi9tZDAKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9j
ayBvbiAvZGV2L3NkZwptZGFkbTogbm8gUkFJRCBzdXBlcmJsb2NrIG9uIC9kZXYvc2RmCm1kYWRt
OiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9zZGUKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9j
ayBvbiAvZGV2L3NkZAptZGFkbTogbm8gUkFJRCBzdXBlcmJsb2NrIG9uIC9kZXYvc2RjCm1kYWRt
OiBubyBSQUlEIHN1cGVyYmxvY2sgb24gL2Rldi9zZGIKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9j
ayBvbiAvZGV2L3NkYTEKbWRhZG06IG5vIFJBSUQgc3VwZXJibG9jayBvbiAvZGV2L3NkYQptZGFk
bTogL2Rldi9zZGcxIGlzIGlkZW50aWZpZWQgYXMgYSBtZW1iZXIgb2YgL2Rldi9tZDAsIHNsb3Qg
NS4KIyBtb3N0X3JlY2VudD0wOyBkZXZjbnQ9MDsgZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzPTQy
OyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmV2ZW50cz00MjsgZGlzay5zdGF0ZT0wCm1kYWRtOiAv
ZGV2L3NkZjEgaXMgaWRlbnRpZmllZCBhcyBhIG1lbWJlciBvZiAvZGV2L21kMCwgc2xvdCA0Lgoj
IG1vc3RfcmVjZW50PTA7IGRldmNudD0xOyBkZXZpY2VzW2RldmNudF0uaS5ldmVudHM9NDI7IGRl
dmljZXNbbW9zdF9yZWNlbnRdLmkuZXZlbnRzPTQyOyBkaXNrLnN0YXRlPTYKICBuZXc6IG1vc3Rf
cmVjZW50PTE7IGRpc2suc3RhdGU9NgptZGFkbTogL2Rldi9zZGUxIGlzIGlkZW50aWZpZWQgYXMg
YSBtZW1iZXIgb2YgL2Rldi9tZDAsIHNsb3QgMy4KIyBtb3N0X3JlY2VudD0xOyBkZXZjbnQ9Mjsg
ZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzPTQyOyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmV2ZW50
cz00MjsgZGlzay5zdGF0ZT02Cm1kYWRtOiAvZGV2L3NkZDEgaXMgaWRlbnRpZmllZCBhcyBhIG1l
bWJlciBvZiAvZGV2L21kMCwgc2xvdCAyLgojIG1vc3RfcmVjZW50PTE7IGRldmNudD0zOyBkZXZp
Y2VzW2RldmNudF0uaS5ldmVudHM9NDI7IGRldmljZXNbbW9zdF9yZWNlbnRdLmkuZXZlbnRzPTQy
OyBkaXNrLnN0YXRlPTYKbWRhZG06IC9kZXYvc2RjMSBpcyBpZGVudGlmaWVkIGFzIGEgbWVtYmVy
IG9mIC9kZXYvbWQwLCBzbG90IDEuCiMgbW9zdF9yZWNlbnQ9MTsgZGV2Y250PTQ7IGRldmljZXNb
ZGV2Y250XS5pLmV2ZW50cz00MjsgZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5ldmVudHM9NDI7IGRp
c2suc3RhdGU9NgptZGFkbTogL2Rldi9zZGIxIGlzIGlkZW50aWZpZWQgYXMgYSBtZW1iZXIgb2Yg
L2Rldi9tZDAsIHNsb3QgMC4KIyBtb3N0X3JlY2VudD0xOyBkZXZjbnQ9NTsgZGV2aWNlc1tkZXZj
bnRdLmkuZXZlbnRzPTQyOyBkZXZpY2VzW21vc3RfcmVjZW50XS5pLmV2ZW50cz00MjsgZGlzay5z
dGF0ZT02CiMgaj01OyBtb3N0X3JlY2VudD0xOyBjb250ZW50LT5hcnJheS5yYWlkX2Rpc2tzPTU7
IGRldmljZXNbbW9zdF9yZWNlbnRdLmkuZGlzay5yYWlkX2Rpc2s9NDsgZGV2bWFwWzI5XSA9IDEK
IyBqPTQ7IG1vc3RfcmVjZW50PTE7IGNvbnRlbnQtPmFycmF5LnJhaWRfZGlza3M9NTsgZGV2aWNl
c1ttb3N0X3JlY2VudF0uaS5kaXNrLnJhaWRfZGlzaz00OyBkZXZtYXBbMjRdID0gMQojIGo9Mzsg
bW9zdF9yZWNlbnQ9MTsgY29udGVudC0+YXJyYXkucmFpZF9kaXNrcz01OyBkZXZpY2VzW21vc3Rf
cmVjZW50XS5pLmRpc2sucmFpZF9kaXNrPTQ7IGRldm1hcFsxOV0gPSAxCiMgaj0yOyBtb3N0X3Jl
Y2VudD0xOyBjb250ZW50LT5hcnJheS5yYWlkX2Rpc2tzPTU7IGRldmljZXNbbW9zdF9yZWNlbnRd
LmkuZGlzay5yYWlkX2Rpc2s9NDsgZGV2bWFwWzE0XSA9IDEKIyBqPTE7IG1vc3RfcmVjZW50PTE7
IGNvbnRlbnQtPmFycmF5LnJhaWRfZGlza3M9NTsgZGV2aWNlc1ttb3N0X3JlY2VudF0uaS5kaXNr
LnJhaWRfZGlzaz00OyBkZXZtYXBbOV0gPSAxCg==
--047d7b450a42fda2a104e51319d8--
