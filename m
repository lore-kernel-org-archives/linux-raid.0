From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 13:56:39 +0000
Message-ID: <4D5BD797.1040309@gmail.com>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5A92F3.1090004@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

one other snippet:

proxmox:/home/simon# for x in /dev/sd{d..m} ; do echo $x ; dd if=3D$x=20
skip=3D2312 count=3D128 2>/dev/null |strings |grep=20
9fAJEz-HcaP-RQ51-fV8b-nxrN-Uqwb-PPnOLJ ; done
/dev/sdd
/dev/sde
/dev/sdf
/dev/sdg
/dev/sdh
/dev/sdi
id =3D "9fAJEz-HcaP-RQ51-fV8b-nxrN-Uqwb-PPnOLJ"
id =3D "9fAJEz-HcaP-RQ51-fV8b-nxrN-Uqwb-PPnOLJ"
/dev/sdj
/dev/sdk
/dev/sdl
/dev/sdm



On 15/02/2011 14:51, Phil Turmel wrote:
> Hi Neil,
>
> Since Simon has responded, let me summarize the assistance I provided=
 per his off-list request:
>
> On 02/14/2011 11:53 PM, NeilBrown wrote:
>> On Thu, 10 Feb 2011 16:16:44 +0000 Simon McNair<simonmcnair@gmail.co=
m>  wrote:
>>
>>> Hi all
>>>
>>> I use a 3ware 9500-12 port sata card (JBOD) which will not work wit=
hout a
>>> 128mb sodimm.  The sodimm socket is flakey and the result is that t=
he
>>> machine occasionally crashes.  Yesterday I finally gave in and put
>>> together another
>>> machine so that I can rsync between them.  When I turned the machin=
e
>>> on today to set up rync, the RAID array was not gone, but corrupted=
=2E
>>>    Typical...
>> Presumably the old machine was called 'ubuntu' and the new machine '=
pro=C3=B8lox'
>>
>>
>>> I built the array in Aug 2010 using the following command:
>>>
>>> mdadm --create --verbose /dev/md0 --metadata=3D1.1 --level=3D5
>>> --raid-devices=3D10 /dev/sd{b,c,d,e,f,g,h,i,j,k}1 --chunk=3D64
>>>
>>> Using LVM, I did the following:
>>> pvscan
>>> pvcreate -M2 /dev/md0
>>> vgcreate lvm-raid /dev/md0
>>> vgdisplay lvm-raid
>>> vgscan
>>> lvscan
>>> lvcreate -v -l 100%VG -n RAID lvm-raid
>>> lvdisplay /dev/lvm-raid/lvm0
>>>
>>> I then formatted using:
>>> mkfs -t ext4 -v -m .1 -b 4096 -E stride=3D16,stripe-width=3D144
>>> /dev/lvm-raid/RAID
>>>
>>> This worked perfectly since I created the array.  Now mdadm is comi=
ng up
>>> with
>>>
>>> proxmox:/dev/md# mdadm --assemble --scan --verbose
>>> mdadm: looking for devices for further assembly
>>> mdadm: no recogniseable superblock on /dev/md/ubuntu:0
>> And it seems that ubuntu:0 have been successfully assembled.
>> It is missing one device for some reason (sdd1) but RAID can cope wi=
th that.
> 3ware card is compromised, with a loose buffer memory dimm.  Some of =
its ECC errors were caught and reported in dmesg.  Its likely, based on=
 the loose memory socket, that many multiple-bit errors got through.
>
> [trim /]
>
>>> mdadm: no uptodate device for slot 8 of /dev/md/pro=EF=BF=BDlox:0
>>> mdadm: no uptodate device for slot 9 of /dev/md/pro=EF=BF=BDlox:0
>>> mdadm: failed to add /dev/sdd1 to /dev/md/pro=EF=BF=BDlox:0: Invali=
d argument
>>> mdadm: /dev/md/pro=EF=BF=BDlox:0 assembled from 0 drives - not enou=
gh to start
>>> the array.
>> This looks like it is *after* to trying the --create command you giv=
e
>> below..  It is best to report things in the order they happen, else =
you can
>> confuse people (or get caught out!).
> Yes, this was after.
>
>>> mdadm: looking for devices for further assembly
>>> mdadm: no recogniseable superblock on /dev/sdd
>>> mdadm: No arrays found in config file or automatically
>>>
>>> pvscan and vgscan show nothing.
>>>
>>> So I tried running mdadm --create --verbose /dev/md0 --metadata=3D1=
=2E1
>>> --level=3D5 --raid-devices=3D10 missing /dev/sde1 /dev/sdf1 /dev/sd=
g1
>>> /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 --chunk=
=3D64
>>>
>>> as it seemed that /dev/sdd1 failed to be added to the array.  This =
did
>>> nothing.
>> It did not to nothing.  It wrote a superblock to /dev/sdd1 and compl=
ained
>> that it couldn't write to all the others --- didn't it?
> There were multiple attempts to create.  One wrote to just sdd1, anot=
her succeeded with all but sdd1.
>
>>> dmesg contains:
>>>
>>> md: invalid superblock checksum on sdd1
>> I guess that is why sdd1 was missing from 'ubuntu:0'.  Though as I c=
annot
>> tell if this happened before or after any of the various things repo=
rted
>> above, it is hard to be sure.
>>
>>
>> The  real mystery is why 'pvscan' reports nothing.
> The original array was created with mdadm v2.6.7, and had a data offs=
et of 264 sectors.  After Simon's various attempts to --create, he ende=
d up with data offset of 2048, using mdadm v3.1.4.  The mdadm -E report=
s he posted to the list showed the 264 offset.  We didn't realize the o=
ffset had been updated until somewhat later in our troubleshooting effo=
rts.
>
> In any case, pvscan couldn't see the LVM signature because it wasn't =
there (at offset 2048).
>
>> What about
>>    pvscan --verbose
>>
>> or
>>
>>    blkid -p /dev/md/ubuntu:0
>>
>> or even
>>
>>    dd of=3D/dev/md/ubuntu:0 count=3D8 | od -c
> Fortunately, Simon did have a copy of his LVM configuration.  With th=
e help of dd, strings, and grep, we did locate his LVM sig at the corre=
ct location on sdd1 (for data offset 264).  After a number of attempts =
to bypass LVM and access his single LV with dmsetup (based on his backe=
d up configuration, on the assembled new array less sdd1), I realized t=
hat the data offset was wrong on the recreated array, and went looking =
for the cause.  I found your git commit that changed that logic last sp=
ring, and recommended that Simon revert to the default package for his =
ubuntu install, which is v2.6.7.
>
> Simon has now attempted to recreate the array with v2.6.7, but the co=
ntroller is throwing too many errors to succeed, and I suggested it was=
 too flakey to trust any further.  Based on the existence of the LVM si=
g on sdd1, I believe Simon's data is (mostly) intact, and only needs a =
successful create operation with a properly functioning controller.  (H=
e might also need to perform an lvm vgcfgrestore, but he has the necess=
ary backup file.)
>
> A new controller is on order.
>
> Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
