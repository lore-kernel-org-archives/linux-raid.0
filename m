From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: segfault in mdadm v2.6.4
Date: Fri, 4 Apr 2008 09:01:08 -0700
Message-ID: <e9c3a7c20804040901p4583bebev85c66895aa448472@mail.gmail.com>
References: <2C1F2D1D-8799-4E11-8CDB-1827769496F3@cloud9.net>
	 <bb145bd20804040305o485cbf02u2abff0311fd35079@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_7314_30918300.1207324868692"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20804040305o485cbf02u2abff0311fd35079@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: brett@cloud9.net
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_7314_30918300.1207324868692
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Apr 4, 2008 at 3:05 AM, Christian Pernegger <pernegger@gmail.com> wrote:
> >  Apr  4 00:36:46 frank kernel: mdadm[3954]: segfault at 0 rip 412d2c rsp
>  > 7fffcdd18fa0 error 4
>
>  The segfault after assemble is more or less "normal" with the Debian
>  version right now. Of course I haven't been able to reproduce it with
>  any consistency since I reported the bug :(
>

There is a known issue with arrays in the "read-auto" state and "mdadm
--monitor".  The attached patch addresses this.

What is more concerning is the usb-storage hangs.  Do you have logs
from when it hung?

--
Dan

------=_Part_7314_30918300.1207324868692
Content-Type: text/x-patch; name=mdstat-fix-level-parsing.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_femy0oor0
Content-Disposition: attachment; filename=mdstat-fix-level-parsing.patch

bWRhZG06IGZpeCBzZWdmYXVsdCwgL3Byb2MvbWRzdGF0IHBhcnNpbmcgb2YgJ2xldmVsJwoKRnJv
bTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CgpJZiB0aGUgYXJyYXkg
aXMgaW4gJ3JlYWQtYXV0bycgbW9kZSAvcHJvYy9tZHN0YXQgd2lsbCBoYXZlIGEgc3RyaW5nCmxp
a2U6CgoJImFjdGl2ZShhdXRvLXJlYWQtb25seSkiCgpUaGUgcGFyc2luZyBjb2RlIGRvZXMgbm90
IHJlY29nbml6ZSB0aGlzIGFzICJhY3RpdmUiIHNvIGl0IGRvZXMgbm90IHNldAotPmxldmVsLiAg
VGhpcyBsZWFkcyB0byBhIHNlZ2ZhdWx0IGluIC0tbW9uaXRvciBtb2RlIChNb25pdG9yLmM6NDA1
KS4KClNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29t
PgotLS0KCiBtZHN0YXQuYyB8ICAgIDMgKystCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbnMoLSkKCgpkaWZmIC0tZ2l0IGEvbWRzdGF0LmMgYi9tZHN0YXQuYwpp
bmRleCAzMzVlMWU1Li4xZGNkNzA5IDEwMDY0NAotLS0gYS9tZHN0YXQuYworKysgYi9tZHN0YXQu
YwpAQCAtMTY1LDcgKzE2NSw4IEBAIHN0cnVjdCBtZHN0YXRfZW50ICptZHN0YXRfcmVhZChpbnQg
aG9sZCwgaW50IHN0YXJ0KQogCQlmb3IgKHc9ZGxfbmV4dChsaW5lKTsgdyE9IGxpbmUgOyB3PWRs
X25leHQodykpIHsKIAkJCWludCBsID0gc3RybGVuKHcpOwogCQkJY2hhciAqZXE7Ci0JCQlpZiAo
c3RyY21wKHcsICJhY3RpdmUiKT09MCkKKwkJCWlmIChzdHJuY21wKHcsICJhY3RpdmUiLCBzdHJs
ZW4oImFjdGl2ZSIpKT09MCkKKwkJCS8qIHN0cm5jbXAgdG8gY2F0Y2ggdGhlICJhY3RpdmUoYXV0
by1yZWFkLW9ubHkpIiBjYXNlICovCiAJCQkJZW50LT5hY3RpdmUgPSAxOwogCQkJZWxzZSBpZiAo
c3RyY21wKHcsICJpbmFjdGl2ZSIpPT0wKQogCQkJCWVudC0+YWN0aXZlID0gMDsK
------=_Part_7314_30918300.1207324868692--
