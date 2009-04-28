From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 16:37:21 -0700
Message-ID: <49F79331.1050007@zytor.com>
References: <1240574900.4507.2076.camel@ezra> <18935.35883.181289.739254@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.35883.181289.739254@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> So where does grub store the core.img in this setup?
> 
> While the kernel might be noisy about large partitions, it should
> just be noise - everything should still work  - right?
> 

For large disks, don't use MS-DOS partition tables; use GPT or another
clean scheme.

(For what it's worth, the MS-DOS partition table will work just fine for
the purpose of carving out a small /boot at the beginning, too.)

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

