From: "Majed B." <majedb@gmail.com>
Subject: Re: Array Power Management
Date: Mon, 7 Sep 2009 12:57:33 +0300
Message-ID: <70ed7c3e0909070257y4bec456h6de9cc6d2981c8ce@mail.gmail.com>
References: <292245.77763.qm@web55804.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <292245.77763.qm@web55804.mail.re3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you're going to spin down the disks, you'd need to unmount the
array first to ensure your data is fine, and after a spin-up then you
mount the array again.

I would suggest you buy a meter to measure how much power your storage
is consuming before you decide on your next action.

Personally, I'd turn off the machine altogether if it's not needed
during working hours (assuming no one accesses through VPN). Check the
BIOS, it may have the capability to wake up the machine on a certain
date & time (So you can specify to turn itself on daily @ 8 AM).
If not, you should have Wake-up On LAN support, so if you turn off the
machine, another machine (a monitoring server) can turn it on for you
(just put the wake-up on LAN command as a cron job to execute daily --
perhaps exclude holidays).

On Mon, Sep 7, 2009 at 6:48 AM, jahammonds prost<gmitch64@yahoo.com> wr=
ote:
> I've been becoming interested in the power consumption of the arrays =
I have on a couple of servers here that are basically used as media ser=
vers. Since they're not being used when I'm at work, I was looking at t=
he possibility of spinning the disks down during certain times, and hav=
ing them either spin up at a set time, or (ideally), when there is disk=
 activity.
>
> I can do this on single drives using hdparm -S to set the spindown ti=
meout, and the disks will spin up on activity as needed. Is there somet=
hing similar I can do with an md array? I can see there's a /sys/block/=
md0/power/wakeup file, but I can't seem to find any documentation on it=
=2E I have thought about doing an hdparm -S on the array disks, but I s=
uspect that would be A Bad Thing (tm).
>
> Does anyone have any advice/pointers? The servers are currently runni=
ng fc9 - I'd like them to be Centos, but had to go with fc9, as I=C2=A0=
needed Port Multiplier support.
>
>
> Graham
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
