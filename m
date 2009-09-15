From: "Majed B." <majedb@gmail.com>
Subject: Re: raid disappearing mdadm: cannot get array info
Date: Tue, 15 Sep 2009 20:48:13 +0300
Message-ID: <70ed7c3e0909151048q328b80c0j93bdddfb55867161@mail.gmail.com>
References: <20090915113414.182528qq5c675mhw@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090915113414.182528qq5c675mhw@webmail.ualberta.ca>
Sender: linux-raid-owner@vger.kernel.org
To: aristizb@ualberta.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If the array doesn't show in /proc/mdstat then you can't perform
actions on it. The array has to be active to do that.

Do you know disks/partitions belong to that array? Try to assemble the
array (without resyncing if possible). I suggest you dig around and
find why the array stopped first.

On Tue, Sep 15, 2009 at 8:34 PM,  <aristizb@ualberta.ca> wrote:
> Hi.
>
> I have several raids created on my Linux box and one of them has disa=
ppeared
> from /proc/mdstat.
>
> The devices part of this raid are logical volumes and work fine.
>
> When I try to fail one of the devices from the raid I get the followi=
ng
> message:
> $mdadm /dev/md1744 --fail /dev/storage/disk1
>
> mdadm: cannot get array info for /dev/md1744
>
>
> This message is different form the one you get when the raid has not =
been
> created:
> mdadm: error opening /dev/mdXX: No such file or directory.
>
> So md1744 must still in some sense, even though it was not listed in
> /proc/mdstat
>
> The system where I hit this problem has enough RAM and is not being h=
eavily
> utilized.
>
>
> I am using mdadm version 2.6.3 on Ubuntu kernel 2.6.24-24.
>
>
> Any ideas on this issue are highly appreciated.
>
>
> Juan Aristizabal
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
