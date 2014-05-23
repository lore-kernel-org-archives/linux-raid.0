From: Dylan Distasio <interzone@gmail.com>
Subject: Re: Rebuilding a RAID5 array after drive (hardware) failure
Date: Fri, 23 May 2014 15:26:51 -0400
Message-ID: <CAJrqPH-BL+D=E0VKKWyyfEbiWwt+s00JtwBvgMBR=FD-xOVh2A@mail.gmail.com>
References: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
 <20140522144905.50511c1a@notabene.brown> <CAG__1a4-MxTjiFMt4n3YsK0DxLvcT2raadcPLvKDuOam9JgPXw@mail.gmail.com>
 <CAG__1a7QFWguQ_YDzDCLO1xM9DMe8bZs-p97-Jc0CYCjpdusXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a7QFWguQ_YDzDCLO1xM9DMe8bZs-p97-Jc0CYCjpdusXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have had similar issues with Ubuntu in the past.  I'm not sure what
your mdadm.conf looks like, but it sounds like you need to update
initramfs which is assembling the array during the boot process to
reflect the current mdadm config on your filesystem.  The md127
version of your array is getting assembled by initramfs before md0
comes into existence.

Try running:
sudo update-initramfs -u

Then reboot and see how things look

On Fri, May 23, 2014 at 2:38 PM, George Duffield
<forumscollective@gmail.com> wrote:
> If it's of use in diagnosing:
>
> cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md127 : active (auto-read-only) raid5 sdc1[2] sdb1[1] sda1[0] sdd1[4]
>       8790400512 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4=
/4] [UUUU]
>
> So it looks to me I have an array /dev/md127 and it is healthy:
>
> $ sudo mdadm --detail /dev/md127
>
> /dev/md127:
>         Version : 1.2
>   Creation Time : Sun Feb  2 21:40:15 2014
>      Raid Level : raid5
>      Array Size : 8790400512 (8383.18 GiB 9001.37 GB)
>   Used Dev Size : 2930133504 (2794.39 GiB 3000.46 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Fri May 23 00:06:34 2014
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : fileserver:0
>            UUID : 8389cd99:a86f705a:15c33960:9f1d7cbe
>          Events : 210
>
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
>        2       8       33        2      active sync   /dev/sdc1
>        4       8       49        3      active sync   /dev/sdd1
>
>
>
>
> Some questions:
> - How did md127 come into existence?
> - How do I get it out of active (auto-read-only) state so I can use i=
t?
> - Can it be renamed to md0?
>
> On Fri, May 23, 2014 at 8:29 PM, George Duffield
> <forumscollective@gmail.com> wrote:
>> Thanks for clarifying my questions.  Seeing as the flash drive has
>> indeed failed (Murphy at his proverbial best) I have to change my
>> approach by creating a fresh install of Ubuntu Server then integrati=
ng
>> the array into the new install.  On top of that the drive that was
>> marked faulty is actually up and running again (in the new machine -=
--
>> I've no idea why/how), but all drives passed POST sequence in the
>> Microserver and have since been successfully moved to the new machin=
e.
>>  I ran a fresh install of Ubuntu Server last night and installed
>> mdadm.  On rebooting the array was automatically seen and reported b=
y
>> mdadm as Clean.  I did not attempt to mount the array.  Somehow the
>> flash disk with the new OS was corrupted on a reboot (/ could not be
>> mounted) so I shut down the box using shutdown -h now.
>>
>> Tonight I've reinstalled Ubuntu Server on the flash drive, added mda=
dm
>> and rebooted without the RAID drives powered up.  After completing t=
he
>> config of th server OS (nfs, samba etc) I shut down again, added the
>> drives and rebooted.
>>
>> Running lsblk returns the following showing all of the drives from t=
he
>> array accounted for:
>>
>> $ lsblk
>> NAME      MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
>> sda         8:0    0   2.7T  0 disk
>> =E2=94=94=E2=94=80sda1      8:1    0   2.7T  0 part
>>   =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
>> sdb         8:16   0   2.7T  0 disk
>> =E2=94=94=E2=94=80sdb1      8:17   0   2.7T  0 part
>>   =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
>> sdc         8:32   0   2.7T  0 disk
>> =E2=94=94=E2=94=80sdc1      8:33   0   2.7T  0 part
>>   =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
>> sdd         8:48   0   2.7T  0 disk
>> =E2=94=94=E2=94=80sdd1      8:49   0   2.7T  0 part
>>   =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
>> sde         8:64   1  14.5G  0 disk
>> =E2=94=94=E2=94=80sde1      8:65   1  14.4G  0 part  /
>>
>> I then tried to assemble the array as follows:
>>
>> $ sudo mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/=
sdd1
>> mdadm: /dev/sda1 is busy - skipping
>> mdadm: /dev/sdb1 is busy - skipping
>> mdadm: /dev/sdc1 is busy - skipping
>> mdadm: /dev/sdd1 is busy - skipping
>>
>> No idea why the drives are reported as being busy - they're not
>> mounted nor referenced in /etc/fstab.
>>
>> What is required in order to reassemble the array?
>>
>> Thanks again.
>>
>> On Thu, May 22, 2014 at 6:49 AM, NeilBrown <neilb@suse.de> wrote:
>>> On Thu, 22 May 2014 06:31:58 +0200 George Duffield
>>> <forumscollective@gmail.com> wrote:
>>>
>>>> I have a RAID5 array comprised of 4 x 3TB Seagate 7200 RPM SATAII
>>>> drives.    The array was created on Ubuntu Server running on a HP
>>>> Microserver N54L using the following command:
>>>>
>>>> sudo mdadm --create --verbose /dev/md0 --raid-devices=3D4 --level=3D=
5
>>>> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>>>>
>>>> Formatted using:
>>>> mkfs.ext4 -b 4096 -E stride=3D128,stripe-width=3D384 /dev/md0
>>>>
>>>> The array is mounted in /etc/fstab by reference to its UUID and is=
 now
>>>> near full.
>>>>
>>>> A few days back I turned on the server to access some of the files
>>>> stored on it when I found the server was not present on the networ=
k.
>>>> Inspecting the actual server (connected kb & monitor) I noticed th=
at
>>>> the machine had not progressed beyond the BIOS post screen =E2=80=93=
 one of
>>>> the drives had become damaged (2nd drive in same slot in same
>>>> Microserver to be damaged the same way =E2=80=93 drive spins up fi=
ne, machine
>>>> knows it's there, but can't communicat successfully with the drive=
).
>>>> In any event, suffice it to say the drive is history =E2=80=93 it =
and the
>>>> Microserver will be RMAd when this is over.
>>>>
>>>> So, I'm now left with a degraded array comprising 3x3TB drives. I'=
ve
>>>> purchased a replacement drive (same make and model) in the interim
>>>> (and I've yet to boot this machine with the old drive removed or t=
he
>>>> new one inserted i.e. from an OS standpoint Ubuntu/mdadm does not =
yet
>>>> know the array is degraded).
>>>>
>>>> As I've lost complete faith in the Microserver (and it may very we=
ll
>>>> damage the new drive during recovery of the array) I've also purch=
ased
>>>> and assembled a 2nd machine with 6 on board SATA ports rather than
>>>> rely on another Microserver.  My intention is to remove the drives
>>>> from the Microserver and install them in the new machine (which I'=
ll
>>>> boot off the same USB flash drive I used to boot the Microserver f=
rom
>>>> [to further complicate things it seems my flash drive may also be
>>>> corrupted, so I may have to recover from a fresh Ubuntu install an=
d
>>>> reassemble the array]).
>>>>
>>>> A few questions if I may:
>>>> - Is moving the array to another computer and recovering it on the=
 new
>>>> computer running Ubuntu Server likely to present any particular
>>>> challenges?
>>>
>>> No.  If you were trying to boot of the array that you moved it migh=
t be
>>> interesting.  But as you aren't I cannot see any possible issue (as=
suming the
>>> hardware functions correctly).
>>>
>>>>
>>>> - Does the order/ sequence of connection of the drives to the
>>>> motherboard matter?
>>>
>>> No.
>>>
>>>>
>>>> Another way of asking the aforementioned question is whether mdadm
>>>> would care if one swapped drives in Microserver backplane/ PC SATA
>>>> ports such that the physical backplane slot/ SATA port that one/mo=
re
>>>> of the drives occupies differs from that it occupied when the arra=
y
>>>> was created?
>>>
>>> No.  mdadm looks at the content of the devices, not their location.
>>>
>>>
>>>>
>>>> - How would I best approach rebuilding the array, my current think=
ing
>>>> is as follows:
>>>> =3D Identify with certainty which drive has failed - this will be =
done
>>>> by removing the OS flash drive from the Microserver and disconnect=
ing
>>>> all drives from the backplane other than the one I believe is faul=
ty
>>>> (first slot on backplane) and booting the machine.  The failed dri=
ve
>>>> causes a POST failure and is thus easily identified.
>>>> =3D Remove all drives from the Microserver and install into new PC
>>>> referenced above, at the same time replacing the failed drive with=
 the
>>>> replacement I purchased
>>>> =3D Powering new PC via UPS
>>>> =3D Booting the PC from the flash drive
>>>> =3D Allowing the degraded array to be assembled by mdadm when prom=
pted at boot
>>>> =3D Adding the replacement drive to the array and allowing the arr=
ay to
>>>> be re-synchronized
>>>> =3D If I'm not able to access the flash drive I will create a fres=
h
>>>> install of Ubuntu Server and attempt to recreate the array in the
>>>> fresh install.
>>>>
>>>> All thoughts/ comments/ guidance much appreciated.
>>>
>>> Sounds good.
>>> Though I would discourage the boot sequence from assembling the deg=
raded
>>> array if possible.
>>> Just get the machine up with the drive untouched.  Then use "mdadm =
-E" to
>>> look at each device and make sure they are what you think they are =
(e.g.
>>> consistent Event numbers etc).
>>> Then
>>>   mdadm --assemble /dev/mdWHATEVER ..list-of-devices...
>>>
>>> Then make sure that looks good.
>>> Then
>>>   mdadm /dev/mdWHATEVER --add new-device
>>>
>>> NeilBrown
>>>
>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
