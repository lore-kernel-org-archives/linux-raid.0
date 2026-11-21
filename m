Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795298143;
	b=0+jwedosqpOFrh8vYOC6qdvB5S/5Bj7/QHfu+4DVFwt/3Zy1ci5WskRYBfDHwV3dVzSk
	 T6Yi9chQMwxO31oJlr3YLkVXcVlF7iBMVmWab2pAjqHmfMiPdUdIWaAzXLRxQtmlKAMfb
	 GfGSuNUEwocaD/nh7658GKAIiCdlujOHVL3ZIEmJX0cze90Evy3RZgXDKJS9lpcYv4IUq
	 tMmWgV1SSZe2uS8UaqC2TSBsKO3vRkfjqAp/7qxYxIOJaKX5dhVrDFuSjEh8/JUKOQlg8
	 4PHRrJsZ1yBKyS1RALhCd8Pzkcm1DwYhACGzz/rCXreWNLTns7TvKbJBqTM1gr8uUPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795298143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Date:Message-ID;
	bh=KCjUtohJo1syh5AF9wt+LVHJxvbyrd0qzAwW5js+pGw=;
	b=lKX9Ymi8IF2yS6icJGE9YQp3EI8obJoeccZu3niIrF46FEf6PWcZEquci8h0WW3nPkBp
	 ycWbjXV9tiH6dHOuwdeOWoRbwF3S9f40SumFqg8GpyKVv7PLoEVdFh/ewAW3gaS4lFW5W
	 HQoa3UtsvJlk+OH/KthDGXINr5a8vNoPAV0ExBetfsMYUTZ8uLT+0REg60681yAu1KCHu
	 wmspvsIiEODumMq+kGNv+pLAeCGkYwd20xrPWI9lgUJQeK25BUrf7xhv8tekhEvPux1UE
	 DbiffuYG6AmvgWtc3E/eT/OTxO/ARwbR8P/K8Xyn6D9Qxth1cA2ZDUR/zxW4IXerrAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elRo4E8e;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5622606A320
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 21:55:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5622606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elRo4E8e
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c5118deebcfso307742966b.1
        for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 13:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795298141; x=1795902941; darn=vger.kernel.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KCjUtohJo1syh5AF9wt+LVHJxvbyrd0qzAwW5js+pGw=;
        b=elRo4E8eL6Ff9JTxWokGSChCv6ga6xjLaxbwG4IuokCWQcX+8wY/4TwbB9eLmqPNvd
         Fh3vzMvwpzy/pOr2RX9SlCQFI+Hjk0445UVSnhuh4ztDmhLZM+VCJtLlSDSy7y76lSic
         c37MaL4b1Qz4CtJy8OeIs3V21nTsac4UlO4hgwJ8SnYbq9OyCNug0iwYSaixQfjAzjpY
         qPi9C6xCmDJPR0eKep0Rxz3wp82ZhOkjc38M9DvXOyC5JPcdEuj9G7TBP8QX4eJJsx/n
         sOs4jdQxDBwnYwTPuxSdyz7MRdh2JqrOe9sBMUh6XX6rEf5X3LuB5PNqbH0zit7TtGC9
         NUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795298141; x=1795902941;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KCjUtohJo1syh5AF9wt+LVHJxvbyrd0qzAwW5js+pGw=;
        b=Ax0oK/Lk+b2GZDF6x0LboYJ+z/5YN7/yPWaFimjCZWdKTIMcrBZJ4riYVYhroezZ89
         HN4S9eFbf7e2Pe8yqZv3CCvzOBtf54ss9WZxAtbMAEK1GUhxrGjMH+Pb3Mg0lEtxI2ya
         aUOnzn55F33Oj/tLEDZHBJ94uevJ+/gWqk0q0WxiHS/Dav2UGa1hViAQbYGNdsCJVXUT
         nwptq869qaKuBFq1WjQ8KdT82xIn3c1Z+/G3xYPx27olVn1Dolo7a9tJJiUmvT64ihjn
         NMO6+5GkvTAlPY0gAR+eAsytZgVC6XT4DjWTF9x2D9PdmV7Y/aCHZ/J94tL9fYJRtJox
         ZXIA==
X-Gm-Message-State: APuU4Z85Q3Z1MRLJkDgaepaJcflDYq/rq0E0huGs1RrTOGgkOqqo9Lk5
	eSlYMG0hZor6HbdjVZurSMGDxpO3RWlELY/9jDsZhYuXe9lhqnBGukXL7Vi87KfVJm5u+w==
X-Gm-Gg: AZFdTZc3MKcyFprA7t5GQOK2whEUc38UmLt2pJVYrBQsOwj9eHsqEK++Ezhd8aWZj7G
	e7tpy8a0Dn8HUZkAUZC49SEe6ot0irNS+Ben7uGvPpGDVtzXToOKH+liJNkUpk1d2ZqEO5k0LwT
	HRKtdABitQic+lMoFy4wFSO7559Mo/1ZlBwT+6V+WqkNsxUkc6FgwEe/RZFXwTTeC/Ym173820J
	B0eDsZsvFdmO1IyFXFwiZ28ynkJsuXbyNnq7a3B7C9niFT/UBbv3u2CttQxTAh+VREgMfnUfOlh
	2Yb0l8YHE9nMH1pTTmGiZfC8DuV9iEHNZ1t0LqlLfQhQmNQnUZTPhlaq0OjZKitUik3hWTvfpS1
	WxnjL0ZuE5knjb7Tw92cZDB+nZmVuT93JND3+i7d0uJgLv5wZFb21uEYcdEJ05HAOdR4pcxuvWB
	oyK0hWXpne1RDL+ncygm4p+ndudJyZo5t1Cn8WeCAnHVWN6zjhE/o8lK4Rk+RBhd8O238J86jHj
	z/8JQIqtXtRZorJPhgzXY2QJ07vsVY65f4Nz3A8r4AQjuwV3oNhz0erD+gVej7tVyIg6o0CEJfV
	QE0Nkifzl70S/quFppVepb0eqmKf7bhD
X-Received: by 2002:a05:6402:13cc:b0:6ba:88b9:71e6 with SMTP id 4fb4d7f45d1cf-6ba88b97656mr636301a12.14.1795298140925;
        Sat, 21 Nov 2026 13:55:40 -0800 (PST)
Received: from [192.168.1.182] ([2a0c:db40:0:80df::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba370faeeasm3038747a12.22.2026.11.21.13.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 13:55:39 -0800 (PST)
From: Konstantin Nikiforov <helllamer@gmail.com>
To: linux-raid@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Yu Kuai <yukuai@fygo.io>, Song Liu <song@kernel.org>,
 Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>,
 magiclinan@didiglobal.com, xiao@kernel.org
Subject: Re: [PATCH] md/raid5: complete unsupported discards successfully
In-Reply-To: <179529607529.5.3302391929789139470@gmail.com>
References:
 <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com>
 <179299857972.12222.2729359466842183358@gmail.com>
 <179529607529.5.3302391929789139470@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 22 Nov 2026 00:55:36 +0300
Message-ID: <179529813639.2.16814857958553170519@gmail.com>

Hi Kuai,

A short follow-up to my tested-by report: I removed the udev rule that
zeroed discard_max_bytes from the md75 initramfs and disabled the host
copy, then tested the real HDD-backed stack with an actual discard.

Same kernel: 7.4.0-rc2-md75+, md-7.5 tip c526b7cd32f7 with b964c9240a37.
The stack advertises discard again:

  md126:   discard_max_bytes=2199023255040, discard_granularity=1048576
  bcache0: discard_max_bytes=2199023255040, discard_granularity=512

devices_handle_discard_safely is still at its default (N), so this is the
raid5_discard_limits() path the patch changes.

I created a 1G scratch LV on vgpcrd5 (dm -> bcache0 -> md126 on the three
ST1000DM010 HDDs) and issued one 64M discard:

  blkdiscard -o 0 -l 64M /dev/vgpcrd5/discardtest-md75
  exit 0
  /sys/block/bcache0/bcache/io_errors = 0
  bch_count_backing_io_errors in dmesg = 0

So the real bcache -> md126 -> HDD path also completes unsupported discards
successfully, not just the loop reproducer.  That was the last test item
pending from my earlier report.

Thanks,
Konstantin
DeepSeek Flash v4.1
