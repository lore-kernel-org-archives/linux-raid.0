From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH v4] md: protect against crash upon fsync on ro array
Date: Tue, 29 Jan 2013 12:19:22 +0100
Message-ID: <5107B03A.9030109@profitbricks.com>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>  <5102A01B.7000407@profitbricks.com>  <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk>  <20130127163942.GA28572@infradead.org> <510653A3.9090403@profitbricks.com>  <51067164.4050301@profitbricks.com> <1359438326.3367.41.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070506000000050005030909"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1359438326.3367.41.camel@deadeye.wl.decadent.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070506000000050005030909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29.01.2013 06:45, Ben Hutchings wrote:
> I'm slightly uneasy about returning 0 for all writes to a read-only
> deivce, because if someone ever fails to check the read-only flag
> elsewhere this could turn into silent data loss.  Does this work:
> 
> 		BUG_ON(bio_segments(bio));
> 
> Or should it be:
> 
> 		bio_endio(bio, bio_segments(bio) == 0 ? 0 : -EROFS);
> 
> to make the error survivable?

Good point. But it's better to use "bio_sectors" as bi_size is the
important information. I've seen that DRBD detects empty flushes the
same way.

For testing I've disabled the "set_disk_ro" in "md_set_readonly". Then,
I did direct IO writes on the read-only array and it worked - I've
received "Input/output error" in the user space.

I've attached version 4 of the patch.

Any further objection?

--------------070506000000050005030909
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"

RnJvbSBhZGZhYzRkZjk5ZWRjMWE4M2RjZWQ5YzczMjQ2NDYzNGQzMzgxYTlmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTZWJhc3RpYW4gUmllbWVyIDxzZWJhc3RpYW4ucmll
bWVyQHByb2ZpdGJyaWNrcy5jb20+CkRhdGU6IEZyaSwgMjUgSmFuIDIwMTMgMTI6NDY6NTkg
KzAxMDAKU3ViamVjdDogW1BBVENIIHY0XSBtZDogcHJvdGVjdCBhZ2FpbnN0IGNyYXNoIHVw
b24gZnN5bmMgb24gcm8gYXJyYXkKCklmIGFuIGZzeW5jIG9jY3VycnMgb24gYSByZWFkLW9u
bHkgYXJyYXksIHdlIG5lZWQgdG8gc2VuZCBhCmNvbXBsZXRpb24gZm9yIHRoZSBJTyBhbmQg
bWF5IG5vdCBpbmNyZW1lbnQgdGhlIGFjdGl2ZSBJTyBjb3VudC4KT3RoZXJ3aXNlLCB3ZSBo
aXQgYSBidWcgdHJhY2UgYW5kIGNhbid0IHN0b3AgdGhlIE1EIGFycmF5IGFueW1vcmUuCgpC
eSBhZHZpY2Ugb2YgQ2hyaXN0b3BoIEhlbGx3aWcgd2UgcmV0dXJuIHN1Y2Nlc3MgdXBvbiBh
IGZsdXNoCnJlcXVlc3QgYnV0IHdlIHJldHVybiAtRVJPRlMgZm9yIG90aGVyIHdyaXRlcy4K
V2UgZGV0ZWN0IGZsdXNoIHJlcXVlc3RzIGJ5IGNoZWNraW5nIGlmIHRoZSBiaW8gaGFzIHpl
cm8gc2VjdG9ycy4KCkNjOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+
CkNjOiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPgpDYzogTmVpbEJyb3du
IDxuZWlsYkBzdXNlLmRlPgpTaWduZWQtb2ZmLWJ5OiBTZWJhc3RpYW4gUmllbWVyIDxzZWJh
c3RpYW4ucmllbWVyQHByb2ZpdGJyaWNrcy5jb20+ClJlcG9ydGVkLWJ5OiBCZW4gSHV0Y2hp
bmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPgotLS0KIGRyaXZlcnMvbWQvbWQuYyB8ICAgIDQg
KysrKwogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jCmluZGV4
IDNkYjNkMWIuLjFlNjM0YTYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvbWQuYworKysgYi9k
cml2ZXJzL21kL21kLmMKQEAgLTMwNyw2ICszMDcsMTAgQEAgc3RhdGljIHZvaWQgbWRfbWFr
ZV9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgYmlvICpiaW8pCiAJ
CWJpb19pb19lcnJvcihiaW8pOwogCQlyZXR1cm47CiAJfQorCWlmIChtZGRldi0+cm8gPT0g
MSAmJiB1bmxpa2VseShydyA9PSBXUklURSkpIHsKKwkJYmlvX2VuZGlvKGJpbywgYmlvX3Nl
Y3RvcnMoYmlvKSA9PSAwID8gMCA6IC1FUk9GUyk7CisJCXJldHVybjsKKwl9CiAJc21wX3Jt
YigpOyAvKiBFbnN1cmUgaW1wbGljYXRpb25zIG9mICAnYWN0aXZlJyBhcmUgdmlzaWJsZSAq
LwogCXJjdV9yZWFkX2xvY2soKTsKIAlpZiAobWRkZXYtPnN1c3BlbmRlZCkgewotLSAKMS43
LjEKCg==
--------------070506000000050005030909--
