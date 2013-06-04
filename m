From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAD1 doesn't fail WRITE that was written only on a rebuilding drive
Date: Tue, 4 Jun 2013 20:54:28 +0300
Message-ID: <CAGRgLy4SQTvc15quiU_YJreqG2ODGey3iUrLJjhQL4EcMwJFMA@mail.gmail.com>
References: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
	<20130604095235.16261243@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c2165cd1ae6404de57c565
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130604095235.16261243@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--001a11c2165cd1ae6404de57c565
Content-Type: text/plain; charset=ISO-8859-1

Hello Neil,

On Tue, Jun 4, 2013 at 2:52 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 28 May 2013 15:46:33 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hello Neil,
>> we continue testing last-drive RAID1 failure cases.
>> We see the following issue:
>>
>> # RAID1 with drives A and B; drive B was freshly-added and is rebuilding
>> # Drive A fails
>> # WRITE request arrives to the array. It is failed by drive A, so
>> r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
>> succeeds in writing it, so the same r1_bio is marked as
>> R1BIO_Uptodate.
>> # r1_bio arrives to handle_write_finished, badblocks are disabled,
>> md_error()->error() does nothing because we don't fail the last drive
>> of raid1
>> # raid_end_bio_io()  calls call_bio_endio()
>> # As a result, in call_bio_endio():
>>       if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>>               clear_bit(BIO_UPTODATE, &bio->bi_flags);
>> this code doesn't clear the BIO_UPTODATE flag, and the whole master
>> WRITE succeeds, back to the upper layer.
>>
>> # This keeps happening until rebuild aborts, and drive B is ejected
>> from the array[1]. After that, there is only one drive (A), so after
>> it fails a WRITE, the master WRITE also fails.
>>
>> It should be noted, that I test a WRITE that is way ahead of
>> recovery_offset of drive B. So after such WRITE fails, subsequent READ
>> to the same place would fail, because drive A will fail it, and drive
>> B cannot be attempted to READ from there (rebuild has not reached
>> there yet).
>>
>> My concrete suggestion is that this behavior is not reasonable, and we
>> should only count a successful WRITE to a drive that is marked as
>> InSync. Please let me know what do you think?
>
> Sounds reasonable.  Could you make and test a patch?  Then I'll apply it.

I read all the code of raid1.c, and it seems that we need to fix only
one place. With this fix, I don't see corruption after I fail and then
revive the last drive of raid1. I also attach the patch, in case Gmail
wraps it.

Also, with this fix, the rebuilding drive is ejected almost
immediately, so the second part of the problem doesn't happen now.
Although I will consider your suggestion for it later.



From 8d25ada35b5e1ec6ea4c6da6e571ec691b34086a Mon Sep 17 00:00:00 2001
From: Alex Lyakas <alex@zadarastorage.com>
Date: Tue, 4 Jun 2013 20:42:21 +0300
Subject: [PATCH] md/raid1: consider WRITE as successful only if at least one
 non-Faulty and non-rebuilding drive completed it.

Without that fix, the following scenario could happen:

- RAID1 with drives A and B; drive B was freshly-added and is rebuilding
- Drive A fails
- WRITE request arrives to the array. It is failed by drive A, so
r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
succeeds in writing it, so the same r1_bio is marked as
R1BIO_Uptodate.
- r1_bio arrives to handle_write_finished, badblocks are disabled,
md_error()->error() does nothing because we don't fail the last drive
of raid1
- raid_end_bio_io()  calls call_bio_endio()
- As a result, in call_bio_endio():
        if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
                clear_bit(BIO_UPTODATE, &bio->bi_flags);
this code doesn't clear the BIO_UPTODATE flag, and the whole master
WRITE succeeds, back to the upper layer.

So we returned success to the upper layer, even though we had written
the data onto the rebuilding drive only. But when we want to read the
data back, we would not read from the rebuilding drive, so this data
is lost.

Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
---
 drivers/md/raid1.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6af167f..d8d159e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -427,7 +427,17 @@ static void raid1_end_write_request(struct bio
*bio, int error)

 		r1_bio->bios[mirror] = NULL;
 		to_put = bio;
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+		/*
+		 * Do not set R1BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &conf->mirrors[mirror].rdev->flags) &&
+			!test_bit(Faulty, &conf->mirrors[mirror].rdev->flags))
+			set_bit(R1BIO_Uptodate, &r1_bio->state);

 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(conf->mirrors[mirror].rdev,
-- 
1.7.9.5

--001a11c2165cd1ae6404de57c565
Content-Type: application/octet-stream;
	name="0001-md-raid1-consider-WRITE-as-successful-only-if-at-lea.patch"
Content-Disposition: attachment;
	filename="0001-md-raid1-consider-WRITE-as-successful-only-if-at-lea.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhjdynlc1

RnJvbSA4ZDI1YWRhMzViNWUxZWM2ZWE0YzZkYTZlNTcxZWM2OTFiMzQwODZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IEx5YWthcyA8YWxleEB6YWRhcmFzdG9yYWdlLmNvbT4K
RGF0ZTogVHVlLCA0IEp1biAyMDEzIDIwOjQyOjIxICswMzAwClN1YmplY3Q6IFtQQVRDSF0gbWQv
cmFpZDE6IGNvbnNpZGVyIFdSSVRFIGFzIHN1Y2Nlc3NmdWwgb25seSBpZiBhdCBsZWFzdCBvbmUK
IG5vbi1GYXVsdHkgYW5kIG5vbi1yZWJ1aWxkaW5nIGRyaXZlIGNvbXBsZXRlZCBpdC4KCldpdGhv
dXQgdGhhdCBmaXgsIHRoZSBmb2xsb3dpbmcgc2NlbmFyaW8gY291bGQgaGFwcGVuOgoKLSBSQUlE
MSB3aXRoIGRyaXZlcyBBIGFuZCBCOyBkcml2ZSBCIHdhcyBmcmVzaGx5LWFkZGVkIGFuZCBpcyBy
ZWJ1aWxkaW5nCi0gRHJpdmUgQSBmYWlscwotIFdSSVRFIHJlcXVlc3QgYXJyaXZlcyB0byB0aGUg
YXJyYXkuIEl0IGlzIGZhaWxlZCBieSBkcml2ZSBBLCBzbwpyMV9iaW8gaXMgbWFya2VkIGFzIFIx
QklPX1dyaXRlRXJyb3IsIGJ1dCB0aGUgcmVidWlsZGluZyBkcml2ZSBCCnN1Y2NlZWRzIGluIHdy
aXRpbmcgaXQsIHNvIHRoZSBzYW1lIHIxX2JpbyBpcyBtYXJrZWQgYXMKUjFCSU9fVXB0b2RhdGUu
Ci0gcjFfYmlvIGFycml2ZXMgdG8gaGFuZGxlX3dyaXRlX2ZpbmlzaGVkLCBiYWRibG9ja3MgYXJl
IGRpc2FibGVkLAptZF9lcnJvcigpLT5lcnJvcigpIGRvZXMgbm90aGluZyBiZWNhdXNlIHdlIGRv
bid0IGZhaWwgdGhlIGxhc3QgZHJpdmUKb2YgcmFpZDEKLSByYWlkX2VuZF9iaW9faW8oKSAgY2Fs
bHMgY2FsbF9iaW9fZW5kaW8oKQotIEFzIGEgcmVzdWx0LCBpbiBjYWxsX2Jpb19lbmRpbygpOgog
ICAgICAgIGlmICghdGVzdF9iaXQoUjFCSU9fVXB0b2RhdGUsICZyMV9iaW8tPnN0YXRlKSkKICAg
ICAgICAgICAgICAgIGNsZWFyX2JpdChCSU9fVVBUT0RBVEUsICZiaW8tPmJpX2ZsYWdzKTsKdGhp
cyBjb2RlIGRvZXNuJ3QgY2xlYXIgdGhlIEJJT19VUFRPREFURSBmbGFnLCBhbmQgdGhlIHdob2xl
IG1hc3RlcgpXUklURSBzdWNjZWVkcywgYmFjayB0byB0aGUgdXBwZXIgbGF5ZXIuCgpTbyB3ZSBy
ZXR1cm5lZCBzdWNjZXNzIHRvIHRoZSB1cHBlciBsYXllciwgZXZlbiB0aG91Z2ggd2UgaGFkIHdy
aXR0ZW4KdGhlIGRhdGEgb250byB0aGUgcmVidWlsZGluZyBkcml2ZSBvbmx5LiBCdXQgd2hlbiB3
ZSB3YW50IHRvIHJlYWQgdGhlCmRhdGEgYmFjaywgd2Ugd291bGQgbm90IHJlYWQgZnJvbSB0aGUg
cmVidWlsZGluZyBkcml2ZSwgc28gdGhpcyBkYXRhCmlzIGxvc3QuCgpTaWduZWQtb2ZmLWJ5OiBB
bGV4IEx5YWthcyA8YWxleEB6YWRhcmFzdG9yYWdlLmNvbT4KLS0tCiBkcml2ZXJzL21kL3JhaWQx
LmMgfCAgIDEyICsrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQxLmMgYi9kcml2ZXJz
L21kL3JhaWQxLmMKaW5kZXggNmFmMTY3Zi4uZDhkMTU5ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZC9yYWlkMS5jCisrKyBiL2RyaXZlcnMvbWQvcmFpZDEuYwpAQCAtNDI3LDcgKzQyNywxNyBAQCBz
dGF0aWMgdm9pZCByYWlkMV9lbmRfd3JpdGVfcmVxdWVzdChzdHJ1Y3QgYmlvICpiaW8sIGludCBl
cnJvcikKIAogCQlyMV9iaW8tPmJpb3NbbWlycm9yXSA9IE5VTEw7CiAJCXRvX3B1dCA9IGJpbzsK
LQkJc2V0X2JpdChSMUJJT19VcHRvZGF0ZSwgJnIxX2Jpby0+c3RhdGUpOworCQkvKgorCQkgKiBE
byBub3Qgc2V0IFIxQklPX1VwdG9kYXRlIGlmIHRoZSBjdXJyZW50IGRldmljZSBpcyAKKwkJICog
cmVidWlsZGluZyBvciBGYXVsdHkuIFRoaXMgaXMgYmVjYXVzZSB3ZSBjYW5ub3QgdXNlCisJCSAq
IHN1Y2ggZGV2aWNlIGZvciBwcm9wZXJseSByZWFkaW5nIHRoZSBkYXRhIGJhY2sgKHdlIGNvdWxk
CisJCSAqIHBvdGVudGlhbGx5IHVzZSBpdCwgaWYgdGhlIGN1cnJlbnQgd3JpdGUgd291bGQgaGF2
ZSBmZWx0CisJCSAqIGJlZm9yZSByZGV2LT5yZWNvdmVyeV9vZmZzZXQsIGJ1dCBmb3Igc2ltcGxp
Y2l0eSB3ZSBkb24ndAorCQkgKiBjaGVjayB0aGlzIGhlcmUuCisJCSAqLworCQlpZiAodGVzdF9i
aXQoSW5fc3luYywgJmNvbmYtPm1pcnJvcnNbbWlycm9yXS5yZGV2LT5mbGFncykgJiYKKwkJCSF0
ZXN0X2JpdChGYXVsdHksICZjb25mLT5taXJyb3JzW21pcnJvcl0ucmRldi0+ZmxhZ3MpKQorCQkJ
c2V0X2JpdChSMUJJT19VcHRvZGF0ZSwgJnIxX2Jpby0+c3RhdGUpOwogCiAJCS8qIE1heWJlIHdl
IGNhbiBjbGVhciBzb21lIGJhZCBibG9ja3MuICovCiAJCWlmIChpc19iYWRibG9jayhjb25mLT5t
aXJyb3JzW21pcnJvcl0ucmRldiwKLS0gCjEuNy45LjUKCg==
--001a11c2165cd1ae6404de57c565--
