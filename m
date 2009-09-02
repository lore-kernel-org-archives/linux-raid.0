From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Wed, 2 Sep 2009 14:28:09 -0400
Message-ID: <7d86ddb90909021128s59f988bdn20795f60749fbc02@mail.gmail.com>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
	 <C6C20E3B.CB5A%david@santools.com>
	 <714cf35c0909011414q1f081266u47f194431fcf3176@mail.gmail.com>
	 <7d86ddb90909011926u18ca2da7x644867ab5e7dbbfd@mail.gmail.com>
	 <714cf35c0909021103n6aa4a9d9w2699bebcc208862c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <714cf35c0909021103n6aa4a9d9w2699bebcc208862c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anil Raj <anil.calvin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Your welcome! I would wait to expand the ext3 file system until the
hardware RAID expansion completes as you will need to run fsck on the
drive before expanding the volume. This is data intensive and will
just slow the system to a crawl if done during the RAID expansion.

I'm assuming that /dev/sda is not mounted at / since this is an
external enclosure. If this is your operating system drive you will
need to use a rescue CD or live CD to perform the resize. The resize
procedure below requires you to unmount the volume making it
inaccessible.

You need to start by resizing the partition. Since there is only one
partition on the RAID volume this is easy enough. I use fdisk to
delete then recreate the partition. As long as the start block is the
same and the end block is greater than the current block, which it
will be, you will not effect the ext3 file system.

Then you can use resize2fs to expand the file system to the partition
boundary. It will prompt you to do a forced fsck before it will
resize. This will probably take around 30-45 min on a TB volume. The
resize itself should only take a few minutes.

The commands you will be using are below. Since data is involved I
will give the normal caution to proceed at your own risk.

umount /dev/sda
fdisk /dev/sda (delete and recreate the partition to fill the entire vo=
lume)
mount /dev/sda (make sure your files are accessible to verify you
repartitioned it correctly)
fsck -f /dev/sda
resize2fs /dev/sda
mount /dev/sda (df -h should show the volume with the additional space)

Ryan

On Wed, Sep 2, 2009 at 2:03 PM, Anil Raj<anil.calvin@gmail.com> wrote:
> Hi Ryan,
> =A0That is excellent information! Thank you so much!!
>
> =A0My external enclosure does support hot-swapping. I will begin the
> expansion in a few hours. I'd also rather expand the existing
> filesystem. Here's some output that might be useful:
>
> # fdisk -l /dev/sda
>
> Disk /dev/sda: 1169.3 GB, 1169304846336 bytes
> 255 heads, 63 sectors/track, 142159 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0142159 =A01141892136=
 =A0 83 =A0Linux
>
> # parted /dev/sda print
> Disk geometry for /dev/sda: 0.000-1115136.000 megabytes
> Disk label type: msdos
> Minor =A0 =A0Start =A0 =A0 =A0 End =A0 =A0 Type =A0 =A0 =A0Filesystem=
 =A0Flags
> 1 =A0 =A0 =A0 =A0 =A00.031 1115129.069 =A0primary =A0 ext3 =A0 =A0 =A0=
 =A0boot
>
> Any help on this would be great too! (and do let me know if I need to
> give more info/details.)
>
> Thanks again!
> Best
> Anil
>
> On Tue, Sep 1, 2009 at 10:26 PM, Ryan Wagoner<rswagoner@gmail.com> wr=
ote:
>> I've expanded a RAID 5 volume on a PERC controller in a Dell PowerEd=
ge
>> 2850. If your external enclosure supports hot swapping you can do th=
is
>> with the system up and running. Otherwise install the new hard drive
>> and start up the server. Once the drive is installed open the
>> OpenManage Server Administrator. Expand the Storage and PERC
>> controller sections on the left pane and click Virtual Disks. Select
>> the reconfigure task from the list for the RAID 5 virtual disk. The
>> wizard will walk you through specifying the additional drive to be
>> part of the RAID 5 array. Depending on the number of drives and spee=
ds
>> this process can take from a few hours to tens of hours.
>>
>> I recommend doing this while the system is not being utilized after
>> hours. With the system idle you can speed up the rebuild rate, which
>> should help it complete faster. Click on the PERC controller in the
>> left pane and select Information/Configuration on the top bar. The
>> controller tasks list should give you the option to set the rebuild
>> rate. Just remember to set it back down when done.
>>
>> After it completes you still need to expand the underlying file syst=
em
>> or create a new partition and file system on the additional space. I=
f
>> you need assistance with this please provide the partition layout on
>> the RAID 5 volume and the file system being used.
>>
>> Ryan
>>
>> On Tue, Sep 1, 2009 at 5:14 PM, Anil Raj<anil.calvin@gmail.com> wrot=
e:
>>> Hi David,
>>> =A0Thank you very much for you detailed and patient response.
>>>
>>> =A0My RAID controller is PERC 5/E and the external Dell drives are =
setup
>>> up in RAID5. (I installed Dell's OpenManage Server Administration
>>> which gave me the details of my existing RAID). Here's some output
>>> (that might be useful):
>>>
>>> $ cat /proc/scsi/scsi
>>> Attached devices:
>>> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>>> =A0Vendor: DELL =A0 =A0 Model: MD1000 =A0 =A0 =A0 =A0 =A0 Rev: A.00
>>> =A0Type: =A0 Enclosure =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0ANSI SCSI revision: 05
>>> Host: scsi0 Channel: 02 Id: 00 Lun: 00
>>> =A0Vendor: DELL =A0 =A0 Model: PERC 5/E Adapter Rev: 1.00
>>> =A0Type: =A0 Direct-Access =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0A=
NSI SCSI revision: 05
>>> Host: scsi1 Channel: 00 Id: 06 Lun: 00
>>> =A0Vendor: PE/PV =A0 =A0Model: 1x2 SCSI BP =A0 =A0 =A0Rev: 1.0
>>> =A0Type: =A0 Processor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0ANSI SCSI revision: 02
>>> Host: scsi1 Channel: 01 Id: 00 Lun: 00
>>> =A0Vendor: MegaRAID Model: LD 0 RAID1 =A0 34G Rev: 521X
>>> =A0Type: =A0 Direct-Access =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0A=
NSI SCSI revision: 02
>>>
>>> I also updated the controller's ancient firmware and drivers (thoug=
h
>>> these will take effect only after a reboot).
>>>
>>> =A0Once all users on my system have backed-up their data, I will be=
 able
>>> to do a reboot and any further maintenance (which hopefully should =
be
>>> soon). (This was my only reason for not being able to do a reboot
>>> yet.)
>>>
>>> =A0However, after reading through all the documentation on the Serv=
er
>>> Administration software and the controller manuals, I'm still unsur=
e
>>> if expanding a hardware RAID is possible (and if so, how to perhaps=
 do
>>> it). (Some parts of the manuals seem to indicate that simply
>>> installing the additional HDs is enough; the raid controller (durin=
g
>>> reboot) will automatically detect the new drives and expand the RAI=
D -
>>> not sure if I've interpreted this correctly or not).
>>>
>>> Any tips at all would be very helpful!
>>>
>>> Thanks
>>> Best
>>> Anil
>>>
>>> On Tue, Sep 1, 2009 at 12:33 AM, David Lethe<david@santools.com> wr=
ote:
>>>> The answer to #2 is a function of the make/model of hardware RAID,=
 and the
>>>> configuration. =A0 Sorry. =A0While there are standards for what RA=
ID-5 means,
>>>> there is no built-in universal program that will configure all RAI=
D
>>>> subsystems.
>>>>
>>>> Dell supports several RAID controllers.
>>>>
>>>> The answer to #1 is also, unfortunately a function of the make/mod=
el of
>>>> RAID. =A0You can enter cat /proc/scsi/scsi and see if PERC, or DEL=
L or LSI
>>>> shows up in the vendor field. =A0If so, highly probable it is RAID=
, but that
>>>> won't tell you if it is RAID0, 1, 10, 5, etc... =A0 If there are e=
ntries in
>>>> /dev/mpt, then it is a LSI-based RAID controller. (But not necessa=
rily in a
>>>> hardware protected RAID mode)
>>>>
>>>> If it says PERC or LSI, it is definitely a RAID config, but the co=
nfig could
>>>> be set up so you see individual disk drives, or it could be a n-DI=
SK RAID5
>>>> that is partitioned into individual disks.
>>>>
>>>> If it is hardware RAID, then I suggest, based solely on the newbie=
 questions
>>>> that you find the documentation and read a bit, and run whatever s=
oftware
>>>> that comes with it to assess the situation. =A0 =A0Expanding a har=
dware RAIDset,
>>>> can be dangerous, especially if you are unfamiliar with it.
>>>>
>>>> For example, maybe the firmware is ancient, or you have a lot of b=
ad blocks
>>>> because you never fixed them, or even knew about running consisten=
cy/repairs
>>>> . If you don't know what you are doing, then you can easily lose e=
verything.
>>>>
>>>> So FIRST thing I would do before so much as powering off is a full=
 backup.
>>>> If you don't know what you have, then obviously you can't properly=
 maintain
>>>> it. =A0(Not trying to put you down, but if you aren't willing or a=
ble to
>>>> examine the configuration while it is powered on, and you don't wa=
nt to do a
>>>> reboot indicates the system may be unstable, or is mission critica=
l and has
>>>> no maintenance window, or you just don't know how to bring it back=
 up
>>>> properly. =A0If any of those are the case, back up before somethin=
g fails.
>>>>
>>>> Remember disk drives have a 100% probability of failure ... Eventu=
ally. =A0You
>>>> just don't want it to happen while you are responsible for the sys=
tem.
>>>>
>>>>
>>>> P.S. Did you just try the simple thing of logging onto Dell's supp=
ort site
>>>> and entering the service tag and get the configuration that they o=
riginally
>>>> shipped?
>>>>
>>>>
>>>>
>>>> On 8/31/09 7:53 PM, "Anil Raj" <anil.calvin@gmail.com> wrote:
>>>>
>>>>> current RAID setup to include
>>>>> the new drives. Is there any documentation on expanding hardware =
RAID?
>>>>> ( I found doc on growing software RAID on the mailing list's wiki=
 but
>>>>> none on hardware RAID.)
>>>>>
>>>>> I really really hope someone can help me with these questions, pl=
ease.
>>>>> Also, if this is not the right forum (and there is a more relevan=
t
>>>>> forum) for these questions, please do let
>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
