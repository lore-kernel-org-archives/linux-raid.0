Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADD8C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 22 Feb 2022 22:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiBVWuG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Feb 2022 17:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiBVWuF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Feb 2022 17:50:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0665132962
        for <linux-raid@vger.kernel.org>; Tue, 22 Feb 2022 14:49:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 52E8221129;
        Tue, 22 Feb 2022 22:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645570177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYBk5i6b7RLVUUdO6vuLXckYtC8AO2Khm1xyM86SK/k=;
        b=KFtkOcuIL5/GrJcOdNbDNw7iHS5YmzXoQVLR4d5KAFVS8o5k0eXU5htNeCHRVdTFNRvQ5M
        /SgpR3V3SfnFqyFr7SGwdWEaJn5742qxmw9es+eu5HEK8u2OAKHwlbrAJGOXOknR1s4EcC
        0Z/uiof5YRa0Ydv4Hm5Lw946NNBFbe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645570177;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYBk5i6b7RLVUUdO6vuLXckYtC8AO2Khm1xyM86SK/k=;
        b=GI6dWE0A7GW+WwGKQrQnYNlGEXOhH4Ylmis3UrV3c1+dHVm/zQHJWu6YA0bp5BQ4U5O539
        iQn21mORSwmv1wCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF3F413C33;
        Tue, 22 Feb 2022 22:49:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6Cc2H3xoFWIeWAAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 22 Feb 2022 22:49:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Martin Wilck" <mwilck@suse.com>
Cc:     "Peter Rajnoha" <prajnoha@redhat.com>,
        "Jes Sorensen" <jsorensen@fb.com>, "Coly Li" <colyli@suse.com>,
        lvm-devel@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, "Heming Zhao" <heming.zhao@suse.com>
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
In-reply-to: <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
References: <20220216205914.7575-1-mwilck@suse.com>,
 <164504936873.10228.7361167610237544463@noble.neil.brown.name>,
 <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>,
 <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>,
 <164548656531.8827.3365536065813085321@noble.neil.brown.name>,
 <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
Date:   Wed, 23 Feb 2022 09:49:27 +1100
Message-id: <164557016782.28944.17731814770525408828@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

T24gV2VkLCAyMyBGZWIgMjAyMiwgTWFydGluIFdpbGNrIHdyb3RlOgo+IE5laWwsCj4gCj4gT24g
VHVlLCAyMDIyLTAyLTIyIGF0IDEwOjM2ICsxMTAwLCBOZWlsQnJvd24gd3JvdGU6Cj4gPiAKPiA+
ID4gVGhlIGZsYWdzIHRoYXQgRE0gdXNlIGZvciB1ZGV2IHdlcmUgaW50cm9kdWNlZCBiZWZvcmUg
c3lzdGVtZAo+ID4gPiBwcm9qZWN0Cj4gPiA+IGV2ZW4gZXhpc3RlZC4gV2UgbmVlZGVkIHRvIGlu
dHJvZHVjZSB0aGUKPiA+ID4gRE1fVURFVl9ESVNBQkxFX09USEVSX1JVTEVTX0ZMQUcKPiA+ID4g
dG8gaGF2ZSBhIHBvc3NpYmlsaXR5IGZvciBhbGwgdGhlICJvdGhlciIgKG5vbi1kbSkgdWRldiBy
dWxlcyB0bwo+ID4gPiBjaGVjawo+ID4gPiBmb3IgaWYgdGhlcmUncyBhbm90aGVyIHN1YnN5c3Rl
bSBzdGFja2luZyBpdHMgb3duIGRldmljZXMgb24gdG9wIG9mCj4gPiA+IERNCj4gPiA+IG9uZXMu
Cj4gPiAKPiA+IElmIHRoaXMgaXMgYW4gZXN0YWJsaXNoZWQgQVBJIHRoYXQgRE0gdXNlcywgdGhl
biBwcmVzdW1hYmx5IGl0IGlzCj4gPiBkb2N1bWVudGVkIHNvbWV3aGVyZS7CoCBJZiBhIGxpbmsg
dG8gdGhhdCBkb2N1bWVudGF0aW9uIHdlcmUgcHJvdmlkZWQsCj4gPiBpdAo+ID4gd291bGQgbG9v
ayBhIGEgd2hvbGUgbG90IGxlc3MgbGlrZSBhIGhhY2suCj4gCj4gUGV0ZXIgaGFzIHByb3ZpZGVk
IGEgbGluayB0byBsaWJkZXZtYXBwZXIuaCBpbiBoaXMgcHJldmlvdXMgcG9zdCBpbgo+IHRoaXMg
dGhyZWFkLiBJcyB0aGlzIGEgcmVxdWVzdCBmb3IgbWUgdG8gaW5jbHVkZSB0aGF0IGxpbmsgaW4g
dGhlIHBhdGNoCj4gZGVzY3JpcHRpb24/CgpJZiBsaWJkZXZtYXBwZXIuaCBpcyB0aGUgYmVzdCBk
b2N1bWVudGF0aW9uIHRoZXJlIGlzIGZvciB0aGlzIHZhcmlhYmxlLAp0aGVuIGhvcGVmdWxseSB5
b3UgY2FuIHNlZSB3aHkgaXQgZmVlbHMgdG8gYW4gb3V0c2lkZXIgbGlrZSBhIGhhY2suCgpJdCBp
c24ndCBldmVuIGltbWVkaWF0ZWx5IGNsZWFyIHRoYXQgdGhlIHRleHQgdGhlcmUgaXMgdGFsa2lu
ZyBhYm91dAplbnZpcm9ubWVudCB2YXJpYWJsZXMgdmlzaWJsZSBpbiB1ZGV2LgpJZiB0aGVyZSBp
cyBhbiBleHBlY3RhdGlvbiB0aGF0IHRvb2xzIG91dHNpZGUgb2YgbHZtMiB3aWxsIHVzZSB0aGVz
ZSwKdGhlbiB0aGV5IHJlYWxseSBzaG91bGQgYmUgZG9jdW1lbnRlZCBwcm9wZXJseS4gIFNZU1RF
TURfUkVBRFkgaXMKZG9jdW1lbnRlZCBpbiAibWFuIHN5c3RlbWQuZGV2aWNlIi4gIEhvdyBoYXJk
IHdvdWxkIGl0IGJlIHRvIHdyaXRlIGEKImRtLXVkZXYiIG1hbiBwYWdlIHdoaWNoIGV4cGxhaW5z
IGFsbCB0aGlzLgoKQnV0IGlmIGxpYmRldm1hcHBlci5oIGlzIHRoZSBiZXN0IHlvdSBoYXZlLCB0
aGVuIG1heWJlIGl0J2xsIGhhdmUgdG8gZG8uCkl0IGlzIHVwIHRvIEplcyB3aGF0IGhlIGFjY2Vw
dHMgb2YgY291cnNlLgoKVGhhbmtzLApOZWlsQnJvd24K
