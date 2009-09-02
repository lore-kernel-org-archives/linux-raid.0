From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Tue, 1 Sep 2009 22:26:14 -0400
Message-ID: <7d86ddb90909011926u18ca2da7x644867ab5e7dbbfd@mail.gmail.com>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
	 <C6C20E3B.CB5A%david@santools.com>
	 <714cf35c0909011414q1f081266u47f194431fcf3176@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <714cf35c0909011414q1f081266u47f194431fcf3176@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anil Raj <anil.calvin@gmail.com>
Cc: David Lethe <david@santools.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've expanded a RAID 5 volume on a PERC controller in a Dell PowerEdge
2850. If your external enclosure supports hot swapping you can do this
with the system up and running. Otherwise install the new hard drive
and start up the server. Once the drive is installed open the
OpenManage Server Administrator. Expand the Storage and PERC
controller sections on the left pane and click Virtual Disks. Select
the reconfigure task from the list for the RAID 5 virtual disk. The
wizard will walk you through specifying the additional drive to be
part of the RAID 5 array. Depending on the number of drives and speeds
this process can take from a few hours to tens of hours.

I recommend doing this while the system is not being utilized after
hours. With the system idle you can speed up the rebuild rate, which
should help it complete faster. Click on the PERC controller in the
left pane and select Information/Configuration on the top bar. The
controller tasks list should give you the option to set the rebuild
rate. Just remember to set it back down when done.

After it completes you still need to expand the underlying file system
or create a new partition and file system on the additional space. If
you need assistance with this please provide the partition layout on
the RAID 5 volume and the file system being used.

Ryan

On Tue, Sep 1, 2009 at 5:14 PM, Anil Raj<anil.calvin@gmail.com> wrote:
> Hi David,
> =A0Thank you very much for you detailed and patient response.
>
> =A0My RAID controller is PERC 5/E and the external Dell drives are se=
tup
> up in RAID5. (I installed Dell's OpenManage Server Administration
> which gave me the details of my existing RAID). Here's some output
> (that might be useful):
>
> $ cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
> =A0Vendor: DELL =A0 =A0 Model: MD1000 =A0 =A0 =A0 =A0 =A0 Rev: A.00
> =A0Type: =A0 Enclosure =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
ANSI SCSI revision: 05
> Host: scsi0 Channel: 02 Id: 00 Lun: 00
> =A0Vendor: DELL =A0 =A0 Model: PERC 5/E Adapter Rev: 1.00
> =A0Type: =A0 Direct-Access =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ANS=
I SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 06 Lun: 00
> =A0Vendor: PE/PV =A0 =A0Model: 1x2 SCSI BP =A0 =A0 =A0Rev: 1.0
> =A0Type: =A0 Processor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
ANSI SCSI revision: 02
> Host: scsi1 Channel: 01 Id: 00 Lun: 00
> =A0Vendor: MegaRAID Model: LD 0 RAID1 =A0 34G Rev: 521X
> =A0Type: =A0 Direct-Access =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ANS=
I SCSI revision: 02
>
> I also updated the controller's ancient firmware and drivers (though
> these will take effect only after a reboot).
>
> =A0Once all users on my system have backed-up their data, I will be a=
ble
> to do a reboot and any further maintenance (which hopefully should be
> soon). (This was my only reason for not being able to do a reboot
> yet.)
>
> =A0However, after reading through all the documentation on the Server
> Administration software and the controller manuals, I'm still unsure
> if expanding a hardware RAID is possible (and if so, how to perhaps d=
o
> it). (Some parts of the manuals seem to indicate that simply
> installing the additional HDs is enough; the raid controller (during
> reboot) will automatically detect the new drives and expand the RAID =
-
> not sure if I've interpreted this correctly or not).
>
> Any tips at all would be very helpful!
>
> Thanks
> Best
> Anil
>
> On Tue, Sep 1, 2009 at 12:33 AM, David Lethe<david@santools.com> wrot=
e:
>> The answer to #2 is a function of the make/model of hardware RAID, a=
nd the
>> configuration. =A0 Sorry. =A0While there are standards for what RAID=
-5 means,
>> there is no built-in universal program that will configure all RAID
>> subsystems.
>>
>> Dell supports several RAID controllers.
>>
>> The answer to #1 is also, unfortunately a function of the make/model=
 of
>> RAID. =A0You can enter cat /proc/scsi/scsi and see if PERC, or DELL =
or LSI
>> shows up in the vendor field. =A0If so, highly probable it is RAID, =
but that
>> won't tell you if it is RAID0, 1, 10, 5, etc... =A0 If there are ent=
ries in
>> /dev/mpt, then it is a LSI-based RAID controller. (But not necessari=
ly in a
>> hardware protected RAID mode)
>>
>> If it says PERC or LSI, it is definitely a RAID config, but the conf=
ig could
>> be set up so you see individual disk drives, or it could be a n-DISK=
 RAID5
>> that is partitioned into individual disks.
>>
>> If it is hardware RAID, then I suggest, based solely on the newbie q=
uestions
>> that you find the documentation and read a bit, and run whatever sof=
tware
>> that comes with it to assess the situation. =A0 =A0Expanding a hardw=
are RAIDset,
>> can be dangerous, especially if you are unfamiliar with it.
>>
>> For example, maybe the firmware is ancient, or you have a lot of bad=
 blocks
>> because you never fixed them, or even knew about running consistency=
/repairs
>> . If you don't know what you are doing, then you can easily lose eve=
rything.
>>
>> So FIRST thing I would do before so much as powering off is a full b=
ackup.
>> If you don't know what you have, then obviously you can't properly m=
aintain
>> it. =A0(Not trying to put you down, but if you aren't willing or abl=
e to
>> examine the configuration while it is powered on, and you don't want=
 to do a
>> reboot indicates the system may be unstable, or is mission critical =
and has
>> no maintenance window, or you just don't know how to bring it back u=
p
>> properly. =A0If any of those are the case, back up before something =
fails.
>>
>> Remember disk drives have a 100% probability of failure ... Eventual=
ly. =A0You
>> just don't want it to happen while you are responsible for the syste=
m.
>>
>>
>> P.S. Did you just try the simple thing of logging onto Dell's suppor=
t site
>> and entering the service tag and get the configuration that they ori=
ginally
>> shipped?
>>
>>
>>
>> On 8/31/09 7:53 PM, "Anil Raj" <anil.calvin@gmail.com> wrote:
>>
>>> current RAID setup to include
>>> the new drives. Is there any documentation on expanding hardware RA=
ID?
>>> ( I found doc on growing software RAID on the mailing list's wiki b=
ut
>>> none on hardware RAID.)
>>>
>>> I really really hope someone can help me with these questions, plea=
se.
>>> Also, if this is not the right forum (and there is a more relevant
>>> forum) for these questions, please do let
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
