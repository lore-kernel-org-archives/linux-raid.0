From: Raz <raziebe@gmail.com>
Subject: Re: Subject:[PATCH 001:013]: md: Raid0 reshape
Date: Thu, 18 Jun 2009 14:42:45 +0300
Message-ID: <5d96567b0906180442j1fc4b753xe3db627da0dccd90@mail.gmail.com>
References: <1245189112.3478.94.camel@raz> <20090617081238.GB6403@skl-net.de>
	<5d96567b0906170123q2fad427bu37526f3692b0f0f6@mail.gmail.com>
	<20090617162327.GC6403@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090617162327.GC6403@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 17, 2009 at 7:23 PM, Andre Noll<maan@systemlinux.org> wrote=
:
> On 11:23, Raz wrote:
>
>> >> + =A0 =A0 if (mddev->level =3D=3D 0) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 max_sectors =3D mddev->array_sectors;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 j =3D mddev->recovery_cp;
>> >> + =A0 =A0 }
>> >> =A0 =A0 =A0 printk(KERN_INFO "md: %s of RAID array %s\n", desc, m=
dname(mddev));
>> >> =A0 =A0 =A0 printk(KERN_INFO "md: minimum _guaranteed_ =A0speed:"
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 " %d KB/sec/disk.\n", speed_min(mddev=
));
>> >
>> > Hm, we want to get rid of personality-dependent code in md.c, so n=
ew
>> > code should never check mddev->level. In the first hunk I think it
>> > would be possible to check if pers->sync_request is NULL.
>> No. sync_request does exists. this is what Neil wanted me to do.
>> implement raid0_sync
>> so I will be using md for this purpose. I knew that md patch is a
>> problem, this is why I posted
>> it first.
>
> OK, so pers->sync_request can't be used, but that was only one
> possible option to replace the check mddev->level =3D=3D 0 by somethi=
ng
> more generic. BTW: The log message should describe in which case the
> resync status shows an incorrect value and why one can not determine
> which value to use for max_sectors by looking at mddev->recovery.
>
>> > Is the second hunk really necessary? AFAICS md_do_sync() won't be
>> > called for raid0 anyway.
>> second hunk is necessary for resume reshape. md_do_sync is called
>> indirecrly by raid0d -->md_check_recovery.
>
> Yes, I didn't notice because raid0d() is introduced later in patch
> 10/13 of your series. When introducing new and apparently dead code
> it's always nice to let people know that the new code is going to be
> used by a function that will be added in a subsequent patch :)
noted.
> Regards
> Andre
> --
> The only person who always got his work done by Friday was Robinson C=
rusoe
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iD8DBQFKORh+Wto1QDEAkw8RAm3GAJ9orjx5oVNM/bCsmWwmYtPpa5s82gCdHxzE
> 1+jPSDd77+YrehyaKDoeICE=3D
> =3DXZIE
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
