From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 13:01:29 +0100
Message-ID: <201103191301.29514.xavier@alternatif.org>
References: <201103181549.20835.xavier@alternatif.org> <201103182350.19281.xavier@alternatif.org> <20110319102039.52cc2282@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110319102039.52cc2282@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le samedi 19 mars 2011 00:20:39, NeilBrown  =E9crivait :
> On Fri, 18 Mar 2011 23:50:18 +0100 Xavier Brochard <xavier@alternatif=
=2Eorg>
> > Le vendredi 18 mars 2011 23:22:51, NeilBrown  =E9crivait :
> > > On Fri, 18 Mar 2011 21:12:49 +0100 Xavier Brochard
> > > > Le vendredi 18 mars 2011 18:22:34 hansbkk@gmail.com, vous avez =
=E9crit :
> > > > > On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard
> > > > > > disk order is mixed between each boot - even with live-cd.
> > > > > > is that normal?
> > > > >=20
> > > > > If nothing is changing and the order is swapping really every=
 boot,
> > > > > then IMO that is odd.
> > > >=20
> > > > nothing has changed, except kernel minor version
> > >=20
> > > Yet you don't tell us what the kernel minor version changed from =
or to.
> >=20
> > Previously it was ubuntu 2.6.32-27-server or 2.6.32-28-server and n=
ow it
> > is ubuntu 2.6.32-29.58-server 2.6.32.28+drm33.13
> >=20
> > > That may not be important, but it might and you obviously don't k=
now
> > > which. It is always better to give too much information rather th=
an
> > > not enough.

> > Here's full output of mdadm --examine /dev/sd[cdefg]1
> > As you can see, disks sdc, sdd and sde claims to be different, is i=
t a
> > problem?
>=20
> Where all of these outputs collected at the same time?  They seem
> inconsistent.
>=20
> In particular, sdc1 has a higher 'events' number than the others (154=
 vs
> 102) yet an earlier Update Time.  It also thinks that the array is
> completely failed.
> So I suspect that device is badly confused and you probably want to z=
ero
> it's metadata ... but don't do that too hastily.
>=20
> All the other devices think the array is working correctly with a ful=
l
> compliment of devices.  However there is no device which claims to
> be "RaidDevice 2" - except sdc1 and it is obviously confused..
>=20
> The device name listed in the table at the end of --examine output.
> It is the name that the device had when the metadata was last written=
=2E  And
> device names can change on reboot.
> The fact that the names don't line up suggest that the metadata hasn'=
t been
> written since the last reboot - so presumably you aren't really using=
 the
> array.(???)

The array was in use 24/24.
But the last reboot using it  was after the first error (I described it=
=20
extensively in wednesday email). As I first thought it was a file syste=
m error,=20
I've launched fsck to check the /tmp FS with fsck /dev/mapper/tout-tmp =
(it is=20
a Raid10 + lvm setup).=20
Can it be the reason for the metadata not written?

> [the newer 1.x metadata format doesn't try to record the names of dev=
ices
> in the superblock so it doesn't result in some of this confusion).

Yes it's really confusing:
the SAS/SATA controler card gives "numbers" for the hard drives
which doesn't correspond to the /dev/sd? names=20
which doesn't correspond to the drive numer in the array
etc.

> Based on your earlier email, it would appear that the device discover=
y for
> some of your devices is happening in parallel at boot time, so or ord=
ering
> could be random - each time you boot you get a different order.  This=
 will
> not confuse md or mdadm - they look at the content of the devices rat=
her
> than the name.

ok, thanks for making it very clear

> If you want a definitive name for each device, it might be a good ide=
a to
> look in /dev/disk/by-path or /dev/disk/by-id and use names from there=
=2E

I think I can't:=20
With System Rescue CD (2.6.35-std163-amd64 kernel) I have only one path=
=20
available:
pci-0000:00:14.1-scsi-0:0:0:0
which, according to lspci, is not the LSI sas/sata controler, but the I=
DE=20
interface:
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
While the LSI controler is at
01:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2=
008=20
PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)

This make me a bit anxious to start the raid recovery!


Xavier
xavier@alternatif.org - 09 54 06 16 26
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
