From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: fsync() on read-only RAID triggers BUG
Date: Fri, 25 Jan 2013 16:09:15 +0100
Message-ID: <5102A01B.7000407@profitbricks.com>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060305090204040101040307"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060305090204040101040307
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20.01.2013 19:44, Ben Hutchings wrote:
> # Call fsync()
> python -c "import os; os.fsync(os.open('/dev/md0', os.O_RDWR))"
> --- END ---
> 
> I assume that the sync request should be filtered out at some point
> before this assertion is made, since there can be nothing to sync.
> 

I wrote a test case in C. It gets SIGSEGV upon fsync. When making the
rdevs below also read-only the MD device can't be stopped anymore as it
thinks that there is still active IO.

The attached patch should fix it. Please confirm. We have to return a
completion without incrementing the active IO count. Error code -EROFS
seems to be suited best.

But the libc fsync gets -EIO anyway:
Input/output error

Any objection?

Cheers,
Sebastian

--------------060305090204040101040307
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"

RnJvbSBmZTAzNTczNDQ4NzdjOWI5Y2M2MjNmZDU4MmE0ZTA2NzBlNDQ4MzE3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTZWJhc3RpYW4gUmllbWVyIDxzZWJhc3RpYW4ucmll
bWVyQHByb2ZpdGJyaWNrcy5jb20+CkRhdGU6IEZyaSwgMjUgSmFuIDIwMTMgMTI6NDY6NTkg
KzAxMDAKU3ViamVjdDogW1BBVENIXSBtZDogcHJvdGVjdCBhZ2FpbnN0IGNyYXNoIHVwb24g
ZnN5bmMgb24gcm8gYXJyYXkKCklmIGFuIGZzeW5jIG9jY3VycnMgb24gYSByZWFkLW9ubHkg
YXJyYXksIHdlIG5lZWQgdG8gc2VuZCBhCmNvbXBsZXRpb24gZm9yIHRoZSBJTyBhbmQgbWF5
IG5vdCBpbmNyZW1lbnQgdGhlIGFjdGl2ZSBJTyBjb3VudC4KT3RoZXJ3aXNlLCB3ZSBoaXQg
YSBidWcgdHJhY2UgYW5kIGNhbid0IHN0b3AgdGhlIE1EIGFycmF5IGFueW1vcmUuCgpBcyBy
ZXR1cm4gdmFsdWUgLUVST0ZTIG1ha2VzIG1vc3Qgc2Vuc2UuCgpTaWduZWQtb2ZmLWJ5OiBT
ZWJhc3RpYW4gUmllbWVyIDxzZWJhc3RpYW4ucmllbWVyQHByb2ZpdGJyaWNrcy5jb20+Ci0t
LQogZHJpdmVycy9tZC9tZC5jIHwgICAgNSArKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9t
ZC5jIGIvZHJpdmVycy9tZC9tZC5jCmluZGV4IDNkYjNkMWIuLjQ3NWUwYmUgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvbWQvbWQuYworKysgYi9kcml2ZXJzL21kL21kLmMKQEAgLTMyMiw2ICsz
MjIsMTEgQEAgc3RhdGljIHZvaWQgbWRfbWFrZV9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3F1
ZXVlICpxLCBzdHJ1Y3QgYmlvICpiaW8pCiAJCX0KIAkJZmluaXNoX3dhaXQoJm1kZGV2LT5z
Yl93YWl0LCAmX193YWl0KTsKIAl9CisJaWYgKG1kZGV2LT5ybyA9PSAxICYmIHVubGlrZWx5
KHJ3ID09IFdSSVRFKSkgeworCQlyY3VfcmVhZF91bmxvY2soKTsKKwkJYmlvX2VuZGlvKGJp
bywgLUVST0ZTKTsKKwkJcmV0dXJuOworCX0KIAlhdG9taWNfaW5jKCZtZGRldi0+YWN0aXZl
X2lvKTsKIAlyY3VfcmVhZF91bmxvY2soKTsKIAotLSAKMS43LjEKCg==
--------------060305090204040101040307--
