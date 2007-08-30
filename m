From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: md raid acceleration and the async_tx api
Date: Thu, 30 Aug 2007 12:34:52 -0700
Message-ID: <e9c3a7c20708301234n791b6fe5o12efe4ee61b0f3bd@mail.gmail.com>
References: <200708271249.48684.yur@emcraft.com>
	 <0C7297FA1D2D244A9C7F6959C0BF1E52025B10C6@azsmsx413.amr.corp.intel.com>
	 <200708301857.09564.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_6243_29848045.1188502492876"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200708301857.09564.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, Wolfgang Denk <wd@denx.de>, dzu@denx.de
List-Id: linux-raid.ids

------=_Part_6243_29848045.1188502492876
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 8/30/07, Yuri Tikhonov <yur@emcraft.com> wrote:
>
>  Hi Dan,
>
> On Monday 27 August 2007 23:12, you wrote:
> > This still looks racy...  I think the complete fix is to make the
> > R5_Wantfill and dev_q->toread accesses atomic.  Please test the
> > following patch (also attached) and let me know if it fixes what you are
> > seeing:
>
>  Your approach doesn't help, the Bonnie++ utility hangs up during the
> ReWriting stage.
>
Looking at it again I see that what I added would not affect the
failure you are seeing.  However I noticed that you are using a broken
version of the stripe-queue and cache_arbiter patches.  In the current
revisions the dev_q->flags field has been moved back to dev->flags
which fixes a data corruption issue and could potentially address the
hang you are seeing.  The latest revisions are:
raid5: add the stripe_queue object for tracking raid io requests (rev2)
raid5: use stripe_queues to prioritize the "most deserving" requests (rev6)

>  Note that before applying your patch I rolled my fix in the
> ops_complete_biofill() function back. Do I understand it right that your
> patch should be used *instead* of my one rather than *with* it ?
>
You understood correctly.  The attached patch integrates your change
to keep R5_Wantfill set while also protecting the 'more_to_read' case.
 Please try it on top of the latest stripe-queue changes [1] (instead
of the other proposed patches) .

>  Regards, Yuri

Thanks,
Dan

[1] git fetch -f git://lost.foo-projects.org/~dwillia2/git/iop
md-for-linus:refs/heads/md-for-linus

------=_Part_6243_29848045.1188502492876
Content-Type: text/x-patch; name="fix-ops-complete-biofill.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fix-ops-complete-biofill.patch";
 filename="fix-ops-complete-biofill.patch"
X-Attachment-Id: f_f5znl6a3

cmFpZDU6IGZpeCB0aGUgJ21vcmVfdG9fcmVhZCcgY2FzZSBpbiBvcHNfY29tcGxldGVfYmlvZmls
bAoKRnJvbTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CgpQcmV2ZW50
IG9wc19jb21wbGV0ZV9iaW9maWxsIGZyb20gcnVubmluZyBjb25jdXJyZW50bHkgd2l0aCBhZGRf
cXVldWVfYmlvCgotLS0KCiBkcml2ZXJzL21kL3JhaWQ1LmMgfCAgIDMzICsrKysrKysrKysrKysr
KysrKystLS0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAx
NCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQ1LmMgYi9kcml2ZXJz
L21kL3JhaWQ1LmMKaW5kZXggMmY5MDIyZC4uMWM1OTFkMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZC9yYWlkNS5jCisrKyBiL2RyaXZlcnMvbWQvcmFpZDUuYwpAQCAtODI4LDIyICs4MjgsMTkgQEAg
c3RhdGljIHZvaWQgb3BzX2NvbXBsZXRlX2Jpb2ZpbGwodm9pZCAqc3RyaXBlX2hlYWRfcmVmKQog
CQlzdHJ1Y3QgcjVkZXYgKmRldiA9ICZzaC0+ZGV2W2ldOwogCQlzdHJ1Y3QgcjVfcXVldWVfZGV2
ICpkZXZfcSA9ICZzcS0+ZGV2W2ldOwogCi0JCS8qIGNoZWNrIGlmIHRoaXMgc3RyaXBlIGhhcyBu
ZXcgaW5jb21pbmcgcmVhZHMgKi8KKwkJLyogMS8gYWNrbm93bGVkZ2UgY29tcGxldGlvbiBvZiBh
IGJpb2ZpbGwgb3BlcmF0aW9uCisJCSAqIDIvIGNoZWNrIGlmIHdlIG5lZWQgdG8gcmVwbHkgdG8g
YSByZWFkIHJlcXVlc3QuCisJCSAqIDMvIGNoZWNrIGlmIHdlIG5lZWQgdG8gcmVzY2hlZHVsZSBo
YW5kbGVfc3RyaXBlCisJCSAqLwogCQlpZiAoZGV2X3EtPnRvcmVhZCkKIAkJCW1vcmVfdG9fcmVh
ZCsrOwogCi0JCS8qIGFja25vd2xlZGdlIGNvbXBsZXRpb24gb2YgYSBiaW9maWxsIG9wZXJhdGlv
biAqLwotCQkvKiBhbmQgY2hlY2sgaWYgd2UgbmVlZCB0byByZXBseSB0byBhIHJlYWQgcmVxdWVz
dAotCQkqLwotCQlpZiAodGVzdF9iaXQoUjVfV2FudGZpbGwsICZkZXYtPmZsYWdzKSAmJiAhZGV2
X3EtPnRvcmVhZCkgeworCQlpZiAodGVzdF9iaXQoUjVfV2FudGZpbGwsICZkZXYtPmZsYWdzKSkg
ewogCQkJc3RydWN0IGJpbyAqcmJpLCAqcmJpMjsKLQkJCWNsZWFyX2JpdChSNV9XYW50ZmlsbCwg
JmRldi0+ZmxhZ3MpOwogCi0JCQkvKiBUaGUgYWNjZXNzIHRvIGRldi0+cmVhZCBpcyBvdXRzaWRl
IG9mIHRoZQotCQkJICogc3Bpbl9sb2NrX2lycSgmY29uZi0+ZGV2aWNlX2xvY2spLCBidXQgaXMg
cHJvdGVjdGVkCi0JCQkgKiBieSB0aGUgU1RSSVBFX09QX0JJT0ZJTEwgcGVuZGluZyBiaXQKLQkJ
CSAqLwotCQkJQlVHX09OKCFkZXYtPnJlYWQpOworCQkJaWYgKCFkZXZfcS0+dG9yZWFkKQorCQkJ
CWNsZWFyX2JpdChSNV9XYW50ZmlsbCwgJmRldi0+ZmxhZ3MpOworCiAJCQlyYmkgPSBkZXYtPnJl
YWQ7CiAJCQlkZXYtPnJlYWQgPSBOVUxMOwogCQkJd2hpbGUgKHJiaSAmJiByYmktPmJpX3NlY3Rv
ciA8CkBAIC04OTksOCArODk2LDE1IEBAIHN0YXRpYyB2b2lkIG9wc19ydW5fYmlvZmlsbChzdHJ1
Y3Qgc3RyaXBlX2hlYWQgKnNoKQogCX0KIAogCWF0b21pY19pbmMoJnNoLT5jb3VudCk7CisKKwkv
KiBzcGluX2xvY2sgcHJldmVudHMgb3BzX2NvbXBsZXRlX2Jpb2ZpbGwgZnJvbSBydW5uaW5nIGNv
bmN1cnJlbnRseQorCSAqIHdpdGggYWRkX3F1ZXVlX2JpbyBpbiB0aGUgc3luY2hyb25vdXMgY2Fz
ZQorCSAqLworCXNwaW5fbG9jaygmc3EtPmxvY2spOwogCWFzeW5jX3RyaWdnZXJfY2FsbGJhY2so
QVNZTkNfVFhfREVQX0FDSyB8IEFTWU5DX1RYX0FDSywgdHgsCiAJCW9wc19jb21wbGV0ZV9iaW9m
aWxsLCBzaCk7CisJc3Bpbl91bmxvY2soJnNxLT5sb2NrKTsKKwogfQogCiBzdGF0aWMgdm9pZCBv
cHNfY29tcGxldGVfY29tcHV0ZTUodm9pZCAqc3RyaXBlX2hlYWRfcmVmKQpAQCAtMjI3OSw3ICsy
MjgzLDggQEAgc3RhdGljIGludCBhZGRfcXVldWVfYmlvKHN0cnVjdCBzdHJpcGVfcXVldWUgKnNx
LCBzdHJ1Y3QgYmlvICpiaSwgaW50IGRkX2lkeCwKIAkJKHVuc2lnbmVkIGxvbmcgbG9uZyliaS0+
Ymlfc2VjdG9yLAogCQkodW5zaWduZWQgbG9uZyBsb25nKXNxLT5zZWN0b3IpOwogCi0Jc3Bpbl9s
b2NrKCZzcS0+bG9jayk7CisJLyogcHJldmVudCBhc3luY2hyb25vdXMgY29tcGxldGlvbnMgZnJv
bSBydW5uaW5nICovCisJc3Bpbl9sb2NrX2JoKCZzcS0+bG9jayk7CiAJc3Bpbl9sb2NrX2lycSgm
Y29uZi0+ZGV2aWNlX2xvY2spOwogCXNoID0gc3EtPnNoOwogCWlmIChmb3J3cml0ZSkgewpAQCAt
MjMwNiw3ICsyMzExLDcgQEAgc3RhdGljIGludCBhZGRfcXVldWVfYmlvKHN0cnVjdCBzdHJpcGVf
cXVldWUgKnNxLCBzdHJ1Y3QgYmlvICpiaSwgaW50IGRkX2lkeCwKIAkqYmlwID0gYmk7CiAJYmkt
PmJpX3BoeXNfc2VnbWVudHMgKys7CiAJc3Bpbl91bmxvY2tfaXJxKCZjb25mLT5kZXZpY2VfbG9j
ayk7Ci0Jc3Bpbl91bmxvY2soJnNxLT5sb2NrKTsKKwlzcGluX3VubG9ja19iaCgmc3EtPmxvY2sp
OwogCiAJcHJfZGVidWcoImFkZGVkIGJpIGIjJWxsdSB0byBzdHJpcGUgcyMlbGx1LCBkaXNrICVk
LlxuIiwKIAkJKHVuc2lnbmVkIGxvbmcgbG9uZyliaS0+Ymlfc2VjdG9yLApAQCAtMjMzOSw3ICsy
MzQ0LDcgQEAgc3RhdGljIGludCBhZGRfcXVldWVfYmlvKHN0cnVjdCBzdHJpcGVfcXVldWUgKnNx
LCBzdHJ1Y3QgYmlvICpiaSwgaW50IGRkX2lkeCwKICBvdmVybGFwOgogCXNldF9iaXQoUjVfT3Zl
cmxhcCwgJnNoLT5kZXZbZGRfaWR4XS5mbGFncyk7CiAJc3Bpbl91bmxvY2tfaXJxKCZjb25mLT5k
ZXZpY2VfbG9jayk7Ci0Jc3Bpbl91bmxvY2soJnNxLT5sb2NrKTsKKwlzcGluX3VubG9ja19iaCgm
c3EtPmxvY2spOwogCXJldHVybiAwOwogfQogCg==
------=_Part_6243_29848045.1188502492876--
