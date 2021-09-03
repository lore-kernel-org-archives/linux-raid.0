Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA6AC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 07:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7706109E
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 07:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhICHtm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Sep 2021 03:49:42 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55674 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhICHtm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Sep 2021 03:49:42 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 10097225BF;
        Fri,  3 Sep 2021 07:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630655322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ClhvA3lBXXg6Owi+jM3N3b20PrwrzadIQrp/h39Gp4s=;
        b=iYVkoHK3Kx7qpud3feKD2nJtY6+SB6wRvoptLPt9JxSM9FKsxc4Q6snEZLBNHnUlc2a9qE
        6YTZlULjVXrx9tLbVWZjthsZXBmSGUNsywlxX0rnw/gO4TiflYsERSW1c3s4k3Qgp58KcJ
        9QorPcVaGHD5QD1otfW9j55WxbjvKTo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630655322;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ClhvA3lBXXg6Owi+jM3N3b20PrwrzadIQrp/h39Gp4s=;
        b=EUt9S0rSM+/0KYm7d46eFv5cxDTbVKXi6PoKcK3MHa4jEV0WwjE4IeG1xPDrGB8eyuyOsm
        okFhL3sp1iI/LvCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0240F13B1D;
        Fri,  3 Sep 2021 07:48:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Qhm7LFfTMWE2SwAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 03 Sep 2021 07:48:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Guoqing Jiang" <guoqing.jiang@linux.dev>
Cc:     "Christoph Hellwig" <hch@lst.de>, "Song Liu" <song@kernel.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>, linux-raid@vger.kernel.org,
        syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/5] md: fix a lock order reversal in md_alloc
In-reply-to: <2861229a-c9ff-3811-85eb-4362e46d2fe2@linux.dev>
References: <20210901113833.1334886-1-hch@lst.de>,
 <20210901113833.1334886-2-hch@lst.de>,
 <2861229a-c9ff-3811-85eb-4362e46d2fe2@linux.dev>
Date:   Fri, 03 Sep 2021 17:48:36 +1000
Message-id: <163065531634.24419.11777193377476805182@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gRnJpLCAwMyBTZXAgMjAyMSwgR3VvcWluZyBKaWFuZyB3cm90ZToKPiAKPiBPbiA5LzEvMjEg
NzozOCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gPiBDb21taXQgYjAxNDA4OTFhOGNl
YTMgKCJtZDogRml4IHJhY2Ugd2hlbiBjcmVhdGluZyBhIG5ldyBtZCBkZXZpY2UuIikKPiA+IG5v
dCBvbmx5IG1vdmVkIGFzc2lnbmluZyBtZGRldi0+Z2VuZGlzayBiZWZvcmUgY2FsbGluZyBhZGRf
ZGlzaywgd2hpY2gKPiA+IGZpeGVzIHRoZSByYWNlcyBkZXNjcmliZWQgaW4gdGhlIGNvbW1pdCBs
b2csIGJ1dCBhbHNvIGFkZGVkIGEKPiA+IG1kZGV2LT5vcGVuX211dGV4IGNyaXRpY2FsIHNlY3Rp
b24gb3ZlciBhZGRfZGlzayBhbmQgY3JlYXRpb24gb2YgdGhlCj4gPiBtZCBrb2JqLiAgQWRkaW5n
IGEga29iamVjdCBhZnRlciBhZGRfZGlzayBpcyByYWN5IHZzIGRlbGV0aW5nIHRoZSBnZW5kaXNr
Cj4gPiByaWdodCBhZnRlciBhZGRpbmcgaXQsIGJ1dCBtZCBhbHJlYWR5IHByZXZlbnRzIGFnYWlu
c3QgdGhhdCBieSBob2xkaW5nCj4gPiBhIG1kZGV2LT5hY3RpdmUgcmVmZXJlbmNlLgo+IAo+IEFz
c3VtaW5nIHlvdSBtZWFuIG1kX29wZW4gY2FsbHMgbWRkZXZfZmluZCAtPiBtZGRldl9nZXQKPiAg
wqAtPiBhdG9taWNfaW5jKCZtZGRldi0+YWN0aXZlKSwgYnV0IHRoZSBwYXRoIGhhZCBhbHJlYWR5
IGV4aXN0ZWQKPiBiZWZvcmUgYjAxNDA4OTFhOGMswqAgYW5kIG1kX2FsbG9jIGFsc28gY2FsbGVk
IG1kZGV2X2ZpbmQgYXQKPiB0aGF0IHRpbWUsIG5vdCBzdXJlIGhvdyBpdCBwcmV2ZW50cyB0aGUg
cmFjZSB0aG91Z2ggSSBwcm9iYWJseSBtaXNzZWQKPiBzb21ldGhpbmcuIENjIE5laWwuCgpJdCBp
cyBhIGxvbmcgdGltZSBzaW5jZSBJJ3ZlIGxvb2tlZCBtdWNoIGF0IHRoaXMgY29kZSwgYnV0IEkg
KnRoaW5rKgp0aGF0IHRoZSByZWFzb24gY2FsbGluZyBrb2JqZWN0X2FkZCgpIGFmdGVyIGFkZF9k
aXNrKCkgaXMgc2FmZSBpcwpiZWNhdXNlIHRoYXQgZ2VuZGlzayBpcyAqb25seSogZGVsZXRlZCBi
eSBtZF9mcmVlKCkgd2hpY2ggaGFwcGVucyB3aGVuCnRoYXQga29iamVjdCBpcyAncHV0JyAtIGlu
IG1kZGV2X2RlbGF5ZWRfZGVsZXRlKCkuICBUaGF0IG9ubHkgZ2V0cwpjYWxsZWQgd2hlbiBtZGRl
di0+YWN0aXZlIGlzIHplcm8gKGZyb20gbWRkZXZfcHV0KCkuClNvIGFzIENocmlzdG9waCBzYXlz
LCB0aGUgZmFjdCB0aGF0IG1kX2FsbG9jKCkgaG9sZCBhIGNvdW50IG9uCm1kZGV2LT5hY3RpdmUg
KHVudGlsIGl0IGNhbGxzIG1kZGVWX3B1dCgpIGF0IHRoZSB2ZXJ5IGVuZCkgbWFrZXMgdGhpcwpz
YWZlLgoKQXMgZm9yIHRoZSAtPm9wZW5fbXV0ZXggbG9ja2luZyAtIEkgaGF2ZSBhIHZhZ3VlIG1l
bW9yeSB0aGF0IGl0IHdhcyB0bwpwcm90ZWN0IHNvbWV0aGluZyB0aGF0IG1pZ2h0IGhhcHBlbiAq
YWZ0ZXIqIG1kX29wZW4oKSBmcm9tIHJ1bm5pbmcKYmVmb3JlIG1kX2FsbG9jKCkgaGFkIGNvbXBs
ZXRlZC4KYWRkX2Rpc2soKSBpdHNlbGYgYWRkcyBzdWZmaWNpZW50IGV4Y2x1c2lvbiB2aWEgZGlz
ay0+b3Blbl9tdXRleCwgc28gaXQKY291bGQgb25seSBiZSB0aGUga29iamVjdC9zeXNmcyBtYW5p
cHVsYXRpb25zLgoKQWxsIEkgY2FuIHRoaW5rIGlmIGlzIHRoYXQgYWRkX2Rpc2soKSB3b3VsZCBz
ZW5kIGFuIGV2ZW50IHRvIHVkZXYgYW5kIHVkZXYKbWlnaHQgZG8gc29tZXRoaW5nIGJlZm9yZSB0
aGUgJ21kJyBkaXJlY3RvcnkgaGFkIGJlZW4gY3JlYXRlZC4KQnV0IHRoZSB1ZGV2IHJ1bGVzIHNl
ZW0gc2FmZSBhZ2FpbnN0IHRoYXQuICBJbiBwYXJ0aWN1bGFyIHRoZXkgY2hlY2sgaWYKbWQvYXJy
YXlfc3RhdGUgZXhpc3RzIGJlZm9yZSBjaGVja2luZyBpZiBpdCBpcyBjbGVhciBvciBpbmFjdGl2
ZS4KCkkgZGlkIHN0cnVnZ2xlIHdpdGggc29tZSByYWNlcyBsaWtlIHRoYXQsIGJ1dCBpZiB0aGF0
IHdhcyB0aGUgcHJvYmxlbSwKSSdtIHN1cnByaXNlZCB0aGF0IEkgZGlkbid0IGV4cGxhaW4gaXQg
aW4gdGhlIGNvbW1pdCBtZXNzYWdlLgoKU28gaW4gc2hvcnQ6IEkgY2Fubm90IHNlZSB3aHkgSSBh
ZGRlZCB0aGF0IGxvY2tpbmcsIGFuZCBJIGNhbm5vdCBzZWUKdGhhdCByZW1vdmluZyBpdCB3b3Vs
ZCBicmVhayBhbnl0aGluZy4KICAKUmV2aWV3ZWQtYnk6IE5laWxCcm93biA8bmVpbGJAc3VzZS5k
ZT4KCk5laWxCcm93bgoKCj4gCj4gPiBPbiB0aGUgb3RoZXIgaGFuZCB0YWtpbmcgdGhpcyBsb2Nr
IGFkZGVkIGEgbG9jayBvcmRlciByZXZlcnNhbCB3aXRoIHdoYXQKPiA+IGlzIG5vdCBkaXNrLT5v
cGVuX211dGV4ICh1c2VkIHRvIGJlIGJkZXYtPmJkX211dGV4IHdoZW4gdGhlIGNvbW1pdCB3YXMK
PiA+IGFkZGVkKSBmb3IgcGFydGl0aW9uIGRldmljZXMsIHdoaWNoIG5lZWQgdGhhdCBsb2NrIGZv
ciB0aGUgaW50ZXJuYWwgb3Blbgo+ID4gZm9yIHRoZSBwYXJ0aXRpb24gc2NhbiwgYW5kIGEgcmVj
ZW50IGNvbW1pdCBhbHNvIHRha2VzIGl0IGZvcgo+ID4gbm9uLXBhcnRpdGlvbmVkIGRldmljZXMs
IGxlYWRpbmcgdG8gZnVydGhlciBsb2NrZGVwIHNwbGF0dGVyLgo+ID4KPiA+IEZpeGVzOiBiMDE0
MDg5MWE4Y2UgKCJtZDogRml4IHJhY2Ugd2hlbiBjcmVhdGluZyBhIG5ldyBtZCBkZXZpY2UuIikK
PiA+IEZpeGVzOiBkNjI2MzM4NzM1OTAgKCJibG9jazogc3VwcG9ydCBkZWxheWVkIGhvbGRlciBy
ZWdpc3RyYXRpb24iKQo+IAo+IElJVUMsIHRoZSBpc3N1ZSBhcHBlYXJlZCBhZnRlciBkNjI2MzM4
NzM1OSAod2hpY2ggd2FzIGZvciBkbSBpc3N1ZSksCj4gcGVyaGFwcyBzdGFibGUgbWFpbnRhaW5l
ciBzaG91bGQgbm90IGFwcGx5IHRoaXMgdG8gYW55IHN0YWJsZSBrZXJuZWwKPiBpZiBpdCBvbmx5
IGluY2x1ZGVzIGIwMTQwODkxYThjZS4KPiAKPiBUaGFua3MsCj4gR3VvcWluZwo+IAo+IAo=
