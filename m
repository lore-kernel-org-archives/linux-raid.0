From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: use seconds granularity for error logging
Date: Tue, 19 Jul 2016 10:59:51 -0700
Message-ID: <20160719175951.GA46288@kernel.org>
References: <20160617153347.380722-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <20160617153347.380722-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, y2038@lists.linaro.org, NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, Guoqing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

T24gRnJpLCBKdW4gMTcsIDIwMTYgYXQgMDU6MzM6MTBQTSArMDIwMCwgQXJuZCBCZXJnbWFubiB3
cm90ZToKPiBUaGUgbWQgY29kZSBzdG9yZXMgdGhlIGV4YWN0IHRpbWUgb2YgdGhlIGxhc3QgZXJy
b3IgaW4gdGhlCj4gbGFzdF9yZWFkX2Vycm9yIHZhcmlhYmxlIHVzaW5nIGEgdGltZXNwZWMgc3Ry
dWN0dXJlLiBJdCBvbmx5Cj4gZXZlciB1c2VzIHRoZSBzZWNvbmRzIHBvcnRpb24gb2YgdGhhdCB0
aG91Z2gsIHNvIHdlIGNhbgo+IHVzZSBhIHNjYWxhciBmb3IgaXQuCj4gCj4gVGhlcmUgd29uJ3Qg
YmUgYW4gb3ZlcmZsb3cgaW4gMjAzOCBoZXJlLCBiZWNhdXNlIGl0IGFscmVhZHkKPiB1c2VkIG1v
bm90b25pYyB0aW1lIGFuZCAzMi1iaXQgaXMgZW5vdWdoIGZvciB0aGF0LCBidXQgSSd2ZQo+IGRl
Y2lkZWQgdG8gdXNlIHRpbWU2NF90IGZvciBjb25zaXN0ZW5jeSBpbiB0aGUgY29udmVyc2lvbi4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPgoKQXBwbGll
ZCwgdGhhbmtzIQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3Rz
LmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
