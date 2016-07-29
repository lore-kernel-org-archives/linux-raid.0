From: Glenn Enright <glenn.enright@gmail.com>
Subject: Re: xosview
Date: Sat, 30 Jul 2016 11:23:19 +1200
Message-ID: <CAN7jt23SW57ZZObwbVnPsD9ZOzDcXjp=UrL-DX_SUqva+hJW_A@mail.gmail.com>
References: <ffd06b83-0692-d5a4-1daa-126abf53edfa@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ffd06b83-0692-d5a4-1daa-126abf53edfa@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: mdraid <linux-raid@vger.kernel.org>, mike.romberg@comcast.net
List-Id: linux-raid.ids

On 30 July 2016 at 04:52, Anthony Youngman <antlists@youngman.org.uk> wrote:
>
> I don't know how many of you use this ancient nifty utility, but I've been using it for as long as I can remember. Unfortunately, the raid monitor code no longer works ... :-(
>
> I emailed the maintainer privately and he was pleased that I'd got in touch even though it was with the bad news, and he'd like to fix it, but he has no system with raid to test it on.
>
> It works by parsing /proc/mdstat. From what I can see of the code, it would be very easy to test it by pointing it at a fake mdstat. I've got three arrays on a two disk mirror, so that's easy for me to test, but I'd like to test it on other setups.
>
> So if people wouldn't mind, could you email your mdstat files? Preferably on the list so people can see what has and has not been sent - obviously I'd like standard setups like raid10, raid5, raid6, both named and numbered. And if people have them, mdstats showing broken arrays, rebuilds, complicated setups with lvm, etc.
>
> Dunno about other people, but I have xosview running on my desktop all the time (I feel naked without it :-) so if that can give me a continuous monitor of my raid state that's great. And hopefully, if other people use it, we might reduce the number of "I didn't realise my raid was degraded, and then it suffered another failure" type emails.
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


There are a number of good examples on
https://raid.wiki.kernel.org/index.php/Mdstat

This is from my desktop... (boot root and swap)

$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid1 sdb2[1] sda2[0]
      4194240 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
      62914496 blocks [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
      204736 blocks [2/2] [UU]

unused devices: <none>

Best
--Glenn
