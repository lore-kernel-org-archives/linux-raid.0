From: Marc Bevand <marc.bevand@smartjog.com>
Subject: Re: Extend raid 5
Date: Mon, 12 Jan 2004 11:02:42 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400270C2.3030009@smartjog.com>
References: <1704458665.20040112011155@gmx.de> <20040112021335.GF17845@matchmail.com> <200401121021.08498.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401121021.08498.maarten@vbvb.nl>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten v d Berg wrote:
> [...]
> Hi Mike.  I read about LVM some time ago and decided to use that as it seemed 
> to solve my problem of the ever-growing data volume I need to store.
> 
> However, after the initial setup I quickly dropped the LVM idea again since it 
> only _seemed_ to solve my problem. As I understand it, LVM allows the 
> addition of extra volumes but it does nothing at the level of the filesystem 
> which resides on top. So in order to effectively grow my filesystem, which is 
> the ultimate goal of course, I'd need to delete the current FS and make a new 
> -bigger- one. And last time I checked this definitely kills your data.
> 
> Otherwise, adding a 40 GB physical volume to a 120 GB raid5 / LVM set just 
> gives me one 120 GB partition and [room for] another 40 GB partition. 
> There is NO gain whatsoever using LVM here compared to when I would just have 
> added a single 40GB disk all by itself without using LVM in the first place, 
> is there ?
> 
> This has always left me wondering.  Did I miss something (except using some 
> alpha FS-resize code...) ?

This is precisely the point, you have to resize your filesystem so that
the extra space added to your LVM device is used. There are many
options, you can either use a userland tool (resize2fs, resize_reiserfs,
...) for resizing an *unmounted* filesystem, or you can do it in the
kernel (mount -o remount,resize=<size> <device>). As you can see, doing
it in the kernel has the extra advantage of allowing you to resize a
*mounted* filesystem.

Filesystem resizing is more stable than you think, for example the
commercial program Partition Magic is based on resize2fs (but I am not
sure if I can convince you with this example since proprietary software
is evil :P).

-- 
Marc Bevand


