From: Carlos Mennens <carloswill@gmail.com>
Subject: Re: RAID1 On 3 Drives
Date: Mon, 15 Mar 2010 07:30:18 -0500
Message-ID: <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
References: <4B9C11FB.7040604@gmx.net>
	 <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
	 <4B9C24B6.7040507@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9C24B6.7040507@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 13, 2010 at 6:50 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Having a spare on raid-1 is fairly pointless, it hurts performance and buys
> you nothing. Having one more copy of the data built and ready serves you
> better.

Can you explain this as I find this interesting. How does having a
/boot partition on 3 drives with 1 spare hurt performance? Are you
saying that I would get better drive performance if I had all 4 disk
partitions active members of my RAID1 /boot? I just don't understand
how the 4th disk doing nothing but acting as a spare would hinder
performance.

Secondly, if the above statement also applies to my / partition? Would
you suggest using all 4 drives as active partitions in a RAID5 array
too? If I have a 3 disk RAID5 and one hot spare, do you think I would
get less performance value for my configuration?

Thanks for the clarification!
