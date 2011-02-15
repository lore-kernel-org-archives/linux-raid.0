From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Tue, 15 Feb 2011 09:51:31 -0500
Message-ID: <4D5A92F3.1090004@turmel.org>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215155315.55d35b8e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: simonmcnair@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Since Simon has responded, let me summarize the assistance I provided p=
er his off-list request:

On 02/14/2011 11:53 PM, NeilBrown wrote:
> On Thu, 10 Feb 2011 16:16:44 +0000 Simon McNair <simonmcnair@gmail.co=
m> wrote:
>=20
>>
>> Hi all
>>
>> I use a 3ware 9500-12 port sata card (JBOD) which will not work with=
out a
>> 128mb sodimm.  The sodimm socket is flakey and the result is that th=
e
>> machine occasionally crashes.  Yesterday I finally gave in and put=20
>> together another
>> machine so that I can rsync between them.  When I turned the machine
>> on today to set up rync, the RAID array was not gone, but corrupted.=
=20
>>   Typical...
>=20
> Presumably the old machine was called 'ubuntu' and the new machine 'p=
ro=C3=B8lox'
>=20
>=20
>>
>> I built the array in Aug 2010 using the following command:
>>
>> mdadm --create --verbose /dev/md0 --metadata=3D1.1 --level=3D5
>> --raid-devices=3D10 /dev/sd{b,c,d,e,f,g,h,i,j,k}1 --chunk=3D64
>>
>> Using LVM, I did the following:
>> pvscan
>> pvcreate -M2 /dev/md0
>> vgcreate lvm-raid /dev/md0
>> vgdisplay lvm-raid
>> vgscan
>> lvscan
>> lvcreate -v -l 100%VG -n RAID lvm-raid
>> lvdisplay /dev/lvm-raid/lvm0
>>
>> I then formatted using:
>> mkfs -t ext4 -v -m .1 -b 4096 -E stride=3D16,stripe-width=3D144=20
>> /dev/lvm-raid/RAID
>>
>> This worked perfectly since I created the array.  Now mdadm is comin=
g up=20
>> with
>>
>> proxmox:/dev/md# mdadm --assemble --scan --verbose
>> mdadm: looking for devices for further assembly
>> mdadm: no recogniseable superblock on /dev/md/ubuntu:0
>=20
> And it seems that ubuntu:0 have been successfully assembled.
> It is missing one device for some reason (sdd1) but RAID can cope wit=
h that.

3ware card is compromised, with a loose buffer memory dimm.  Some of it=
s ECC errors were caught and reported in dmesg.  Its likely, based on t=
he loose memory socket, that many multiple-bit errors got through.

[trim /]

>> mdadm: no uptodate device for slot 8 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 9 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: failed to add /dev/sdd1 to /dev/md/pro=EF=BF=BDlox:0: Invalid=
 argument
>> mdadm: /dev/md/pro=EF=BF=BDlox:0 assembled from 0 drives - not enoug=
h to start
>> the array.
>=20
> This looks like it is *after* to trying the --create command you give
> below..  It is best to report things in the order they happen, else y=
ou can
> confuse people (or get caught out!).

Yes, this was after.

>> mdadm: looking for devices for further assembly
>> mdadm: no recogniseable superblock on /dev/sdd
>> mdadm: No arrays found in config file or automatically
>>
>> pvscan and vgscan show nothing.
>>
>> So I tried running mdadm --create --verbose /dev/md0 --metadata=3D1.=
1
>> --level=3D5 --raid-devices=3D10 missing /dev/sde1 /dev/sdf1 /dev/sdg=
1
>> /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 --chunk=3D=
64
>>
>> as it seemed that /dev/sdd1 failed to be added to the array.  This d=
id=20
>> nothing.
>=20
> It did not to nothing.  It wrote a superblock to /dev/sdd1 and compla=
ined
> that it couldn't write to all the others --- didn't it?

There were multiple attempts to create.  One wrote to just sdd1, anothe=
r succeeded with all but sdd1.

>> dmesg contains:
>>
>> md: invalid superblock checksum on sdd1
>=20
> I guess that is why sdd1 was missing from 'ubuntu:0'.  Though as I ca=
nnot
> tell if this happened before or after any of the various things repor=
ted
> above, it is hard to be sure.
>=20
>=20
> The  real mystery is why 'pvscan' reports nothing.

The original array was created with mdadm v2.6.7, and had a data offset=
 of 264 sectors.  After Simon's various attempts to --create, he ended =
up with data offset of 2048, using mdadm v3.1.4.  The mdadm -E reports =
he posted to the list showed the 264 offset.  We didn't realize the off=
set had been updated until somewhat later in our troubleshooting effort=
s.

In any case, pvscan couldn't see the LVM signature because it wasn't th=
ere (at offset 2048).

> What about
>   pvscan --verbose
>=20
> or
>=20
>   blkid -p /dev/md/ubuntu:0
>=20
> or even
>=20
>   dd of=3D/dev/md/ubuntu:0 count=3D8 | od -c=20

=46ortunately, Simon did have a copy of his LVM configuration.  With th=
e help of dd, strings, and grep, we did locate his LVM sig at the corre=
ct location on sdd1 (for data offset 264).  After a number of attempts =
to bypass LVM and access his single LV with dmsetup (based on his backe=
d up configuration, on the assembled new array less sdd1), I realized t=
hat the data offset was wrong on the recreated array, and went looking =
for the cause.  I found your git commit that changed that logic last sp=
ring, and recommended that Simon revert to the default package for his =
ubuntu install, which is v2.6.7.

Simon has now attempted to recreate the array with v2.6.7, but the cont=
roller is throwing too many errors to succeed, and I suggested it was t=
oo flakey to trust any further.  Based on the existence of the LVM sig =
on sdd1, I believe Simon's data is (mostly) intact, and only needs a su=
ccessful create operation with a properly functioning controller.  (He =
might also need to perform an lvm vgcfgrestore, but he has the necessar=
y backup file.)

A new controller is on order.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
