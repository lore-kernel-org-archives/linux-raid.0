From: Trevor Morrison <trevor@hailix.com>
Subject: Re: removing RAID 1 from a RH 7.1 box
Date: Mon, 19 May 2003 13:23:40 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC92F3C.C36A9114@hailix.com>
References: <3EC911F6.B1797953@hailix.com> <3EC913B2.8050403@hum.auc.dk>
Reply-To: trevor@hailix.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mads Peter Bach <mpb@hum.auc.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the info, but I have a problem of when I fdisk /dev/sda1 and=
 go
to print the table nothing shows up, so I cannot change the partition t=
ype.
I can easily change the swap partition type.  The entire disk is mounte=
d
under /dev/md0.  What am I doing wrong? Note:  I have also tried to so =
this
same procedure by booting into linux single and also from the RH 9 resc=
ue
mode.  I still get the same result.

Thanks again,

Trevor

Mads Peter Bach wrote:

> Trevor Morrison wrote:
>
> > Or, does any one know how to remove the RAID 1 setup from my system=
=2E  I
> > followed the example for the the "Software RAID HOWTO" and it worke=
d
> > fine the first time.  Now, it looks like I may have to reverse it, =
but
> > I don't know how.
>
> You should be able to do that, by just doing this:
>
> - Change your partition types from fd back to 83
> - Move /etc/raidtab to some other name
> - Change lilo back to not using /dev/md/*
> - Change /etc/fstab back to not using /dev/md/*
> - Reboot
>
> --
> Mads Peter Bach
> Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
> Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
> # whois MPB1-DK@whois.dk-hostmaster.dk
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Trevor Morrison
Hailix, LLC
trevor@hailix.com



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
