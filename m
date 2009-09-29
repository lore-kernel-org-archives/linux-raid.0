From: Mikhail Yakshin <greycat@altlinux.org>
Subject: Re: HW Raid Question
Date: Tue, 29 Sep 2009 19:15:23 +0400
Message-ID: <240e377b0909290815q67cb2388w788be78adc84b1fe@mail.gmail.com>
References: <c268e4660909272103r3831e129m68c11899b11be222@mail.gmail.com>
	 <70ed7c3e0909272339j2beb3de1rf3a925d207be1d8c@mail.gmail.com>
	 <c268e4660909280807q1bfb805eu4ec7804901ea1fb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909280807q1bfb805eu4ec7804901ea1fb6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Sep 28, 2009 at 7:07 PM, Drew <drew.kay@gmail.com> wrote:
>> You can reboot the server and access the controller's configuration
>> tool and see if you can grow it or not. Not all controllers offer that
>> option.
>
> I've already been through the controller's tools looking for an
> answer. I can see an option to grow via adding new disks but nothing
> about growing via disk replacement. At the time, I figured that might
> be an automatic function of the ServeRAID but having found nothing
> from IBM or Adaptec that say either way I'm still stumped.

Which controller do you use exactly? We planned to add support for
growing/shrinking logical volumes to Einarc, but it's not quite ready
for prime time yet. It might be supported soon, though.

What exactly do you want to replace? I guess you want to do some
procedure to gradually change all discs in the array and then grow a
logical disc? Like that:

1. Remove one small disc => array is degraded
2. Add one bigger disc, rebuild array
3. Repeat steps 1-2 for all discs
4. Grow physical extents
5. Grow logical volume

?

-- 
WBR, Mikhail Yakshin
