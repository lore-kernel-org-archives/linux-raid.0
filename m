From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 11:21:25 +1200
Message-ID: <1240960885.18303.787.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <18935.35883.181289.739254@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.35883.181289.739254@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> So where does grub store the core.img in this setup?

It's embedded after the MBR in the remaining sectors of the first
cylinder.
> 
> While the kernel might be noisy about large partitions, it should
> just be noise - everything should still work  - right?

It add's 20 - 30 seconds to the kernel start up time, but yes it does
work.


-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

