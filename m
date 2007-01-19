From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/12] md raid acceleration and the async_tx api
Date: Thu, 18 Jan 2007 18:50:16 -0700
Message-ID: <e9c3a7c20701181750kd18d730tf1947075503f91ce@mail.gmail.com>
References: <E1H7TAs-0009kG-00.yur_t-mail-ru@f79.mail.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_123354_9248640.1169171416565"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1H7TAs-0009kG-00.yur_t-mail-ru@f79.mail.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur_t@mail.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_123354_9248640.1169171416565
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 1/18/07, Yuri Tikhonov <yur_t@mail.ru> wrote:
>
>  Hello, Dan.
Hello.
>
>  It seems there is a bug in your 06.11.30 raid acceleration patch-set. I tried to run the
>Linux s/w RAID-5 driver patched with your 06.11.30 patch-set and
found that it fails during
>write operations when the RAID-5 array consists of 6 or more number
of drives (I tested up
>to 8 drives). For 5 and less number of drives everything works as
expected. There are no
>such problems with your 06.09.12 set of patches. Do you have any
assumptions about the
>reasons of this fault?
>
Yes, sorry, there were bugs in the synchronous path around handling >
MAX_XOR_BLOCKS that I have fixed for the next rev of the patches.
I'll be releasing them shortly, but attached is a patch to address the
issue you are seeing.

>The kernel I used was 2.6.19, your 06.11.30 patch-set was applied without any
>warnings/errors. Here is the kernel Oops report:
>
> Oops: kernel access of bad area, sig: 11 [#1]
> NIP: C014F980 LR: C014FD0C CTR: 00000080
> REGS: eee49d40 TRAP: 0300   Not tainted  (2.6.19-g0726acdc-dirty)
> MSR: 00029000 <EE,ME>  CR: 44002042  XER: 20000000
> DAR: 17970004, DSISR: 00000000
> TASK = eed5a7d0[280] 'md0_raid5_ops/0' THREAD: eee48000
> GPR00: 0000007F EEE49DF0 EED5A7D0 00000080 EEDFC000 00000000 19D70000 17870000
> GPR08: 00001000 C02B0000 EEDFC000 C014F950 EEDFC000 30000000 C015B8D8 17970000
> GPR16: C08AC180 C02B0000 EEE0CB48 0000003A 0000000C 00001000 00000000 00000001
> GPR24: 00000000 C015B8D8 00000004 0000003A EEDFC000 00000004 19D70000 17870000
> NIP [C014F980] xor_32regs_4+0x30/0x158
> LR [C014FD0C] xor_block+0xc4/0x12c
> Call Trace:
> [EEE49E40] [EEE49E58] 0xeee49e58
> [EEE49E50] [C014EFAC] async_xor+0x134/0x200
> [EEE49EB0] [C015A960] ops_run_postxor+0xf8/0x198
> [EEE49F00] [C0162458] raid5_run_ops+0x8dc/0x994
> [EEE49F50] [C0029F7C] run_workqueue+0xa4/0x118
> [EEE49F70] [C002A198] worker_thread+0xf8/0x13c
> [EEE49FC0] [C002E20C] kthread+0xf8/0x100
> [EEE49FF0] [C0003DA0] kernel_thread+0x44/0x60
> Instruction dump:
> 5463d97e 7c601b78 3400ffff 9421ffb0 bde1000c 7c6903a6 7c8c2378 7caf2b78
> 7cde3378 7cff3b78 41800124 80ac0000 <82ef0004> 82cf0008 82af000c 828f0010
>
>  Regards, Yuri.
>
Thanks for testing the patches.

Regards,
Dan

------=_Part_123354_9248640.1169171416565
Content-Type: text/x-patch; name=async_xor-fix-2.6.19.patch;
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ex3y7c7b
Content-Disposition: attachment; filename="async_xor-fix-2.6.19.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL2FzeW5jX3R4LmMgYi9kcml2ZXJzL2RtYS9hc3luY190
eC5jCmluZGV4IGQ5MThjYzMuLmVlZTIwOGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1hL2FzeW5j
X3R4LmMKKysrIGIvZHJpdmVycy9kbWEvYXN5bmNfdHguYwpAQCAtMzI0LDkgKzMyNCw2IEBAIGFz
eW5jX3R4X2ZpbmRfY2hhbm5lbChzdHJ1Y3QgZG1hX2FzeW5jX3R4X2Rlc2NyaXB0b3IgKmRlcGVu
ZF90eCwKIH0KICNlbmRpZgogCi0jZGVmaW5lIHRvX2lvcF9hZG1hX2NoYW4oY2hhbikgY29udGFp
bmVyX29mKGNoYW4sIHN0cnVjdCBpb3BfYWRtYV9jaGFuLCBjb21tb24pCi0jZGVmaW5lIHR4X3Rv
X2lvcF9hZG1hX3Nsb3QodHgpIGNvbnRhaW5lcl9vZih0eCwgc3RydWN0IGlvcF9hZG1hX2Rlc2Nf
c2xvdCwgYXN5bmNfdHgpCi0KIHN0YXRpYyBpbmxpbmUgdm9pZAogYXN5bmNfdHhfc3VibWl0KHN0
cnVjdCBkbWFfY2hhbiAqY2hhbiwgc3RydWN0IGRtYV9hc3luY190eF9kZXNjcmlwdG9yICp0eCwK
IAllbnVtIGFzeW5jX3R4X2ZsYWdzIGZsYWdzLCBzdHJ1Y3QgZG1hX2FzeW5jX3R4X2Rlc2NyaXB0
b3IgKmRlcGVuZF90eCwKQEAgLTQyMywxNyArNDIwLDEyIEBAIGRvX3N5bmNfeG9yKHN0cnVjdCBw
YWdlICpkZXN0LCBzdHJ1Y3QgcGFnZSAqKnNyY19saXN0LCB1bnNpZ25lZCBpbnQgb2Zmc2V0LAog
CWRtYV9hc3luY190eF9jYWxsYmFjayBjYWxsYmFjaywgdm9pZCAqY2FsbGJhY2tfcGFyYW0pCiB7
CiAJdm9pZCAqX2Rlc3Q7Ci0JaW50IHN0YXJ0X2lkeCwgaTsKKwlpbnQgaTsKIAogCVBSSU5USygi
JXM6IGxlbjogJXVcbiIsIF9fRlVOQ1RJT05fXywgbGVuKTsKIAogCS8qIHJldXNlIHRoZSAnc3Jj
X2xpc3QnIGFycmF5IHRvIGNvbnZlcnQgdG8gYnVmZmVyIHBvaW50ZXJzICovCi0JaWYgKGZsYWdz
ICYgQVNZTkNfVFhfWE9SX0RST1BfRFNUKQotCQlzdGFydF9pZHggPSAxOwotCWVsc2UKLQkJc3Rh
cnRfaWR4ID0gMDsKLQotCWZvciAoaSA9IHN0YXJ0X2lkeDsgaSA8IHNyY19jbnQ7IGkrKykKKwlm
b3IgKGkgPSAwOyBpIDwgc3JjX2NudDsgaSsrKQogCQlzcmNfbGlzdFtpXSA9IChzdHJ1Y3QgcGFn
ZSAqKQogCQkJKHBhZ2VfYWRkcmVzcyhzcmNfbGlzdFtpXSkgKyBvZmZzZXQpOwogCkBAIC00NDMs
OCArNDM1LDggQEAgZG9fc3luY194b3Ioc3RydWN0IHBhZ2UgKmRlc3QsIHN0cnVjdCBwYWdlICoq
c3JjX2xpc3QsIHVuc2lnbmVkIGludCBvZmZzZXQsCiAJaWYgKGZsYWdzICYgQVNZTkNfVFhfWE9S
X1pFUk9fRFNUKQogCQltZW1zZXQoX2Rlc3QsIDAsIGxlbik7CiAKLQl4b3JfYmxvY2soc3JjX2Nu
dCAtIHN0YXJ0X2lkeCwgbGVuLCBfZGVzdCwKLQkJKHZvaWQgKiopICZzcmNfbGlzdFtzdGFydF9p
ZHhdKTsKKwl4b3JfYmxvY2soc3JjX2NudCwgbGVuLCBfZGVzdCwKKwkJKHZvaWQgKiopIHNyY19s
aXN0KTsKIAogCXN5bmNfZXBpbG9nKGZsYWdzLCBkZXBlbmRfdHgsIGNhbGxiYWNrLCBjYWxsYmFj
a19wYXJhbSk7CiB9CkBAIC01MTQsNyArNTA2LDE1IEBAIGFzeW5jX3hvcihzdHJ1Y3QgcGFnZSAq
ZGVzdCwgc3RydWN0IHBhZ2UgKipzcmNfbGlzdCwgdW5zaWduZWQgaW50IG9mZnNldCwKIAkJCQln
b3RvIHhvcl9zeW5jOwogCQl9IGVsc2UgeyAvKiBydW4gdGhlIHhvciBzeW5jaHJvbm91c2x5ICov
CiB4b3Jfc3luYzoKLQkJCS8qIHByb2Nlc3MgdXAgdG8gJ21heF94b3JfYmxvY2tzJyBzb3VyY2Vz
ICovCisJCQkvKiBpbiB0aGUgc3luYyBjYXNlIHRoZSBkZXN0IGlzIGFuIGltcGxpZWQgc291cmNl
CisJCQkgKiAoYXNzdW1lcyB0aGUgZGVzdCBpcyBhdCB0aGUgc3JjX29mZiBpbmRleCkKKwkJCSAq
LworCQkJaWYgKGZsYWdzICYgQVNZTkNfVFhfWE9SX0RST1BfRFNUKSB7CisJCQkJc3JjX2NudC0t
OworCQkJCXNyY19vZmYrKzsKKwkJCX0KKworCQkJLyogcHJvY2VzcyB1cCB0byAnTUFYX1hPUl9C
TE9DS1MnIHNvdXJjZXMgKi8KIAkJCXhvcl9zcmNfY250ID0gbWluKHNyY19jbnQsICh1bnNpZ25l
ZCBpbnQpIE1BWF9YT1JfQkxPQ0tTKTsKIAogCQkJLyogaWYgd2UgYXJlIHN1Ym1pdHRpbmcgYWRk
aXRpb25hbCB4b3JzCkBAIC01NDAsOSArNTQwLDkgQEAgeG9yX3N5bmM6CiAJCQkJCQlfX0ZVTkNU
SU9OX18pOwogCQkJfQogCi0JCQlkb19zeW5jX3hvcihkZXN0LCAmc3JjX2xpc3Rbc3JjX29mZl0s
IG9mZnNldCwgc3JjX2NudCwKLQkJCQlsZW4sIGxvY2FsX2ZsYWdzLCBkZXBlbmRfdHgsIF9jYWxs
YmFjaywKLQkJCQlfY2FsbGJhY2tfcGFyYW0pOworCQkJZG9fc3luY194b3IoZGVzdCwgJnNyY19s
aXN0W3NyY19vZmZdLCBvZmZzZXQsCisJCQkJeG9yX3NyY19jbnQsIGxlbiwgbG9jYWxfZmxhZ3Ms
IGRlcGVuZF90eCwKKwkJCQlfY2FsbGJhY2ssIF9jYWxsYmFja19wYXJhbSk7CiAJCX0KIAogCQkv
KiB0aGUgcHJldmlvdXMgdHggaXMgaGlkZGVuIGZyb20gdGhlIGNsaWVudCwKQEAgLTU1NiwxMyAr
NTU2LDE1IEBAIHhvcl9zeW5jOgogCQlpZiAoc3JjX2NudCA+IHhvcl9zcmNfY250KSB7CiAJCQkv
KiBkcm9wIGNvbXBsZXRlZCBzb3VyY2VzICovCiAJCQlzcmNfY250IC09IHhvcl9zcmNfY250Owor
CQkJc3JjX29mZiArPSB4b3Jfc3JjX2NudDsKIAogCQkJLyogdW5jb25kaXRpb25hbGx5IHByZXNl
cnZlIHRoZSBkZXN0aW5hdGlvbiAqLwogCQkJZmxhZ3MgJj0gfkFTWU5DX1RYX1hPUl9aRVJPX0RT
VDsKIAotCQkJLyogdXNlIHRoZSBpbnRlcm1lZGlhdGUgcmVzdWx0IGEgc291cmNlICovCi0JCQlz
cmNfb2ZmID0geG9yX3NyY19jbnQgLSAxOwotCQkJc3JjX2xpc3Rbc3JjX29mZl0gPSBkZXN0Owor
CQkJLyogdXNlIHRoZSBpbnRlcm1lZGlhdGUgcmVzdWx0IGEgc291cmNlLCBidXQgcmVtZW1iZXIK
KwkJCSAqIGl0J3MgZHJvcHBlZCwgYmVjYXVzZSBpdCdzIGltcGxpZWQsIGluIHRoZSBzeW5jIGNh
c2UKKwkJCSAqLworCQkJc3JjX2xpc3RbLS1zcmNfb2ZmXSA9IGRlc3Q7CiAJCQlzcmNfY250Kys7
CiAJCQlmbGFncyB8PSBBU1lOQ19UWF9YT1JfRFJPUF9EU1Q7CiAJCX0gZWxzZQo=
------=_Part_123354_9248640.1169171416565--
