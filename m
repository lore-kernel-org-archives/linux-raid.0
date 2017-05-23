From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
Date: Tue, 23 May 2017 16:11:39 +0300
Message-ID: <1495545099.6967.81.camel@linux.intel.com>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-11-hch@lst.de>
 <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170523084956.GB20121-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

T24gVHVlLCAyMDE3LTA1LTIzIGF0IDEwOjQ5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBNb24sIE1heSAyMiwgMjAxNyBhdCAwOTo0OToxN1BNICswMzAwLCBBbmR5IFNoZXZj
aGVua28gd3JvdGU6Cj4gPiA+IMKgCXN0cnVjdCBhZnNfY2FsbCAqY2FsbCA9IGNvbnRhaW5lcl9v
Zih3b3JrLCBzdHJ1Y3QKPiA+ID4gYWZzX2NhbGwsCj4gPiA+IHdvcmspOwo+ID4gPiAtCXN0cnVj
dCB1dWlkX3YxICpyID0gY2FsbC0+cmVxdWVzdDsKPiA+ID4gKwl1dWlkX3QgKnIgPSBjYWxsLT5y
ZXF1ZXN0Owo+ID4gPiDCoAo+ID4gPiDCoAlzdHJ1Y3Qgewo+ID4gPiDCoAkJX19iZTMyCW1hdGNo
Owo+ID4gPiAKPiA+IAo+ID4gSnVzdCB0byBkb3VibGUgY2hlY2sgdGhhdCB0aGlzIGRvZXNuJ3Qg
Y3JlYXRlIGEgdW5pb24gYWxpYXNpbmcuCj4gCj4gV2hhdCBkbyB5b3UgbWVhbiB3aXRoIHRoYXQ/
CgpTaW5jZSB3ZSBpbnRyb2R1Y2VkIGEgdW5pb24gaXQncyBwb3NzaWJsZSB0aGF0IHdlIG1pZ2h0
IGFjY2VzcyB0aGUKbWVtYmVyIHdoaWNoIHdhc24ndCBsYXN0IG1vZGlmaWVkIG9uZS4gU28sIG15
IGNvbW1lbnQgaXMgdG8gZ2l2ZSBhbgphdHRlbnRpb24gb24gc3VjaCBwb3NzaWJpbGl0eSBhbmQg
YXZvaWQgaWYgdGhlcmUgaXMgYW4gYWxpYXNpbmcKaGFwcGVuZWQuCgotLSAKQW5keSBTaGV2Y2hl
bmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+CkludGVsIEZpbmxhbmQgT3kK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
