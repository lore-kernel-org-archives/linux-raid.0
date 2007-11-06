From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Mon, 5 Nov 2007 17:19:49 -0700
Message-ID: <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
	 <18222.16003.92062.970530@notabene.brown>
	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
	 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
	 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_29572_25767903.1194308389630"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_29572_25767903.1194308389630
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 11/5/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
[..]
> > Are you seeing the same "md thread takes 100% of the CPU" that Jo=EBl i=
s
> > reporting?
> >
>
> Yes, in another e-mail I posted the top output with md3_raid5 at 100%.
>

This seems too similar to Jo=EBl's situation for them not to be
correlated, and it shows that iscsi is not a necessary component of
the failure.

The attached patch allows the debug statements in MD to be enabled via
sysfs.  Jo=EBl, since it is easier for you to reproduce can you capture
the kernel log output after the raid thread goes into the spin?  It
will help if you have CONFIG_PRINTK_TIME=3Dy set in your kernel
configuration.

After the failure run:

echo 1 > /sys/block/md_d0/md/debug_print_enable; sleep 5; echo 0 >
/sys/block/md_d0/md/debug_print_enable

...to enable the print messages for a few seconds.  Please send the
output in a private message if it proves too big for the mailing list.

------=_Part_29572_25767903.1194308389630
Content-Type: application/octet-stream; name=raid5-debug-print-enable.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8no5bvd
Content-Disposition: attachment; filename=raid5-debug-print-enable.patch

cmFpZDU6IGRlYnVnIHByaW50IGVuYWJsZQoKRnJvbTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+CgoKLS0tCgogZHJpdmVycy9tZC9yYWlkNS5jIHwgICAzNiArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgMzYgaW5zZXJ0
aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQ1LmMg
Yi9kcml2ZXJzL21kL3JhaWQ1LmMKaW5kZXggMzgwOGY1Mi4uNDk2YjlhMyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9tZC9yYWlkNS5jCisrKyBiL2RyaXZlcnMvbWQvcmFpZDUuYwpAQCAtNTQsNiArNTQs
MTAgQEAKICNpbmNsdWRlIDxsaW51eC9yYWlkL2JpdG1hcC5oPgogI2luY2x1ZGUgPGxpbnV4L2Fz
eW5jX3R4Lmg+CiAKK3N0YXRpYyBpbnQgZGVidWdfcHJpbnRfZW5hYmxlOworI3VuZGVmIHByX2Rl
YnVnCisjZGVmaW5lIHByX2RlYnVnKHguLi4pICgodm9pZCkoZGVidWdfcHJpbnRfZW5hYmxlICYm
IHByaW50ayh4KSkpIAorCiAvKgogICogU3RyaXBlIGNhY2hlCiAgKi8KQEAgLTQwMjMsNiArNDAy
NywzNyBAQCByYWlkNV9zdHJpcGVjYWNoZV9zaXplID0gX19BVFRSKHN0cmlwZV9jYWNoZV9zaXpl
LCBTX0lSVUdPIHwgU19JV1VTUiwKIAkJCQlyYWlkNV9zdG9yZV9zdHJpcGVfY2FjaGVfc2l6ZSk7
CiAKIHN0YXRpYyBzc2l6ZV90CityYWlkNV9zaG93X2RlYnVnX3ByaW50X2VuYWJsZShtZGRldl90
ICptZGRldiwgY2hhciAqcGFnZSkKK3sKKwlyZXR1cm4gc3ByaW50ZihwYWdlLCAiJWRcbiIsIGRl
YnVnX3ByaW50X2VuYWJsZSk7Cit9CisKK3N0YXRpYyBzc2l6ZV90CityYWlkNV9zdG9yZV9kZWJ1
Z19wcmludF9lbmFibGUobWRkZXZfdCAqbWRkZXYsIGNvbnN0IGNoYXIgKnBhZ2UsIHNpemVfdCBs
ZW4pCit7CisJcmFpZDVfY29uZl90ICpjb25mID0gbWRkZXZfdG9fY29uZihtZGRldik7CisJY2hh
ciAqZW5kOworCWludCBuZXc7CisJaWYgKGxlbiA+PSBQQUdFX1NJWkUpCisJCXJldHVybiAtRUlO
VkFMOworCisJbmV3ID0gc2ltcGxlX3N0cnRvdWwocGFnZSwgJmVuZCwgMTApOworCWlmICghKnBh
Z2UgfHwgKCplbmQgJiYgKmVuZCAhPSAnXG4nKSApCisJCXJldHVybiAtRUlOVkFMOworCWlmIChu
ZXcgPCAwIHx8IG5ldyA+IDEpCisJCXJldHVybiAtRUlOVkFMOworCisJZGVidWdfcHJpbnRfZW5h
YmxlID0gbmV3OworCQorCXJldHVybiBsZW47Cit9CisKK3N0YXRpYyBzdHJ1Y3QgbWRfc3lzZnNf
ZW50cnkKK3JhaWQ1X2RlYnVnX3ByaW50ID0gX19BVFRSKGRlYnVnX3ByaW50X2VuYWJsZSwgU19J
UlVHTyB8IFNfSVdVU1IsCisJCQkJcmFpZDVfc2hvd19kZWJ1Z19wcmludF9lbmFibGUsCisJCQkJ
cmFpZDVfc3RvcmVfZGVidWdfcHJpbnRfZW5hYmxlKTsKKworc3RhdGljIHNzaXplX3QKIHN0cmlw
ZV9jYWNoZV9hY3RpdmVfc2hvdyhtZGRldl90ICptZGRldiwgY2hhciAqcGFnZSkKIHsKIAlyYWlk
NV9jb25mX3QgKmNvbmYgPSBtZGRldl90b19jb25mKG1kZGV2KTsKQEAgLTQwMzgsNiArNDA3Myw3
IEBAIHJhaWQ1X3N0cmlwZWNhY2hlX2FjdGl2ZSA9IF9fQVRUUl9STyhzdHJpcGVfY2FjaGVfYWN0
aXZlKTsKIHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpyYWlkNV9hdHRyc1tdID0gIHsKIAkmcmFp
ZDVfc3RyaXBlY2FjaGVfc2l6ZS5hdHRyLAogCSZyYWlkNV9zdHJpcGVjYWNoZV9hY3RpdmUuYXR0
ciwKKwkmcmFpZDVfZGVidWdfcHJpbnQuYXR0ciwKIAlOVUxMLAogfTsKIHN0YXRpYyBzdHJ1Y3Qg
YXR0cmlidXRlX2dyb3VwIHJhaWQ1X2F0dHJzX2dyb3VwID0gewo=
------=_Part_29572_25767903.1194308389630--
