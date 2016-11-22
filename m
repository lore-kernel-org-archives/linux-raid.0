From: Coly Li <colyli@suse.de>
Subject: Re: raid10.c read_balance question
Date: Tue, 22 Nov 2016 17:59:52 +0800
Message-ID: <4487c0c7-1cc5-1045-9ae5-86bedf6c2ebc@suse.de>
References: <CAANLjFodaUUZrROncC+uQjWX5pXVxgJ0HWkNunwugQQrp4Kojw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFodaUUZrROncC+uQjWX5pXVxgJ0HWkNunwugQQrp4Kojw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ÔÚ 2016/11/22 ÉÏÎç6:45, Robert LeBlanc Ð´µÀ:
> I'm looking to improve 'near' layout performance in raid10 and looking
> at the code for read_balance, the comments mention that there is a
> 'next expected sequential IO' sector number stored for the RAID array,
> but I don't see such a variable in the struct, nor do I see in
> read_balance where that variable is being updated. With such a value,
> I could use it (with another variable) to guess if the current
> requests are random or sequential enough to take the latency hit to
> move drive heads to help parallel the read. This would be a much
> simpler route than what I was thinking about previously.
> 
> Am I just missing this variable? I would expect it to be in the
> r10conf struct, would that be the right place to implement it if
> doesn't exist?
> 
> Thanks,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


Hi Robert,

This code was originally from Linux 2.6.9, it seems like copying from
raid1.c:read_balance(). IMHO you don't miss anything, we should remove
the following text from the comments,
    There is a per-array 'next expected sequential IO' sector
    number - if this matches on the next IO then we use the last disk.

How about compose a patch ?

Coly
