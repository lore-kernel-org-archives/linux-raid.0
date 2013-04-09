From: NeilBrown <neilb@suse.de>
Subject: Re: Suggested use of --invalid-backup?
Date: Tue, 9 Apr 2013 14:28:56 +1000
Message-ID: <20130409142856.6007253c@notabene.brown>
References: <CAPSPcXjRvY-1tCH2CFPOWcNbRZBOCReZqmT4WPdAcbSECreN=w@mail.gmail.com>
	<CAPSPcXiwJNf9iqgQFt0qbyz-QaUF9sR+FeDe4WwLBL4SqtT=Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8SqazmIo1tfXQ/upzLP1kNK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXiwJNf9iqgQFt0qbyz-QaUF9sR+FeDe4WwLBL4SqtT=Sg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8SqazmIo1tfXQ/upzLP1kNK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Apr 2013 14:13:31 -0500 Barrett Lewis
<barrett.lewis.mitsi@gmail.com> wrote:

> As much as I hate to bump, are there no thoughts on this?
>=20
> The most important question is if I have a possibly corrupted version
> of a backup file, should I supply it with the --invalid-backup flag?
> Or does that expect a blank file only?
>=20
> On Tue, Apr 2, 2013 at 3:20 PM, Barrett Lewis
> <barrett.lewis.mitsi@gmail.com> wrote:
> > I was reshaping a 5x2tb raid5 to a 6x2tb raid6.  Not knowing that
> > ubuntu deletes the /tmp/ folder each reboot, I specified my
> > --backup-file as /tmp/raid-backup.bak (this is not part of the array).
> >  At 15.1% the system hung sufficiently that REISUB and the reset
> > button were ignored and I had to hold the power button down to reset
> > the server.  After booting back from the crash, the array would not
> > start, and ubuntu had deleted the backup file (and everything else in
> > /tmp).
> >
> > The superblock already says it's raid6, all members are present and
> > the event counters are the same on all disks.  I tried
> >
> > ubuntu@ubuntu:~$ sudo mdadm --assemble --force --run --verbose
> > /dev/md0 /dev/sd[abcdef]
> > mdadm: looking for devices for /dev/md0
> > mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
> > mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> > mdadm: /dev/sdc is identified as a member of /dev/md0, slot 5.
> > mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> > mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
> > mdadm: /dev/sdf is identified as a member of /dev/md0, slot 1.
> > mdadm:/dev/md0 has an active reshape - checking if critical section
> > needs to be restored
> > mdadm: Failed to find backup of critical section
> > mdadm: Failed to restore critical section for reshape, sorry.
> >       Possibly you needed to specify the --backup-file
> >
> >
> > My understanding is that the backup file is only for some early
> > critical part of the reshape and that it isn=92t even used after that.
> > 15% into 8tb is well over a terrabyte so wouldn=92t that be far past any
> > filesystem metadata?  So what exactly is implied (about the state of
> > the reshape) by the fact that programmatically it is still requiring
> > the backup file?
> >
> > I have read the manpage on the --invalid-backup command but I didn't
> > clearly get "use it here, not here" type of information.  I have the
> > OS drive (with deleted /tmp/raid-backup.bak) in a data recovery
> > process.  If I actually get the backup file recovered, it could
> > potentially have corrupted bits.  Is the best course of action to:
> > Supply the (potentially corrupted, but maybe some percent ok)
> > recovered backup file as the legitimate backup file (without
> > --invalid-backup)? (could this be worse than --invalid-backup and a
> > blank file?)
> > Supply the (potentially corrupted) recovered backup file WITH --invalid=
-backup?
> > Supply --invalid-backup and an empty file?
> >
> > Or if I am on the wrong path, let me know of any other thoughts or
> > suggestions you might have.
> >
> > If I get nothing useful back from data recovery, and I have to supply
> > --invalid-backup with a blank file, considering the reshape made it to
> > 15%, how much chance is there that the array could assemble and resume
> > reshape?  I would gladly accept the corruption of some files vs losing
> > the whole file system (obviously).
> >

There is no risk in providing an backup file - if it doesn't look good it
will be ignored.

When md does an in-place reshape like this it:
  - read several stripes
  - writes them to the backup file
  - writes them back to the devices
  - updates the metadata

If your crash was during the "writes them back" section, then you will have
some corruption that you cannot avoid without having exactly the right back=
up
file.

With luck the corruption should be fairly limited.

There is nothing better that you can do then reassemble the array with the
best backup file you can find, and with --invalid-backup.  Then 'fsck' and =
do
whatever you can to validate your data.

NeilBrown

--Sig_/8SqazmIo1tfXQ/upzLP1kNK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUWOZCDnsnt1WYoG5AQIDGRAApStCHlDu0i84/gtoVC7dUrCi7QH4mUtp
gRgbk6yyxo3sx+xL6E5/c5vHRF/5po/Gwlm0fSMGykpoVab0d7nbV9cbVMeBo4Xs
VsHSI0xWtnsbZp3pV4SnhUraKry1vzRZ9hKAyJ/Bq3uUYACJ23ltdw2HBnotXF1v
SZoSWMkE+4YcTXtrGFitcNCOnh4CKZs0UFd2dLRoVPkqAH/k6Oom1xdf5K0trBr3
uKQI65Kd+72xG2/m6gOavfufzJo6clWtwhipfrn1qgZeJTWiL931JbEq+4jSyDxi
JvDHqf2B4u4Ha70QUYbw36vJZ2zEVLGD4QAwHNReqpiaf3aTIlv/awgTRA9X9JpW
gTYAB7PAl5mmD5K/rs4LvqMKRq5VcLTF3B8wAbCx7aF+ASixa3WL0cFAal1qT1tE
5vFHhKcqyjc1hXM85w4N8dCjhgP0rHh1ktX1SppCLXTvKDSJrAIEbDE11pQuHjqR
fAzw2Lm1DxnOmy91F6k6nmOYRdkRX3ScOmPa9//O+gknoGWwPkVfOAIxRLzdE29F
5l/K15mkd2SYaDiciVr5m/EdcCP6Imi533BVFbs6E2TOwvF2Sw/Zsz30rXLvL8Iw
OVMQgMZroQSUcMRXuhRYjk/eGz/hNS+3AmMimwKsCfZT9WxDG23sqVVNHj67Sj9q
jHiW0jM/l7I=
=0m2d
-----END PGP SIGNATURE-----

--Sig_/8SqazmIo1tfXQ/upzLP1kNK--
