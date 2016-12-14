From: "Juan Carlos Carvajal B." <juca@juan-carlos.info>
Subject: Re: What is the solution for USB HDs
Date: Wed, 14 Dec 2016 12:07:59 +0100
Message-ID: <CAMQE2N6BRWCaRUb6ug7r6mtT2RLrbdUa6ZdqDmO8RFYEyWXa0w@mail.gmail.com>
References: <13e51316a11df7b0c9f5ab89392361de@juan-carlos.info> <171542c9-1ab8-0993-733d-fbb95467f512@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <171542c9-1ab8-0993-733d-fbb95467f512@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Adam,

thanks for the suggestions. Looking at the syslog I managed to see
what is happening. Apparently there is a bug in the Raspberry that
resets USB devices. See here:
https://www.raspberrypi.org/forums/viewtopic.php?f=3D91&t=3D47239

Apparently is the kernel itself that disconnects the devices.

Dec 13 07:52:52 fileserver kernel: [121050.860021] usb 1-1.3.2: USB
disconnect, device number 20
Dec 13 07:52:52 fileserver kernel: [121050.861653] sd 15:0:0:0: [sdc]
Synchronizing SCSI cache
Dec 13 07:52:52 fileserver kernel: [121050.861828] sd 15:0:0:0: [sdc]
Synchronize Cache(10) failed: Result: hostbyte=3D0x01 driverbyte=3D0x00
Dec 13 07:52:52 fileserver udisksd[1963]: Unable to resolve
/sys/devices/virtual/block/md0/md/dev-sdb/block symlink
Dec 13 07:52:52 fileserver kernel: [121051.195770] usb 1-1.3.2: new
high-speed USB device number 21 using dwc_otg

The full dump is here:
http://pastebin.com/F18GHLjV

I'll post this also in the raspberry forums to see what they say.
thanks!

Best regards!

Juan Carlos Carvajal Berm=C3=BAdez
+43 650 477 0005
juca@juan-carlos.info
Beingasse 17/2/3
AT 1150, Wien
www.juan-carlos.info

On 11 December 2016 at 23:14, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
>
> On 12/12/16 04:14, juca@juan-carlos.info wrote:
>>
>> Dear Linux-RAID Developers,
>>
>> I always wanted to have a small home server with a RAID-array to store p=
esonal and work files.
>>
>> So I decided to create a fileserver with a raspberry pi and a RAID-1 Arr=
ay. For this I bought two USB 1TB HDs.
>>
>> After a while I noticed that Mdadm was marking my drives as failed or ev=
en worse as faulty. This was strange since both HDs are new.
>>
>> So I tested them. I deleted the RAID partitions completely with WIPEFS. =
Then I created Ext4 partitions and run a benchmark of the partitions in ubu=
ntu. Everything is fine.
>>
>> I created then again my RAID array. To my surprise one drive was again f=
aulty. I googled a little  and I found that my USB drives went to sleep mod=
e and when they were woken up, one of them changed name /dev/sdb/ -> /dev/s=
dc. Mdadm was unable to find the "new" drive and marked it as faulty. Re-ad=
d didn't work. Adding it again went into an unnecessary and long sync of 1T=
B.
>>
>> I googled the problem and learnt about UDEV. It turns out that Linux gra=
cefully creates symlinks to the disks-partitions under /dev/disks/by-id/...=
 I thought that I could use this symlinks to fix the problem with Mdadm, bu=
t mdadm just followed the links to find again the changing /dev/sd* names.
>>
>> I continued my journey and found more about the UDEV rules. I created a =
couple of them, using the serial number of the disks. I turns out that chan=
ging the name is not anymore allowed. (NAME=3D"sdb" is ignored) There is ev=
en a warning about this. See here: http://unix.stackexchange.com/questions/=
119593/is-there-a-way-to-change-device-names-in-dev-directory
>> "NAME=3D"pendrak" ignored, kernel device nodes can not be renamed; pleas=
e fix it in /etc/udev/rules.d/99-local.rules:1"
>>
>> My last desperate idea was to create a cron job that reads directly from=
 the disks, to keep them awake and avoid a name change. Something like this=
:
>>
>> dd if=3D/dev/disk/by-id/usb-TOSHIBA_External_USB_3.0_20151214504D3-0:0 b=
s=3D1024 count=3D$(($[1<<10]*10)) skip=3D$(($SKIP)) ibs=3D1024 of=3D/dev/nu=
ll iflag=3Ddirect status=3Dnone 2>&1
>>
>> But even with that workaround the name of a disk just changed and Mdadm =
marked it as faulty. --- I'm out of ideas.
>>
>> So I'm stuck with this wonderful situation:
>>
>> - MDADM will follow symlinks and ignore the /dev/disk/by-id/... identifi=
cation.
>> - UDEV does not allow to change the name of a device.
>> - The names will apparently change no matter what I do.
>>
>> I'm starting to regret my decision to create this array. I expected some=
 challenges but it is turning to be ridiculously difficult. Almost unusable=
.
>>
>> Maybe you have a solution for this.
>>
>> In any case it would be great if you consider some long-term out-of-the-=
box solution for this new reality of USB HDs. My ideas would be:
>>
>> -- Allow to create arrays with symlinks ("/dev/disk/by-id/usb-TOSHIBA_Ex=
ternal_USB_3.0_20151214504D3-0:0")
>>
>> -- Include a keep-alive functionality that avoids names to change random=
ly.
>>
>> -- Store HD ids to recognize disks.
>>
>
> Hi,
> I think you are going down the wrong path. It isn't for Linux MD to magic=
ally "keep drives awake" or to detect which drive is the one you want to us=
e.
>
> Also, you haven't provided enough information/detail on *why* the drives =
are vanishing. For a drive to enter sleep mode, and then wake up again, it =
shouldn't change device name. The only time it will change device name (in =
my experience) is if you unplug it, and then re-plug it.
> Given you are using a Raspberry Pi, and I've quite some experience with t=
hem, my initial question would be to confirm that you are providing suffici=
ent power to the RPi, and to the 2 x USB HDD's, if there is not enough powe=
r, then one drive could easily "die" and then wake up again when the other =
drive reduces its power demand. One of the best ways to solve this is to:
> a) Use desktop drives (ie, drives that have their own power supply, and d=
on't just draw power from USB
> b) Use a powered USB hub (ie, a USB hub that has it's own power supply)
> c) Use USB flash drives, or SSD's, I suspect both will have a lower power=
 demand
>
> If you are still having problems after that, then please try to post more=
 details on what happens when the drives vanish (eg, kernel logs, system lo=
gs, etc).
>
> Also, you might consider an alternative SBC, some have SATA ports already=
 available (RPi are the only SBC's I've used, but there are many other opti=
ons/variations).
>
> Regards,
> Adam
>
>
>
> --
> Adam Goryachev Website Managers www.websitemanagers.com.au
