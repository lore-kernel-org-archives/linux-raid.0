From: linuxmasterjedi@free.fr
Subject: Re: Which RAID do you recommend for home use?
Date: Wed, 28 May 2014 08:10:33 +0200 (CEST)
Message-ID: <1402139037.9078673.1401257433030.JavaMail.root@zimbra32-e6.priv.proxad.net>
References: <CAJvUf-BVTNd9jK3oXyX3uUAj9x6F0j+Aqg4UCrRUmdSPsGdRiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BVTNd9jK3oXyX3uUAj9x6F0j+Aqg4UCrRUmdSPsGdRiA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> ----- Mail original -----
> De: "Matt Garman" <matthew.garman@gmail.com>
> =C3=80: "L. M. J" <linuxmasterjedi@free.fr>
> Cc: "Mdadm" <linux-raid@vger.kernel.org>
> Envoy=C3=A9: Mardi 27 Mai 2014 21:16:08
> Objet: Re: Which RAID do you recommend for home use?

> How big are the drives?  What are your goals?  Any performance requir=
ements?
Got 3 TB drives.
My  goals : tolerate a drive fail, most important stored data : family =
pictures!
Performance requirements : not the main target
Got backup : Yes, on a USB drive and on LTO2 tape (yes, for home use !)



=46or home use and "mostly static data", raid-10 is probably not what
you want.  If you are using RAID as a proxy for real backups, more
redundancy is better than less, so I'd buy another drive and go with
RAID-6.  Also consider, if these are large (>2 TB) consumer-grade
drives, then rebuild times will be quite long.  During rebuild, your
drives are stressed heavily, so the possibility of failure goes up
considerably.  Again, more redundancy is your friend.

On the other hand, if you have real backups, and can tolerate the
downtime, RAID-5 is probably adequate.

Sound like RAID5 is still the way to go for me then !



Depending on your particular needs, there are another couple
possibilities that might interest you:

snapraid - http://snapraid.sourceforge.net/ - like raid-5 or raid-6 (I
believe it now supports even more levels of parity), but not in "real
time".  The idea is that your data is mostly static (think large media
collection), so it doesn't make sense to have extra drives spinning
all the time for on-the-fly parity calculations.  Just update your
parity data as-needed (either by hand or e.g. nightly cron job).

zfs - http://zfsonlinux.org/ - arguably a "competitor" to linux md, it
does provide "raid-z3", which is zfs's branding for triple-parity raid
(zfs raid-z1 is basically raid-5, raid-z2 is effectively raid-6).
Gives you a little more protection if you're going without backups.

I would like to stay on basic md array, to be able to rebuilt it from a=
 sysresccd or so...

Thanks !
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
