From: berk walker <berk.walker@verizon.net>
Subject: Re: mdadm - comments on command layout
Date: Fri, 13 Aug 2004 22:28:50 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411D78E2.8000805@verizon.net>
References: <16669.9163.392465.637229@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16669.9163.392465.637229@gargle.gargle.HOWL>
To: John Stoffel <stoffel@lucent.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hear hear (also, here here)
b-

John Stoffel wrote:

>Hi Neil,
>
>I've been using mdadm recently to work with some arrays and I really
>have to say I dislike how the commands are laid out and used.  First
>off, they're not consistent from one usage to another.  Of course, I'm
>going to be jerk and not give good examples since my personal box at
>home is down and I'm at work.  But the idea is that when you assemble
>a RAID device, it should look similiar to how you manage that raid
>device.
>
>I'd also love it if there was an mdadm shell, so I could just type
>'mdadm' and get back a shell prompt like:
>	
>	mdadm>
>
>which I could then use to manage my arrays.  
>
>For example, I think all the commands should be of the format:
>
>    mdadm <comand> [options] <array> [devices...]
>
>as much as possible.  I'm basing my thoughts on both the Vertias VxVM
>command set, as well as the ClearCase 'cleartool' command shell.  So
>ideally I could do either:
>
>  > mdadm assemble md0 /dev/hda1 /dev/hda2 ...
>
>or
>
>  > mdadm
>  madam> assemble md0 /dev/hda1 /dev/hda2 ...
>
>depending on my mood.  Currently, the mdadm commands use various
>formats for their arguement layouts and it's a pain to figure out what
>to use.  
>
>So before I get all worked up on this issue, and spend a bunch of time
>mapping out how I think the commands should work, do people agree with
>my observation?  
>
>Thanks,
>John
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

