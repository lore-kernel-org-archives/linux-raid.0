From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Fri, 1 Jul 2011 23:19:31 -0700
Message-ID: <BANLkTi=Ek_Ro04U72o5aEo6NXmsKqmt+yw@mail.gmail.com>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
	<BANLkTinEcO0kh+WAU4xapWTqTqkB0ZR_KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinEcO0kh+WAU4xapWTqTqkB0ZR_KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

On Fri, Jul 1, 2011 at 9:41 PM, Simon Matthews
<simon.d.matthews@gmail.com> wrote:
> Neil,
>
> On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 28 Jun 2011 21:29:37 -0700 Simon Matthews
>> <simon.d.matthews@gmail.com> wrote:
>>
>>> Problem 1: "Used Dev Size"
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> Note: the system is a Gentoo box, so perhaps I have missed a kernel
>>> configuration option or use flag to deal with large hard drives.
>>>
>>> A week or two ago, I resized a raid1 array using 2x3TB drives. I we=
nt
>>
>> Oopps. =A0That array is using 0.90 metadata which can only handle up=
 to 2TB
>> devices. =A0The 'resize' code should catch that you are asking the i=
mpossible,
>> but it doesn't it seems.
>>
>> You need to simply recreate the array as 1.0.
>> i.e.
>> =A0mdadm -S /dev/md5
>> =A0mdadm =A0-C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean
>
> Before I do this (tomorrow), do I need to add the partitions to the c=
ommand:
>
> mdadm =A0-C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean /dev/sdd2 =
/dev/sdc2

I went ahead and did this. Everything looks good -- I think.

Why do the array sizes from --examine on my metadata 1.0 and metadata
1.2 arrays appear to be twice the size of the array:
 # mdadm --examine /dev/sde2
/dev/sde2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8f16e81f:3324004c:8d020c9b:a981e2ae
           Name : server2:7  (local to host server2)
  Creation Time : Wed Jun 29 10:39:32 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 2925064957 (1394.78 GiB 1497.63 GB)          <<<
     Array Size : 2925064684 (1394.78 GiB 1497.63 GB)           <<<
how is 2925064684 equal to 1394.78 GiB?
  Used Dev Size : 2925064684 (1394.78 GiB 1497.63 GB)        <<<
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c78ff04c:98c9ea48:77db4b85:46ac6dc1

    Update Time : Fri Jul  1 23:13:02 2011
       Checksum : e446cf2c - correct
         Events : 14


   Device Role : Active device 0
   Array State : A. ('A' =3D=3D active, '.' =3D=3D missing)




Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
