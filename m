From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH v3] md: protect against crash upon fsync on ro array
Date: Mon, 28 Jan 2013 13:39:00 +0100
Message-ID: <51067164.4050301@profitbricks.com>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk> <5102A01B.7000407@profitbricks.com> <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk> <20130127163942.GA28572@infradead.org> <510653A3.9090403@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020701060201050002000509"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510653A3.9090403@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020701060201050002000509
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28.01.2013 11:32, Sebastian Riemer wrote:
> O.K., then I hope Neil applies the attached patch. I've changed the
> return value to success.
> 
> This is also something for linux-stable and should apply to many kernel
> versions without an issue.
> 

I've tried to race with continuous fsyncs against continuous "mdadm -o
/dev/md0; mdadm -w /dev/md0;" in parallel but couldn't break it.
Therefore, no additional locking is required and this part can be put
directly before the RCU locking stuff and the suspended handling.

I've attached version 3 of the patch.

--------------020701060201050002000509
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"

RnJvbSBmZTAzNTczNDQ4NzdjOWI5Y2M2MjNmZDU4MmE0ZTA2NzBlNDQ4MzE3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTZWJhc3RpYW4gUmllbWVyIDxzZWJhc3RpYW4ucmll
bWVyQHByb2ZpdGJyaWNrcy5jb20+CkRhdGU6IEZyaSwgMjUgSmFuIDIwMTMgMTI6NDY6NTkg
KzAxMDAKU3ViamVjdDogW1BBVENIIHYzXSBtZDogcHJvdGVjdCBhZ2FpbnN0IGNyYXNoIHVw
b24gZnN5bmMgb24gcm8gYXJyYXkKCklmIGFuIGZzeW5jIG9jY3VycnMgb24gYSByZWFkLW9u
bHkgYXJyYXksIHdlIG5lZWQgdG8gc2VuZCBhCmNvbXBsZXRpb24gZm9yIHRoZSBJTyBhbmQg
bWF5IG5vdCBpbmNyZW1lbnQgdGhlIGFjdGl2ZSBJTyBjb3VudC4KT3RoZXJ3aXNlLCB3ZSBo
aXQgYSBidWcgdHJhY2UgYW5kIGNhbid0IHN0b3AgdGhlIE1EIGFycmF5IGFueW1vcmUuCgpC
eSBhZHZpY2Ugb2YgQ2hyaXN0b3BoIEhlbGx3aWcgd2Ugc2lsZW50bHkgcmV0dXJuIHN1Y2Nl
c3MuCgpDYzogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBpbmZyYWRlYWQub3JnPgpDYzogQmVu
IEh1dGNoaW5ncyA8YmVuQGRlY2FkZW50Lm9yZy51az4KQ2M6IE5laWxCcm93biA8bmVpbGJA
c3VzZS5kZT4KU2lnbmVkLW9mZi1ieTogU2ViYXN0aWFuIFJpZW1lciA8c2ViYXN0aWFuLnJp
ZW1lckBwcm9maXRicmlja3MuY29tPgpSZXBvcnRlZC1ieTogQmVuIEh1dGNoaW5ncyA8YmVu
QGRlY2FkZW50Lm9yZy51az4KCi0tLQogZHJpdmVycy9tZC9tZC5jIHwgICAgNSArKysrKwog
MSBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jCmluZGV4IDNkYjNk
MWIuLjZiYTIwZjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvbWQuYworKysgYi9kcml2ZXJz
L21kL21kLmMKQEAgLTMwNyw2ICszMDcsMTAgQEAgc3RhdGljIHZvaWQgbWRfbWFrZV9yZXF1
ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgYmlvICpiaW8pCiAJCWJpb19p
b19lcnJvcihiaW8pOwogCQlyZXR1cm47CiAJfQorCWlmIChtZGRldi0+cm8gPT0gMSAmJiB1
bmxpa2VseShydyA9PSBXUklURSkpIHsKKwkJYmlvX2VuZGlvKGJpbywgMCk7CisJCXJldHVy
bjsKKwl9CiAJc21wX3JtYigpOyAvKiBFbnN1cmUgaW1wbGljYXRpb25zIG9mICAnYWN0aXZl
JyBhcmUgdmlzaWJsZSAqLwogCXJjdV9yZWFkX2xvY2soKTsKIAlpZiAobWRkZXYtPnN1c3Bl
bmRlZCkgewo=
--------------020701060201050002000509--
