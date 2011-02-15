From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Tue, 15 Feb 2011 08:48:23 +0000
Message-ID: <4D5A3DD7.6050606@gmail.com>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215155315.55d35b8e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neal,
Thanks for the response.  Phil Turmel has been giving me some kind=20
assistance.  After some investigation we have found that the 3ware card=
=20
I'm using as a controller (as JBOD) is making the whole thing far too=20
flakey and providing some data corruption (hopefully not for too long).=
 =20
Thankfully this is mainly a data archive so the data changes very=20
infrequently.  I have ordered a Supermicro 8 port sata controller and=20
intend to use that, in conjunction with the 6 onboard sata ports to try=
=20
and get the array back in shape.  Some seriously bad stuff has happened=
,=20
so I'm hoping the data is still retrievable.

I'll cc the latest update to the list.  Any input you can provide would=
=20
be seriously welcome.

regards
Simon

On 15/02/2011 04:53, NeilBrown wrote:
> On Thu, 10 Feb 2011 16:16:44 +0000 Simon McNair<simonmcnair@gmail.com=
>  wrote:
>
>> Hi all
>>
>> I use a 3ware 9500-12 port sata card (JBOD) which will not work with=
out a
>> 128mb sodimm.  The sodimm socket is flakey and the result is that th=
e
>> machine occasionally crashes.  Yesterday I finally gave in and put
>> together another
>> machine so that I can rsync between them.  When I turned the machine
>> on today to set up rync, the RAID array was not gone, but corrupted.
>>    Typical...
> Presumably the old machine was called 'ubuntu' and the new machine 'p=
ro=C3=B8lox'
>
>
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
>> mkfs -t ext4 -v -m .1 -b 4096 -E stride=3D16,stripe-width=3D144
>> /dev/lvm-raid/RAID
>>
>> This worked perfectly since I created the array.  Now mdadm is comin=
g up
>> with
>>
>> proxmox:/dev/md# mdadm --assemble --scan --verbose
>> mdadm: looking for devices for further assembly
>> mdadm: no recogniseable superblock on /dev/md/ubuntu:0
> And it seems that ubuntu:0 have been successfully assembled.
> It is missing one device for some reason (sdd1) but RAID can cope wit=
h that.
>
>
>
>> mdadm: cannot open device /dev/dm-2: Device or resource busy
>> mdadm: cannot open device /dev/dm-1: Device or resource busy
>> mdadm: cannot open device /dev/dm-0: Device or resource busy
>> mdadm: cannot open device /dev/sdm1: Device or resource busy
>> mdadm: cannot open device /dev/sdm: Device or resource busy
>> mdadm: cannot open device /dev/sdl1: Device or resource busy
>> mdadm: cannot open device /dev/sdl: Device or resource busy
>> mdadm: cannot open device /dev/sdk1: Device or resource busy
>> mdadm: cannot open device /dev/sdk: Device or resource busy
>> mdadm: cannot open device /dev/sdj1: Device or resource busy
>> mdadm: cannot open device /dev/sdj: Device or resource busy
>> mdadm: cannot open device /dev/sdh1: Device or resource busy
>> mdadm: cannot open device /dev/sdh: Device or resource busy
>> mdadm: cannot open device /dev/sdi1: Device or resource busy
>> mdadm: cannot open device /dev/sdi: Device or resource busy
>> mdadm: cannot open device /dev/sdg1: Device or resource busy
>> mdadm: cannot open device /dev/sdg: Device or resource busy
>> mdadm: cannot open device /dev/sdf1: Device or resource busy
>> mdadm: cannot open device /dev/sdf: Device or resource busy
>> mdadm: cannot open device /dev/sde1: Device or resource busy
>> mdadm: cannot open device /dev/sde: Device or resource busy
>> mdadm: no RAID superblock on /dev/sdd
>> mdadm: cannot open device /dev/sda2: Device or resource busy
>> mdadm: cannot open device /dev/sda1: Device or resource busy
>> mdadm: cannot open device /dev/sda: Device or resource busy
>> mdadm: /dev/sdd1 is identified as a member of /dev/md/pro=EF=BF=BDlo=
x:0, slot 0.
>> mdadm: no uptodate device for slot 1 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 2 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 3 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 4 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 5 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 6 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 7 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 8 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: no uptodate device for slot 9 of /dev/md/pro=EF=BF=BDlox:0
>> mdadm: failed to add /dev/sdd1 to /dev/md/pro=EF=BF=BDlox:0: Invalid=
 argument
>> mdadm: /dev/md/pro=EF=BF=BDlox:0 assembled from 0 drives - not enoug=
h to start
>> the array.
> This looks like it is *after* to trying the --create command you give
> below..  It is best to report things in the order they happen, else y=
ou can
> confuse people (or get caught out!).
>
>
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
id
>> nothing.
> It did not to nothing.  It wrote a superblock to /dev/sdd1 and compla=
ined
> that it couldn't write to all the others --- didn't it?
>
>
>> dmesg contains:
>>
>> md: invalid superblock checksum on sdd1
> I guess that is why sdd1 was missing from 'ubuntu:0'.  Though as I ca=
nnot
> tell if this happened before or after any of the various things repor=
ted
> above, it is hard to be sure.
>
>
> The  real mystery is why 'pvscan' reports nothing.
>
> What about
>    pvscan --verbose
>
> or
>
>    blkid -p /dev/md/ubuntu:0
>
> or even
>
>    dd of=3D/dev/md/ubuntu:0 count=3D8 | od -c
>
> ??
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
