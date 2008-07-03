From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Grow a RAID-10
Date: Wed, 02 Jul 2008 18:47:31 -0700
Message-ID: <486C2FB3.3050403@amfes.com>
References: <486BF974.70508@amfes.com> <20080702231026.GA15028@rap.rap.dk>
Reply-To: dmiller@amfes.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702231026.GA15028@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Wed, Jul 02, 2008 at 02:56:04PM -0700, Daniel L. Miller wrote:
>  =20
>> I currently have a RAID10 across (4) SATA drives.  It looks like I'm=
=20
>> going to need to grow in the near future.  Any tips for a procedure =
for=20
>> this?  My current plan:
>>
>> 1.  Add a PCI SATA controller (MB had 4 SATA + 4 RAID SATA, it's a T=
yan=20
>> MB with a NFORCE chipset, I'm not sure if I want/can use the RAID SA=
TA=20
>> ports as plain SATA connections).
>>    =20
>
> Why not use the mobo raid sata ports? They are probably faster than a
> controller on the pci bus. What kind of pci bus do you have?
>
>  =20
My mistake.  Confused this one with another system.  Only have 4 ports=20
available.  I did have the option of using the Nvidia RAID - which I di=
d=20
NOT enable.

What "kind" of pci bus?  Don't understand the question.  If it matters,=
=20
it's a Tyan S2892, a "Thunder K8SE".  nForce Pro2200 and AMD8131 PCI-X=20
chipsets.
> PCI-E 1x is likely to be too slow for a 4-drive raid10,f2 array.
> My 4-drive raid10,f2 delivers about 320 MB/s and newer disks should b=
e
> able to deliver 360 MB/s - well above the 250 MB/s that a PCI-E 1x ca=
n
> deliver.=20
>
>  =20
>> 2.  Add 2 more drives - not necessarily the same size as the existin=
g=20
>> (they were all 4 the same)
>>
>> 3.  Execute "mdadm --grow /dev/md0"
>>    =20
>
> What kind of raid10 do you have?>=20
>  =20
I don't understand this question either.

mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Oct  3 19:11:53 2006
     Raid Level : raid10
     Array Size : 312581632 (298.10 GiB 320.08 GB)
  Used Dev Size : 156290816 (149.05 GiB 160.04 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jul  2 18:46:15 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=3D2, far=3D1
     Chunk Size : 32K

           UUID : 9d94b17b:f5fac31a:577c252b:0d4c4b2a
         Events : 0.10941692

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd

--=20
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
