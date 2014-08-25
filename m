From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Mon, 25 Aug 2014 10:32:34 +0000
Message-ID: <20140825103234.GH11855@bitfolk.com>
References: <20140823163110.GE11855@bitfolk.com>
 <20140824130939.461501b4@notabene.brown>
 <20140824143944.GC19874@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140824143944.GC19874@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Aug 24, 2014 at 02:39:44PM +0000, Andy Smith wrote:
> $ sudo ./mdadm /dev/md2 --grow --raid-devices=3D4
> mdadm: Cannot set new_data_offset: RAID10 reshape not
>        supported on this kernel

Grow.c from latest git:

2397                         err =3D sysfs_set_num(sra, sd, "new_offset=
",
2398                                             new_data_offset);

=46or the first device in the for loop (sda3), the above line 2397 is
returning -1.

2399                 }
2400                 if (err < 0) {
2401                         if (errno =3D=3D E2BIG && data_offset !=3D=
 INVALID_SECTORS) {
2402                                 pr_err("data-offset is too big for=
 %s\n",
2403                                        dn);
2404                                 goto release;
2405                         }
2406                         if (sd =3D=3D sra->devs &&
2407                             (errno =3D=3D ENOENT || errno =3D=3D E=
2BIG))
2408                                 /* Early kernel, no 'new_offset' f=
ile,
2409                                  * or kernel doesn't like us.
2410                                  * For RAID5/6 this is not fatal
2411                                  */
2412                                 return 1;

It reaches here line 2412 with errno =3D=3D E2BIG.
/sys/block/md2/md/dev-sda3/new_offset exists.

=46rom strace:

open("/sys/block/md2/md/dev-sda3/new_offset", O_WRONLY) =3D 4
write(4, "128", 3)                      =3D -1 E2BIG (Argument list too=
 long)
close(4)                                =3D 0

Not sure where to debug next.

Cheers,
Andy

--=20
> The optimum programming team size is 1.
Has Jurassic Park taught us nothing?
 =E2=80=94 pfilandr
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
