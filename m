From: Jorg de Jong <lists@dejong.info>
Subject: Re: Raid5 resync freezes system
Date: Sat, 19 Apr 2003 11:32:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EA1179D.5080409@dejong.info>
References: <200304162322.46555.cleanerx@au.hadiko.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200304162322.46555.cleanerx@au.hadiko.de>
To: =?ISO-8859-1?Q?Jens_K=FCbler?= <cleanerx@au.hadiko.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jens K=FCbler wrote:
> Hello there
> Here is what I got:
>=20
> Abit KT7 Raid=20
> First IDE Controller is a Via
> Second IDE controller is a HPT370 just using the ide part and NOT THE=
 RAID=20
> PART of it
> Duron 750
> 192MB RAM (fully tested using memtest)
> Western Digital WDC WD1200BB-00CAA1 (120GB)
> Maxtor 4D080H4 (80GB)
> Maxtor 96147H6 (60GB)
> Maxtor 5T060H6 (60GB)
>=20
> using Mandrake 9.1 with Kernel 2.4.21-00
> before this Mandrake 9.0 with kernel 2.4.19
>=20
> Each disk parts with 60GB in the software raid5 array.
>=20
> If I create the array, the system starts to resync the four disks. Af=
ter an=20
> arbitrary time the resync freezes the system. I have tried to create =
an array=20
> with only three of the disks to exclude any damaged hd, I have switch=
ed ide=20
> ports and there was still no effect. Then I played a bit with the=20
> /proc/sys/dev/raid/  values and lowered the max_value as I thought th=
is could=20
> be due to heavy IO load which was at 12MB. First I reduced it to 5MB/=
s but it=20
> was still crashing. The test with 2MB/s is currently underway.
> During these many resyncs I've seen so far the speed sometimes stayed=
 at 4MB/s=20
> without having any IO on the system.=20
> The computer itself is well cooled espacially the harddisks.
>=20
> If the system does not crash during boot (it is also starting the res=
ync=20
> there) I will shut down the device and the system is stable even if I=
 create=20
> some heavy IO load.
>=20
> The reiserfs I created seems to have nothing to do with these crashes=
 as they=20
> occured with and without the created file system.
>=20
> In hope of help.
>=20
> Jens

Hi Jens,

what you describe sound very mutch what I am experiencing as well.

My setup is:
MSI K7D ( SMP board with two AMD MP2000 cpu's)
1 Gig ram (fully memtested)
1st onbord ide controler
2nd ide controler RocketRAID 404 controler ( is a HPT374 just using the
ide part and NOT THE RAID) (running at 66 MHZ)
3rd ide controler promise PDC20267 ( running at 33 MHZ)
3 identical seagate ST360021A 60 Gb (part of raid array)
1 seagate ST360015A 60 Gb ( part of raid array)
1 seagate ST340823A contains root filesystem always connected to 1st id=
e controler

running RedHat 8.0 kernel 2.4.18-27.8.0smp ( and other redhat rolled ke=
rnels)

Setup where all raid disk are connected to HPT374 controller:
When the raid array is synced this setup seems stable, althow I see ran=
dom lockups
about once a month. If the raid array needs syncing it almost never com=
pleets. I see
lockups during boot, during starting of X-windows, after 15 minutes upt=
ime, ect.
I also had a disk that contained bad sectors. During raid reconstructio=
n this was
never reported. After replacing the bad disk, the array still would not=
 reconstruct.
I did not have the impression IO-load had anything to do with it. Even =
in
single user mode it would lockup. On other occasions I could do heavy I=
O-load during
reconstruction without the system being locked up.

I therfore switched backt to a setup were all raid disk where connected=
 to the
PDC20267 controller.
Only in this setup my bad disk was dectected and thrown out of the raid=
 array.
After replacing the bad disk the raid array was reconstructed successfu=
lly.
I cant say I have never experienced lockups in this setup but feels mut=
ch more stable.


In all setups I use mostly reiserfs on top of LVM on top of a raid5 md.
I to feel that reiserfs and LVM have noting to do with it since lockups=
 occur
even in single usermode where the filesystems where not mounted and LVM=
 was not
loaded.

After reading about your problems and seeing the you also use a HighPoi=
nt controller
is would suspect that it might be that the HighPoint controller is to b=
lame ?!


regards,

Jorg de Jong










-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
