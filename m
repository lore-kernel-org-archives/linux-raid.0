From: Jens Benecke <jens@spamfreemail.de>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 05 Aug 2004 08:16:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cesjcm$9da$1@sea.gmane.org>
References: <ceq7ij$vj7$1@sea.gmane.org> <27897.194.60.85.4.1091613610.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:

> On Wed, August 4, 2004 9:42, Jens Benecke said:
>> I'm planning to set up a new RAID mirrored system with the above spe=
cs.
>> Both disks are master (hda and hdc). I'm currently trying to decide
>> between LVM2 (is it in 2.4 already?), MD, and a "manual" nightly rsy=
nc
>> onto the second disk.
>=20
> I use md and mdadm on Fedora Core 2. What distro are you contemplatin=
g?

Hi,

see subject (Debian). I've looked at SuSE though, it seems with their s=
etup
RAID and ReiserFS is much easier to handle. I'm running SuSE at home th=
ough
and the sheer number of security updates that come in kind of make me a=
 bit
uneasy for an internet server.
=20
>> How about RAIDing the root partition? If one drive fails will the ot=
her
>> be able to boot via LILO? How about GRUB? Which do you prefer?
>=20
> I have my root partition on a RAID1 mirror. I use grub and have
> "installed" grub to both mirrored drives so I can boot off either, e.=
g. if
> one fails. That reminds me, I must test this.

That's exactly what I want.
 =20
>> How about (/var)/tmp? I (suppose I'll) need it on both disks, does i=
t
>> make sense to mirror it as well?
>=20
> You *could* put /var/tmp or /tmp on separate partitions either mirror=
ed or
> not, but if you want to keep things "stress free" I would keep /var/t=
mp
> and /tmp on the root partition.

No. I don't want a rogue script to fill up my root partition.
=20
>> Can I mirror the whole disk? Or do I need to mirror each partition
>> seperately?
>=20
> You can do either. You mirror the disk using md and can then either c=
reate
> a filesystem on the whole disk, or use lvm to create logical volumes
> within the md device.

Hm... I thought LVM did mirroring and striping as well? I didn't think =
you
can or should use them together. Wouldn't that degrade performance as w=
ell?
=20
>> Does MD or LVM2 do hot sync, i.e. if one drive fails will I be able =
to
>> stick in a replacement, and stop worrying? Or do I need to repartiti=
on
>> the new disk exactly as the old one, before being able to sync?
>=20
> I'm not sure about this. My understanding is that you will need to
> shutdown the system to replace the bad disk and partition the new dis=
k
> manually before md will resync, but this could be wrong.

What I mean is, will md resync automatically or would I have to initiat=
e
this manually?
=20
> I have six 250GB SATA disks, all partitioned identically with two
> partitions of 1.5GB and 248.5 GB. I have them configured as RAID devi=
ces
> using md follows:

I think you mean 1.5TB. :-)
=20
> md0   sda1 + sdd1    RAID1    1.5GB   root filesystem
> md2   sdb1 + sde1    RAID1    1.5GB   swap 1
> md3   sdc1 + sdf1    RAID1    1.5GB   currently not used
> md5   sd[abcdef]2    RAID5    994GB   lvm2 volume group (4+1+spare)
>=20
> Then within the lvm2 volume group I have the following logical volume=
s:
>=20
> dude_usr   10GB     /usr
> dude_var   5GB      /var
> dude_home  979GB    /home
>=20
> I did my initial install just to the mirrored root parition . Once I =
had
> done the initial install I set up the lvm2 array and volumes and migr=
ated
> /usr and /var over.
>=20
> It's working great so far.

This setup seems quite complicated. Did you test the setup, ie. removed=
 one
of the MD disks and looked what happened?
=20
>> The goal is to have as "stress free" a system as possible - i.e. wit=
h as
>> little manual configuration, and in event of emergencies, as little =
work
>> to do, as possible.
>=20
> If you want stress free, buy a Netapps storage appliance ;o)

If they do all the rest that I need (smtp, web, file server, ftp server=
,
mysql, spamassassin, etc etc etc) fine. If not, I'd need to set up anot=
her
box anyway, so I wouldn't see the advantage.


--=20
Jens Benecke
http://www.hitchhikers.de - Europas kostenlose Mitfahrzentrale seit 199=
8
http://www.rb-hosting.de - Webhosting mit Extras - PHP ab =A49 - SSH ab=
 =A419
http://www.spamfreemail.de - 100% saubere Postf=E4cher, garantiert!

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
