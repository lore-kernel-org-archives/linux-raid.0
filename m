Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4670F31C57B
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768835661; cv=pass; b=I6LTIOE46diRS7nK8mfXTyjiF04X+lnSFHoCm74rZNff4TDZjHkiTxIEbmf30dGGsWRcaarqTtkKpPbjlq5xF47kTmoLDyZX/f01VCyNOTi0/6j0VWmDy0CenVAhePLH6fH6ysCf2ubZElMVFQay8xIR2Hweah8nfvlZl9PhLVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768835661; c=relaxed/simple;
	bh=nSVqS5HR6xadJW1cWju2L/oei3pyw4u0PaHBZnstzBk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=c5adc8O8JxtwrJ9kyP3BUMK7I+pCZA7UASha2VZFK5layBFNvs6DgrubDC9/ft/sGki1QJDpI/5paMtG5nRnqOvtDngitBZiKr4Z6+PlU9vKsSRBUPC7unsFVgnclpyNiPIn8HrnsICxR9gaF6tONiJuC5WedTayc0BFKDMHnsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=bitnM0xs; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="bitnM0xs"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8712506a3eso28920066b.3
        for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 07:14:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768835657; cv=none;
        d=google.com; s=arc-20240605;
        b=b+AYghmDR9FJaa/HpOWhXMZyj0dAgHVjw/E0E8YFz8Sl/A2HCKp8oC2xdoZ/922Lgg
         yr6y0DZE2zEmGZqlBNqEifrI876x8w5J5Bew12tKY+7RUTPWE3l3elNC0VvoRYSSEAeg
         xlq+LW391jWGbvvy//pW/f4Fz/H4gAKdm3c8DUenLDEKing2/WX8nQrm+rUY8nA0eUzK
         NoRqiWPGfb7t292fgtV7Efo5O0Z5TevAuDMD+1Y05z+GVirMqi1V8VSGNIFyod4xjH5Y
         PQXhkmYt6HEFxYpsb+dIHZTL4lioMoG96N8P7dGxfKQf7Nd9c71uxY00t5IStQPDo6wY
         hh8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=2VlBJReW5aFl/c1yGY2wVYkjZm2jflhnYsCPIwqksbY=;
        fh=TS6BVBldV/Y33FvZgBpn3a3m5IPcOvp8Mv3KJMZFW0Q=;
        b=BLGOKsWJdZj+i8e9guUSEcKiuYgxsEppyO0NjJNfct15z8lvx36hNCOFO9MyHVKC82
         qESCOq2nSGtS+LqSN9Gf7ddrgoysvWk3q1mQuC5+OR0NBJvpaX8dOeJR58w9+e7Rx50e
         FxS7wdBFR3oSY+y8PyIRcgpfQDGjEsCRVIsb0XeP4wpvKDDCkwqmw9YpFG6NlvPRrdYv
         AGSHzPMFUNuNJMJ5op3DkfR0PPT5tepld6H786BWZt3nTj+m/aqumKEE8IqDcNHhUaV0
         Io5zjdK/g3vZLxZdWMfpkjwIse7Y2p9qifBo98A4NlKU8To8JMJFjhP0gmtI2PHMoNez
         Zr5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1768835657; x=1769440457; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2VlBJReW5aFl/c1yGY2wVYkjZm2jflhnYsCPIwqksbY=;
        b=bitnM0xspbqKZSgOcAgPpgHZ59GsYumBw5rmwMCN5M0SM+A8SN9VuLGSdaWkZgtO3c
         0D1ULxjer13WH83AKOe7v+hcxTXvS7UGz1Vjdu1RNaBrPOxsyay5VtSCbvJ+opeKp5iw
         DVALcG6uWtGhkmg7UpM41hxDCC9agLtXKNDa2g3nkBmpYQ8AcDqVUb7t2luBuwYOzyKH
         6NnE3sLSoys+31NG7o71a6VWf6kGNMEgrr9kHejb0x6OJ+L0F5yds03LZhaHoJkiXyar
         nkEzid25q4Hlgwh3PzfhfM4XKojSnoh0Cz2Md8t0trnjpEN8OLH/WvQsNJ1bUfyy/mj6
         gb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768835657; x=1769440457;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VlBJReW5aFl/c1yGY2wVYkjZm2jflhnYsCPIwqksbY=;
        b=cAEx4WQuubcBi6ZksXOi/qlahBdWWUEGK2nvWCwOgTLAItSCo0aeUmCmzGiG4Mwjkb
         DWDIYT4T1vI7D/zb18lGB2xj08AGYhjtfzw1rJiJT2ylYXw1TJkaF+/6an17t0u2x0LZ
         WFy318l9crNmSgTIS51UVW6XX87rR/Aca0MclJ1oDc2GEfK9fB0QhGXG8y30COAP7n6V
         zV4YeQwxz2+XYkCkc/pVPt3xL2rMvuvEGOYZUVTz/cO/2i0M2DGShUBuF2EMJZqPDWxG
         Iv5AY3EK+/83HqKFPeCudAvT1R7sLVLJzMeXSBlguuVnIsSu/rQA2jyjv9UfwkFlPFFC
         Scsg==
X-Gm-Message-State: AOJu0Yy4gBut7IClrim7JVb/qWCu+wwoufSUoghlBlGlA3sTWZW8db59
	VRGZVywhUnAZtT8YKehOMd7kkz9N2HEIFzOY9+XVhQuIHT/sd1FNooio4KZo7XwPrsmYPRcEGsP
	sSPRHDA5yBxWiJqKukz/eO7LybyqvzM46lu5tRoamUMotqbYE/L4l
X-Gm-Gg: AY/fxX5tIRqv0O6WhBrN15ASsnQM5IPQ1/8ZqXnAx8mzlUo8R/pgXCN4wfPLCelHQpe
	opGrBirmZriZxFCEjrTh3k48loy+tbFiMij7OAN2A8O/ZZCIeEIuyNPK8i+5UBzJgrVivO6BC3t
	K+LG4jFPmtUqjOeRM5WrA/16hial5C9DH73MN1/4vy/saTpZfvjqkFNbo4clFw9Xz/icT/VCcsi
	tn0LuxO+R7AkF9Sl+xuoU74M4Ps/6sO+vWawePOtTIf7rpR7lcNLwfBTRJxaqFbMQdPH+oyxjRK
	KW1ZwuYuAyaptT1l9mva+br0oqo=
X-Received: by 2002:a17:907:9706:b0:b7f:fd9d:fff4 with SMTP id
 a640c23a62f3a-b8792d487f3mr622664766b.1.1768835657435; Mon, 19 Jan 2026
 07:14:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Mon, 19 Jan 2026 16:14:05 +0100
X-Gm-Features: AZwV_QiEOHX1mEnMD4PHw1bv8tB3823TQMa7TWdqk2BcEQvobHX_gtU8Z8XWTRw
Message-ID: <CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com>
Subject: [BUG] md: race between bitmap_daemon_work and __bitmap_resize leading
 to use-after-free
To: linux-raid <linux-raid@vger.kernel.org>, yukuai@fnnas.com, 
	Song Liu <song@kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello folks,

We are seeing a general protection fault in the md bitmap code during
array resize operations. This appears to be a race condition between
the bitmap daemon work and the bitmap resize code path in kernel 6.1
(and likely later versions).

[Crash Details]

The crash occurs at write_page+0x22b when dereferencing page_buffers(page).

general protection fault, probably for non-canonical address
0xc2f57c2ef374586f: 0000 [#1] PREEMPT SMP
CPU: 18 PID: 1598035 Comm: md53_raid1 Kdump: loaded Tainted: G
  O       6.1.118-pserver
RIP: 0010:write_page+0x22b/0x3c0 [md_mod]
Code: f0 ff 83 f0 00 00 00 e8 13 6d a3 cb 48 85 db 74 cb 48 8b 53 28
49 8b b6 40 03 00 00 48 85 d2 0f 84 41 01 00 00 49 8b 44 24 70 <49> 8b
7d 20 b9 00 10 00 00 48 83 e8 01 48 39 c7 0f 84 da 00 00 00
RSP: 0018:ffffa82f3b857c40 EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffff99abc0e39400 RCX: 0000000000000000
RDX: ffff99bfc21a3c00 RSI: 0000000000000008 RDI: ffff9a2c9ce358c0
RBP: ffff99ac72048018 R08: 0000000000000000 R09: ffff99ac720482c0
R10: 0000000000000000 R11: 0000000000000000 R12: ffff99b151373e00
R13: c2f57c2ef374586f R14: ffff99ac72048000 R15: ffff99abc0e394f0
Call Trace:
 <TASK>
 ? exc_general_protection+0x222/0x4b0
 ? asm_exc_general_protection+0x22/0x30
 ? write_page+0x22b/0x3c0 [md_mod]
 bitmap_daemon_work+0x26b/0x3a0 [md_mod]
 md_check_recovery+0x58/0x5d0 [md_mod]
 raid1d+0x8e/0x1940 [raid1]

[Analysis]

The root cause is a use-after-free race between

__bitmap_resize() and
bitmap_daemon_work().

bitmap_daemon_work() (running in the md thread) iterates over
bitmap->storage.filemap[] and calls
write_page():

for (j = 0; j < bitmap->storage.file_pages; j++) {
    if (bitmap->storage.filemap && ...) {
        write_page(bitmap, bitmap->storage.filemap[j], 0);
    }
}

Crucially, this access to filemap[j] is done without holding any lock
that would prevent the storage from being replaced and freed.

__bitmap_resize() (triggered by resize ioctl) replaces the bitmap storage:

spin_lock_irq(&bitmap->counts.lock);
md_bitmap_file_unmap(&bitmap->storage); // Frees old pages and kfrees filemap
bitmap->storage = store;
spin_unlock_irq(&bitmap->counts.lock);

Even though

__bitmap_resize() calls quiesce(), this only suspends normal I/O. It
does NOT stop the md thread itself, which continues to run and can
enter md_check_recovery() -> bitmap_daemon_work().

[Race Window]

Thread 1 (md thread) reads a page pointer from
bitmap->storage.filemap[j]. Simultaneously, Thread 2 (resize) calls

md_bitmap_file_unmap(), which calls
free_buffers(page) and
kfree(filemap). When Thread 1 enters
write_page(), it dereferences the now-freed page/buffer_head,
resulting in the GPF.

The current locking (counts.lock) protects the bitmap counters but not
the bitmap->storage structure itself during the transition to

write_page.

We are looking for suggestions on the best way to synchronize this. It
seems we need to either: a) Ensure the md thread's daemon work is
stopped/flushed before

__bitmap_resize proceeds with unmapping. b) Protect bitmap->storage
replacement with a lock that
bitmap_daemon_work also respects.

Any thoughts on the preferred approach?

Best regards,
Jinpu Wang @ IONOS Cloud
