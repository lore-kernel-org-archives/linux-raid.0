From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Kernel deadlock during mdadm reshape
Date: Wed, 27 Jul 2016 17:04:59 -0700
Message-ID: <1a648537-e31e-875b-642b-b68ff83a32f6@sandisk.com>
References: <bbcfb493-cdee-54cd-99aa-b1f9217b3b43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bbcfb493-cdee-54cd-99aa-b1f9217b3b43@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Shaver <jmshaver@gmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 07:18 PM, Michael Shaver wrote:
> I am experiencing the exact same problem reported in this thread:
>
> http://www.spinics.net/lists/raid/msg52235.html
>
> Also reported here:
>
> https://forums.gentoo.org/viewtopic-t-1043706.html
>
> And here:
>
> https://bbs.archlinux.org/viewtopic.php?id=212108
>
> I have a raid5 array of 2TB disks currently stuck at 94% of a mdadm
> reshape squeal to a grow operation from 4 disks to 5.  In my case, I did
> have a drive drop out of the array during the reshape.
>
> [ ... ]
> [<ffffffff811cb8dd>] truncate_inode_pages_range+0x46d/0x880
> [<ffffffff811cbd05>] truncate_inode_pages+0x15/0x20
> [ ... ]

Hello Michael,

I ran into a similar lockup while retesting the dm-mpath driver. So we 
either ran into a different lockup or the lockup was not related to the 
md driver. Were you using a distro kernel or a kernel you built 
yourself? Anyway, was THP (transparent huge page) support enabled? If 
so, can you repeat your test with THP support disabled and see whether 
that makes a difference?

Thanks,

Bart.
