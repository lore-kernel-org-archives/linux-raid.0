From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Date: Thu, 11 May 2017 14:38:07 +0300
Message-ID: <1494502687.6967.2.camel@linux.intel.com>
References: <20170510180214.16852-4-hch@lst.de>
 <20170510180214.16852-1-hch@lst.de>
 <2612.1494440436@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <2612.1494440436-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDE5OjIwICswMTAwLCBEYXZpZCBIb3dlbGxzIHdyb3RlOgo+
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3cm90ZToKPiAKPiA+IC0jZGVmaW5lIE5V
TExfVVVJRF9MRQkJCQkJCQo+ID4gCVwKPiA+IC0JVVVJRF9MRSgweDAwMDAwMDAwLCAweDAwMDAs
IDB4MDAwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwKPiA+IAlcCj4gPiAtCQkweDAwLCAweDAw
LCAweDAwLCAweDAwKQo+ID4gKyNkZWZpbmUgTlVMTF9HVUlECQkJCQkJCQo+ID4gXAo+ID4gKwlH
VUlEKDB4MDAwMDAwMDAsIDB4MDAwMCwgMHgwMDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLAkK
PiA+IFwKPiA+ICsJwqDCoMKgwqDCoDB4MDAsIDB4MDAsIDB4MDAsIDB4MDApCj4gPiDCoAo+ID4g
LSNkZWZpbmUgTlVMTF9VVUlEX0JFCQkJCQkJCj4gPiAJXAo+ID4gLQlVVUlEX0JFKDB4MDAwMDAw
MDAsIDB4MDAwMCwgMHgwMDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLAo+ID4gCVwKPiA+IC0J
CTB4MDAsIDB4MDAsIDB4MDAsIDB4MDApCj4gPiArI2RlZmluZSBOVUxMX1VVSUQJCQkJCQkJCj4g
PiBcCj4gPiArCVVVSUQoMHgwMDAwMDAwMCwgMHgwMDAwLCAweDAwMDAsIDB4MDAsIDB4MDAsIDB4
MDAsIDB4MDAsCQo+ID4gXAo+ID4gKwnCoMKgwqDCoMKgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCkK
PiAKPiBUaGVzZSBhcmUgVUFQSSBhbmQgb3VnaHQgbm90IHRvIGJlIHJlbmFtZWQuCj4gCgpHb29k
IHBvaW50LiBJIHNlZSBpbiB0aGUgYnJhbmNoIGl0J3MgYWxyZWFkeSBmaXhlZC4KCgotLSAKQW5k
eSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+CkludGVsIEZp
bmxhbmQgT3kKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
