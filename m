From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Grow a RAID-10
Date: Thu, 03 Jul 2008 09:29:29 -0700
Message-ID: <486CFE69.8030501@amfes.com>
References: <486BF974.70508@amfes.com> <20080702231026.GA15028@rap.rap.dk> <486C2FB3.3050403@amfes.com> <20080703084653.GA29152@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080703084653.GA29152@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Wed, Jul 02, 2008 at 06:47:31PM -0700, Daniel L. Miller wrote:
>  =20
>> Keld J=F8rn Simonsen wrote:
>>    =20
>>> On Wed, Jul 02, 2008 at 02:56:04PM -0700, Daniel L. Miller wrote:
>>> =20
>>>      =20
>>>> I currently have a RAID10 across (4) SATA drives.  It looks like I=
'm=20
>>>> going to need to grow in the near future.  Any tips for a procedur=
e for=20
>>>> this?  My current plan:
>>>>
>>>> 1.  Add a PCI SATA controller (MB had 4 SATA + 4 RAID SATA, it's a=
 Tyan=20
>>>> MB with a NFORCE chipset, I'm not sure if I want/can use the RAID =
SATA=20
>>>> ports as plain SATA connections).
>>>>   =20
>>>>        =20
>>> Why not use the mobo raid sata ports? They are probably faster than=
 a
>>> controller on the pci bus. What kind of pci bus do you have?
>>>
>>> =20
>>>      =20
>> My mistake.  Confused this one with another system.  Only have 4 por=
ts=20
>> available.  I did have the option of using the Nvidia RAID - which I=
 did=20
>> NOT enable.
>>    =20
>
> Yes, it is fine not to use the two on-board raid controllers in raid
> mode, but just to use SW raid on them. I have a similar mobo with 2
> sata controllers and the ability to attach 8 sata drives, which I hav=
e
> all been using to run SW raid, and I have not experienced any problem=
s
> yet with this setup.
>
> I understand that your mobo has 4 onboard sata connections, and that
> these are already in use for the current array.
>
>  =20
>> What "kind" of pci bus?  Don't understand the question.  If it matte=
rs,=20
>> it's a Tyan S2892, a "Thunder K8SE".  nForce Pro2200 and AMD8131 PCI=
-X=20
>> chipsets.
>>    =20
>
> So it has both PCI-X bus and PCI-E bus. You want to attact 2 more dri=
ves=20
> and you need a sata controller. This could probably both be attached =
via
> the PCI-X bus and the PCI-E bus. It seems like the PCI-X bus - with a
> 133 MHz possibility counld be the faster of the 2, but given you will
> only have 2 more drives, both PCI-X and PCI-E are prossibilties.
>
>  =20
>>> PCI-E 1x is likely to be too slow for a 4-drive raid10,f2 array.
>>> My 4-drive raid10,f2 delivers about 320 MB/s and newer disks should=
 be
>>> able to deliver 360 MB/s - well above the 250 MB/s that a PCI-E 1x =
can
>>> deliver.=20
>>>
>>> =20
>>>      =20
>>>> 2.  Add 2 more drives - not necessarily the same size as the exist=
ing=20
>>>> (they were all 4 the same)
>>>>
>>>> 3.  Execute "mdadm --grow /dev/md0"
>>>>   =20
>>>>        =20
>>> What kind of raid10 do you have?>=20
>>> =20
>>>      =20
>> I don't understand this question either.
>>
>> mdadm --detail /dev/md0
>> /dev/md0:
>>        Version : 00.90.03
>>  Creation Time : Tue Oct  3 19:11:53 2006
>>     Raid Level : raid10
>>     Array Size : 312581632 (298.10 GiB 320.08 GB)
>>  Used Dev Size : 156290816 (149.05 GiB 160.04 GB)
>>   Raid Devices : 4
>>  Total Devices : 4
>> Preferred Minor : 0
>>    Persistence : Superblock is persistent
>>
>>    Update Time : Wed Jul  2 18:46:15 2008
>>          State : clean
>> Active Devices : 4
>> Working Devices : 4
>> Failed Devices : 0
>>  Spare Devices : 0
>>
>>         Layout : near=3D2, far=3D1
>>     Chunk Size : 32K
>>
>>           UUID : 9d94b17b:f5fac31a:577c252b:0d4c4b2a
>>         Events : 0.10941692
>>
>>    Number   Major   Minor   RaidDevice State
>>       0       8        0        0      active sync   /dev/sda
>>       1       8       16        1      active sync   /dev/sdb
>>       2       8       32        2      active sync   /dev/sdc
>>       3       8       48        3      active sync   /dev/sdd
>>    =20
>
> I was takling about the layout, and you have a n2 layout (standard
> raid10 - near=3D2). You may benefit from a raid10,f2 layout, as this =
has faster=20
> read capabilities, but I think it is not possible on the fly to
> rearrange a raid10,n2 array to a raid10,f2 array.
>
> Given that you have a raid10,n2 layout, the speeds of the busses are =
not
> so important, as raid10,n2 cannot deliver that high performance.=20
> I would expect less than 100 MB/s coming out of your 2 extra disks.
>
> What is the use for your raid? is it a database, a file server, a web
> server or the like?
>
> Best regards
> keld
>  =20

This is our all-in-one server.  The raid is the primary storage for=20
everything - day-to-day operations files, quickbooks data, virtual=20
machines.  O/S and programs are on a separate non-raid drive.
--
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
