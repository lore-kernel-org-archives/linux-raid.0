From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Add ability for disable bad block management
Date: Fri, 9 Dec 2011 14:53:15 +1100
Message-ID: <20111209145315.55a0704d@notabene.brown>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
	<20111130111403.7efd3875@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
	<20111206170525.1f4e32ab@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A055919@IRSMSX101.ger.corp.intel.com>
	<20111207125255.51382e59@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A055D88@IRSMSX101.ger.corp.intel.com>
	<20111208150222.2ce2ac16@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A056305@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uWWaovcPwii6uPW/./RwcKC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A056305@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/uWWaovcPwii6uPW/./RwcKC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Dec 2011 15:36:43 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, December 08, 2011 5:02 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms,
> > Dan J
> > Subject: Re: [PATCH] md: Add ability for disable bad block management
> >=20
> > On Wed, 7 Dec 2011 11:10:06 +0000 "Kwolek, Adam"
> > <adam.kwolek@intel.com>
> > wrote:
> >=20
> > >
> > >
> > > > -----Original Message-----
> > > > From: NeilBrown [mailto:neilb@suse.de]
> >=20
> > > > I cannot reproduce this.
> > > > I didn't physically remove devices, but I used
> > > >    echo 1 > /sys/block/sdc/device/delete which should be nearly
> > > > identical from the perspective of md and mdadm.
> > >
> > > I've checked that when I'm deleting device using sysfs  everything wo=
rks
> > perfect.
> > > When when device is pulled out, reshape stops in md/mdstat.
> > >
> > > > If you could give me the exact set of steps that you follow to
> > > > produce the problem that would help - maybe a script?  Just a descr=
iption
> > is OK.
> > >
> > >
> > > #used disks sdb, sdc, sdd, sde
> > > export IMSM_NO_PLATFORM=3D1
> > > #create container
> > > mdadm -C /dev/md/imsm0 -amd -e imsm -n 3 /dev/sdb /dev/sdc /dev/sde
> > -R
> > > #create vol mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 32 --size
> > > 104850 -n 3 /dev/sdb /dev/sdc /dev/sde -R #add spare mdadm --add
> > > /dev/md/imsm0 /dev/sdd #run OLCE mdadm --grow /dev/md/imsm0
> > > --raid-devices 4 #when reshape starts, I'm (physically) pulling device
> > > out
> > >
> > > > Also you say it is blocking in md_do_sync.  Is that at the
> > > >
> > > > 	wait_event(mddev->recovery_wait, !atomic_read(&mddev-
> > > > >recovery_active));
> > > >
> > > > call just after the "out:" label?
> > >
> > > None of those 2 places.
> > > It enters sync_request() function. Md_error() is called.
> > > More is visible on thread stack information below
> > (md_wait_for_blocked_rdev()).
> > >
> > >
> > > >
> > > > What is the raid thread doing at this point?
> > > >    cat /proc/PID/stack
> > > > might help.
> > >
> > > [md126_raid5]
> > > [<ffffffff8121d843>] md_wait_for_blocked_rdev+0xbc/0x10f
> > > [<ffffffffa01d87ce>] handle_stripe+0x1c5c/0x2c99 [raid456]
> > > [<ffffffffa01d9d0d>] raid5d+0x502/0x564 [raid456] [<ffffffff8121eca5>]
> > > md_thread+0x101/0x11f [<ffffffff81049e0e>] kthread+0x81/0x89
> > > [<ffffffff812cc4f4>] kernel_thread_helper+0x4/0x10
> > > [<ffffffffffffffff>] 0xffffffffffffffff
> > >
> > > [md126_reshape]
> > > [<ffffffffa02455a2>] sync_request+0x90a/0xbfb [raid456]
> > > [<ffffffff8121e151>] md_do_sync+0x7aa/0xc40 [<ffffffff8121ecb3>]
> > > md_thread+0x101/0x11f [<ffffffff81049e0e>] kthread+0x81/0x89
> > > [<ffffffff812cc4f4>] kernel_thread_helper+0x4/0x10
> > > [<ffffffffffffffff>] 0xffffffffffffffff
> > >
> > > >
> > > > What are the contents of all the sysfs files?
> > > >    grep . /sys/block/mdXXX/md/*
> > > array_state		->active
> > > degraded		->1
> > > max_read_errors	->20
> > > reshape_position	->12288
> > > resync_start		->none
> > > sync_completed	->4096 / 209664
> > >
> > >
> > > >    grep . /sys/block/mdXXX/md/dev-*/*
> > >
> > > When removed is sdd   /sys/block/mdXXX/md/dev-sdd/*
> > > bad_blocks		->4096 512
> > > 			->4608 128
> > > 			->4736 384
> > > block			->MISSING link is not valid
> > > errors			->0
> > > offset			->0
> > > recovery_start		->4096
> > > size			->104832
> > > slot			->3
> > > state			->faulty,write_error
> > > unacknowledged_bad_blocks	->4096 512
> > > 				->4608 128
> > > 				->4736 384
> > >
> > > I hope this helps.
> >=20
> > Yes it does, thanks.
> >=20
> > Can you try with this patch as well please.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index ea6dce9..6cf=
0f6a
> > 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3175,6 +3175,8 @@ static void analyse_stripe(struct stripe_head *sh,
> > struct stripe_head_state *s)
> >  			rdev =3D rcu_dereference(conf->disks[i].rdev);
> >  			clear_bit(R5_ReadRepl, &dev->flags);
> >  		}
> > +		if (rdev && test_bit(Faulty, &rdev->flags))
> > +			rdev =3D NULL;
> >  		if (rdev) {
> >  			is_bad =3D is_badblock(rdev, sh->sector,
> > STRIPE_SECTORS,
> >  					     &first_bad, &bad_sectors);
>=20
> I've didn't succeed with this patch only, but when I've switch to newest =
md from today's neil_for-linus branch things went better.
> During migration it seems that it is OK.
>=20
> Problems are when during rebuild/resync additional disk is failed (physic=
al pull). Metadata react correctly (mdadm/mdmon) but md stops again. This t=
ime:
> =20
> [md126_resync]
> [<ffffffffa027037d>] get_active_stripe+0x295/0x598 [raid456]
> [<ffffffffa02757da>] sync_request+0xb1c/0xba7 [raid456]
> [<ffffffff8121e656>] md_do_sync+0x772/0xbc4
> [<ffffffff8121f174>] md_thread+0x101/0x11f
> [<ffffffff81049ebe>] kthread+0x81/0x89
> [<ffffffff812cc934>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> Thread [md126_raid5] is missing, but in mdstat raid5 resync/rebuild is vi=
sible
> During initialization one time it was executed correctly, second time it =
stops exactly as rebuild in get_active_stripe() and [md126_raid5] thread wa=
s missing also.
> Any 'mdadm -Ss' causes system hung (not very  surprising without raid5 th=
read)
>=20
> In /var/log/messages we have:
> Dec  8 12:39:49 gklab-128-013 kernel: Modules linked in: raid456 async_pq=
 async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx ext2 nvidia=
(P) snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ipv6 af_packet cpufreq=
_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microc=
ode fuse loop dm_mod snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd=
_hda_codec snd_hwdep snd_pcm snd_timer snd intel_agp iTCO_wdt tpm_tis tpm s=
oundcore e100 pcspkr mii tpm_bios snd_page_alloc sr_mod cdrom serio_raw i2c=
_i801 i2c_core iTCO_vendor_support sg intel_gtt button agpgart usbhid hid u=
hci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_common edd ext3 mbcache jbd =
fan processor ide_pci_generic ide_core ata_generic ahci libahci pata_marvel=
l libata scsi_mod thermal thermal_sys hwmon
> Dec  8 12:39:49 gklab-128-013 kernel:=20
> Dec  8 12:39:49 gklab-128-013 kernel: Pid: 4584, comm: md126_raid5 Tainte=
d: P             3.2.0-rc1-SLE11_BRANCH_ADK #10                  /DP35DP
> Dec  8 12:39:49 gklab-128-013 kernel: RIP: 0010:[<ffffffffa0280e67>]  [<f=
fffffffa0280e67>] handle_stripe+0x2f5/0x2cbf [raid456]
> Dec  8 12:39:49 gklab-128-013 kernel: RSP: 0018:ffff8800d61cdb80  EFLAGS:=
 00010002
> Dec  8 12:39:49 gklab-128-013 kernel: RAX: 0000000000008001 RBX: 00000000=
00000000 RCX: 0000000000000002
> Dec  8 12:39:49 gklab-128-013 kernel: RDX: 0000000000000000 RSI: ffff8801=
14462800 RDI: ffff8801144629a8
> Dec  8 12:39:49 gklab-128-013 kernel: RBP: ffff8800d61cdd40 R08: ffff8800=
379256c0 R09: 0000000300000000
> Dec  8 12:39:49 gklab-128-013 kernel: R10: ffff88010e5bfa00 R11: 00000001=
00000001 R12: ffff8800372602c8
> Dec  8 12:39:49 gklab-128-013 kernel: R13: ffff880037260048 R14: ffff8800=
372602d0 R15: ffff8801144638b0
> Dec  8 12:39:49 gklab-128-013 kernel: FS:  0000000000000000(0000) GS:ffff=
88011bc00000(0000) knlGS:0000000000000000
> Dec  8 12:39:49 gklab-128-013 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00=
0000008005003b
> Dec  8 12:39:49 gklab-128-013 kernel: CR2: 00000000000000b0 CR3: 00000000=
379b3000 CR4: 00000000000006f0
> Dec  8 12:39:49 gklab-128-013 kernel: DR0: 0000000000000000 DR1: 00000000=
00000000 DR2: 0000000000000000
> Dec  8 12:39:49 gklab-128-013 kernel: DR3: 0000000000000000 DR6: 00000000=
ffff0ff0 DR7: 0000000000000400
> Dec  8 12:39:49 gklab-128-013 kernel: Process md126_raid5 (pid: 4584, thr=
eadinfo ffff8800d61cc000, task ffff88003715a7c0)
> Dec  8 12:39:49 gklab-128-013 kernel: Stack:
> Dec  8 12:39:49 gklab-128-013 kernel:  0000000000000000 0000000000000000 =
0000000000000000 0000000000000000
> Dec  8 12:39:49 gklab-128-013 kernel:  0000000000000000 0000000000000000 =
0000000000000000 0000000000000000
> Dec  8 12:39:49 gklab-128-013 kernel:  0000000000000400 0000000000000400 =
0000000300000000 ffff88010e749280
> Dec  8 12:39:49 gklab-128-013 kernel: Call Trace:
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffff81221fd4>] ? md_check_re=
covery+0x60d/0x630
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffffa027ef28>] ? __release_s=
tripe+0x174/0x18f [raid456]
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffffa0283d33>] raid5d+0x502/=
0x564 [raid456]
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffff812c3e6c>] ? schedule_ti=
meout+0x35/0x1e8
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffff8121f174>] md_thread+0x1=
01/0x11f
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffff8104a2ad>] ? wake_up_bit=
+0x23/0x23
> Dec  8 12:39:49 gklab-128-013 kernel:  [<ffffffff8121f073>] ? md_register=
_thread+0xd6/0xd6
> Dec  8 12:39:50 gklab-128-013 kernel:  [<ffffffff81049ebe>] kthread+0x81/=
0x89
> Dec  8 12:39:50 gklab-128-013 kernel:  [<ffffffff812cc934>] kernel_thread=
_helper+0x4/0x10
> Dec  8 12:39:50 gklab-128-013 kernel:  [<ffffffff81049e3d>] ? kthread_wor=
ker_fn+0x145/0x145
> Dec  8 12:39:50 gklab-128-013 kernel:  [<ffffffff812cc930>] ? gs_change+0=
xb/0xb
> Dec  8 12:39:50 gklab-128-013 kernel: Code: 75 11 49 8b 45 30 48 83 c0 08=
 48 3b 83 e0 00 00 00 77 07 f0 41 80 4c 24 08 08 49 8b 44 24 08 66 85 c0 79=
 2c f0 41 80 64 24 08 f7=20
> Dec  8 12:39:50 gklab-128-013 kernel: <48> 8b 83 b0 00 00 00 a8 02 75 10 =
c7 45 80 01 00 00 00 f0 ff 83=20
> Dec  8 12:39:50 gklab-128-013 kernel: RIP  [<ffffffffa0280e67>] handle_st=
ripe+0x2f5/0x2cbf [raid456]
> Dec  8 12:39:50 gklab-128-013 kernel:  RSP <ffff8800d61cdb80>
> Dec  8 12:39:50 gklab-128-013 kernel: CR2: 00000000000000b0
>=20
>=20
> The problem is caused by access to just cleaned rdev a few lines below in=
 raid5.c.
>  The following patch corrects it.
>=20
> >From fbaa3fdff634721e5c2c09e07b8429385494ee02 Mon Sep 17 00:00:00 2001
> From: Adam Kwolek <adam.kwolek@intel.com>
> Date: Thu, 8 Dec 2011 15:34:09 +0100
> Subject: [PATCH] md: raid5 crash during degradation
>=20
> NULL pointer access causes crash in raid5 module.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Ahh, thanks.  Obvious once you see it :-)

Thanks,
I've sent this and the other fixes off to Linus.


NeilBrown


> ---
>  drivers/md/raid5.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b0dec01..da4997c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3070,7 +3070,7 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>  			if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
>  				set_bit(R5_Insync, &dev->flags);
>  		}
> -		if (test_bit(R5_WriteError, &dev->flags)) {
> +		if (test_bit(R5_WriteError, &dev->flags) && rdev) {
>  			clear_bit(R5_Insync, &dev->flags);
>  			if (!test_bit(Faulty, &rdev->flags)) {
>  				s->handle_bad_blocks =3D 1;
> @@ -3078,7 +3078,7 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>  			} else
>  				clear_bit(R5_WriteError, &dev->flags);
>  		}
> -		if (test_bit(R5_MadeGood, &dev->flags)) {
> +		if (test_bit(R5_MadeGood, &dev->flags) && rdev) {
>  			if (!test_bit(Faulty, &rdev->flags)) {
>  				s->handle_bad_blocks =3D 1;
>  				atomic_inc(&rdev->nr_pending);


--Sig_/uWWaovcPwii6uPW/./RwcKC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuGGKznsnt1WYoG5AQJ2Bg/+NZqpJAsD+AhTdtfVlzZvkYef1L+1rgag
Zt/zhBG5WlB2bioqC07OEq4MJEHDsE90xIt1rXOEwc4wMkfEWkpclTXIIzBIM8SZ
KW9OSpjLhmDl5iwKR9XBySFwR386fvJtI/89YZOgz0nv/7Q5mNsKoahQjFkDrlxv
/Ho1CFtdRPJOYwTefWzjvc0G8UnjwIpPIVh5m8YESqOttvpxnrD6wp5XNcpAnFzn
eCZ5Wo4ewfGgQ/+2nbFY0jZMZR3TphUsf0u3UL1/4kTYDb+8noCpxWKBZ2digevv
k/kSgHRgEkFGbq2PgGqZy7ABaMYN+7yBsjYqloEKsODXEgx4WnRULZyxamG+LY8H
DyhFdr6twB2RINEGo7rze0KOFhXm3ztb5TPPTVCI74GoeAYJZ2B2NAqiypCXiarE
2lEjV9g26YWBgR+t9iR/1+Ce2ELuqG9ok/wE38aioXOEIG43xnX19/RS4fZ56qF6
+x/f0ldda2+pxR6sKN1W4lacoDeFDtlNiatji3Uk5Y/fmTcRPWQsc56anGsVfLvx
n1Z5vF0WHR7WFP/BoirqCEq9hSJmBqEJ6skP/u4s33FlLOQNbnpXpAuqsumDa3mm
IXAb3QmbWjp+MIIzTwimLgGvkGLR8/z8dMQbByAM9vc+to4Us2JwjkDI7cdwzzio
onxTp2EqeHM=
=xaLN
-----END PGP SIGNATURE-----

--Sig_/uWWaovcPwii6uPW/./RwcKC--
