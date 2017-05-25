From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
Date: Thu, 25 May 2017 16:29:21 +0300
Message-ID: <1495718961.6967.117.camel@linux.intel.com>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-11-hch@lst.de>
 <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
 <1495545099.6967.81.camel@linux.intel.com> <20170525130027.GA30194@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170525130027.GA30194-jcswGhMUV9g@public.gmane.org>
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

T24gVGh1LCAyMDE3LTA1LTI1IGF0IDE1OjAwICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBUdWUsIE1heSAyMywgMjAxNyBhdCAwNDoxMTozOVBNICswMzAwLCBBbmR5IFNoZXZj
aGVua28gd3JvdGU6Cj4gPiBTaW5jZSB3ZSBpbnRyb2R1Y2VkIGEgdW5pb24gaXQncyBwb3NzaWJs
ZSB0aGF0IHdlIG1pZ2h0IGFjY2VzcyB0aGUKPiA+IG1lbWJlciB3aGljaCB3YXNuJ3QgbGFzdCBt
b2RpZmllZCBvbmUuIFNvLCBteSBjb21tZW50IGlzIHRvIGdpdmUgYW4KPiA+IGF0dGVudGlvbiBv
biBzdWNoIHBvc3NpYmlsaXR5IGFuZCBhdm9pZCBpZiB0aGVyZSBpcyBhbiBhbGlhc2luZwo+ID4g
aGFwcGVuZWQuCj4gCj4gV2UgZG8gZm9yIEFGUyAoYW5kIFhGUyBmb3IgZnMgZnNpZCkuwqDCoE15
IHByZWZlcmVuY2Ugd291bGQgYmUgdG8KPiBub3QgaGF2ZSB0aGUgdjEgc3RydWN0IGRlZmludGlv
biBidXQgaW5zdGVhZCBwcm92aWRlIGEgZmV3Cj4gaGVscGVycyBpbiB1dWlkLmggdGhhdCB1c2Ug
Z2V0X3VuYWxpZ25lZF9iZSogaWYgbmVlZGVkOgo+IAo+IAl1dWlkX3YxX3RpbWVfbG93KCkKPiAJ
dXVpZF92MV90aW1lX21pZCgpCj4gCXV1aWRfdjFfdGltZV90aW1lX2hpX2FuZF92ZXJzaW9uKCku
Lgo+IAo+IEZyb20gaGlzIHByZXZpb3VzbHkgcmVwbHkgaXQgc2VlbXMgbGlrZSBEYXZlIGRvZXNu
J3QgbGlrZSB0aGF0IGlkZWEKPiB0b28gbXVjaCwgaW4gd2hpY2ggY2FzZSBJIHN1c3BlY3QgbW92
aW5nIHN0cnVjdCB1dWlkX3YxIGJhY2sgaW50bwo+IGFmcyBhbmQgbGl2aW5nIHdpdGggY2FzdCBp
biBpdCBpcyB0aGUgd2F5IHRvIGdvLgoKUGVyc29uYWxseSBJIGRvbid0IGxpa2UgdGhhdCB1bmlv
biBzdHVmZiwgc28sIGRlZmluaXRlbHkgbXkgdm90ZSB0byBnZXQKcmlkIG9mIEFGUyBzdHVmZiBp
biBnZW5lcmljIGhlbHBlcnMuCgpPVE9IIGlmIHRoZXJlIHdpbGwgYmUgbW9yZSB1c2VycyBvZiBz
dWNoIEFQSSB0aGVuIHNvbWV0aGluZyBsaWtlIHlvdQpwcm9wb3NlZCB3b3VsZCBiZSBzdWZmaWNp
ZW50IHdpdGhvdXQgaW50cm9kdWNpbmcgYSB1bmlvbi4KCi0tIApBbmR5IFNoZXZjaGVua28gPGFu
ZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4KSW50ZWwgRmlubGFuZCBPeQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
