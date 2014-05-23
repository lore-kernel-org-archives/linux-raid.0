From: George Duffield <forumscollective@gmail.com>
Subject: Re: Rebuilding a RAID5 array after drive (hardware) failure
Date: Fri, 23 May 2014 20:29:47 +0200
Message-ID: <CAG__1a4-MxTjiFMt4n3YsK0DxLvcT2raadcPLvKDuOam9JgPXw@mail.gmail.com>
References: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
	<20140522144905.50511c1a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140522144905.50511c1a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for clarifying my questions.  Seeing as the flash drive has
indeed failed (Murphy at his proverbial best) I have to change my
approach by creating a fresh install of Ubuntu Server then integrating
the array into the new install.  On top of that the drive that was
marked faulty is actually up and running again (in the new machine ---
I've no idea why/how), but all drives passed POST sequence in the
Microserver and have since been successfully moved to the new machine.
 I ran a fresh install of Ubuntu Server last night and installed
mdadm.  On rebooting the array was automatically seen and reported by
mdadm as Clean.  I did not attempt to mount the array.  Somehow the
flash disk with the new OS was corrupted on a reboot (/ could not be
mounted) so I shut down the box using shutdown -h now.

Tonight I've reinstalled Ubuntu Server on the flash drive, added mdadm
and rebooted without the RAID drives powered up.  After completing the
config of th server OS (nfs, samba etc) I shut down again, added the
drives and rebooted.

Running lsblk returns the following showing all of the drives from the
array accounted for:

$ lsblk
NAME      MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda         8:0    0   2.7T  0 disk
=E2=94=94=E2=94=80sda1      8:1    0   2.7T  0 part
  =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
sdb         8:16   0   2.7T  0 disk
=E2=94=94=E2=94=80sdb1      8:17   0   2.7T  0 part
  =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
sdc         8:32   0   2.7T  0 disk
=E2=94=94=E2=94=80sdc1      8:33   0   2.7T  0 part
  =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
sdd         8:48   0   2.7T  0 disk
=E2=94=94=E2=94=80sdd1      8:49   0   2.7T  0 part
  =E2=94=94=E2=94=80md127   9:127  0   8.2T  0 raid5
sde         8:64   1  14.5G  0 disk
=E2=94=94=E2=94=80sde1      8:65   1  14.4G  0 part  /

I then tried to assemble the array as follows:

$ sudo mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd=
1
mdadm: /dev/sda1 is busy - skipping
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping

No idea why the drives are reported as being busy - they're not
mounted nor referenced in /etc/fstab.

What is required in order to reassemble the array?

Thanks again.

On Thu, May 22, 2014 at 6:49 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 22 May 2014 06:31:58 +0200 George Duffield
> <forumscollective@gmail.com> wrote:
>
>> I have a RAID5 array comprised of 4 x 3TB Seagate 7200 RPM SATAII
>> drives.    The array was created on Ubuntu Server running on a HP
>> Microserver N54L using the following command:
>>
>> sudo mdadm --create --verbose /dev/md0 --raid-devices=3D4 --level=3D=
5
>> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>>
>> Formatted using:
>> mkfs.ext4 -b 4096 -E stride=3D128,stripe-width=3D384 /dev/md0
>>
>> The array is mounted in /etc/fstab by reference to its UUID and is n=
ow
>> near full.
>>
>> A few days back I turned on the server to access some of the files
>> stored on it when I found the server was not present on the network.
>> Inspecting the actual server (connected kb & monitor) I noticed that
>> the machine had not progressed beyond the BIOS post screen =E2=80=93=
 one of
>> the drives had become damaged (2nd drive in same slot in same
>> Microserver to be damaged the same way =E2=80=93 drive spins up fine=
, machine
>> knows it's there, but can't communicat successfully with the drive).
>> In any event, suffice it to say the drive is history =E2=80=93 it an=
d the
>> Microserver will be RMAd when this is over.
>>
>> So, I'm now left with a degraded array comprising 3x3TB drives. I've
>> purchased a replacement drive (same make and model) in the interim
>> (and I've yet to boot this machine with the old drive removed or the
>> new one inserted i.e. from an OS standpoint Ubuntu/mdadm does not ye=
t
>> know the array is degraded).
>>
>> As I've lost complete faith in the Microserver (and it may very well
>> damage the new drive during recovery of the array) I've also purchas=
ed
>> and assembled a 2nd machine with 6 on board SATA ports rather than
>> rely on another Microserver.  My intention is to remove the drives
>> from the Microserver and install them in the new machine (which I'll
>> boot off the same USB flash drive I used to boot the Microserver fro=
m
>> [to further complicate things it seems my flash drive may also be
>> corrupted, so I may have to recover from a fresh Ubuntu install and
>> reassemble the array]).
>>
>> A few questions if I may:
>> - Is moving the array to another computer and recovering it on the n=
ew
>> computer running Ubuntu Server likely to present any particular
>> challenges?
>
> No.  If you were trying to boot of the array that you moved it might =
be
> interesting.  But as you aren't I cannot see any possible issue (assu=
ming the
> hardware functions correctly).
>
>>
>> - Does the order/ sequence of connection of the drives to the
>> motherboard matter?
>
> No.
>
>>
>> Another way of asking the aforementioned question is whether mdadm
>> would care if one swapped drives in Microserver backplane/ PC SATA
>> ports such that the physical backplane slot/ SATA port that one/more
>> of the drives occupies differs from that it occupied when the array
>> was created?
>
> No.  mdadm looks at the content of the devices, not their location.
>
>
>>
>> - How would I best approach rebuilding the array, my current thinkin=
g
>> is as follows:
>> =3D Identify with certainty which drive has failed - this will be do=
ne
>> by removing the OS flash drive from the Microserver and disconnectin=
g
>> all drives from the backplane other than the one I believe is faulty
>> (first slot on backplane) and booting the machine.  The failed drive
>> causes a POST failure and is thus easily identified.
>> =3D Remove all drives from the Microserver and install into new PC
>> referenced above, at the same time replacing the failed drive with t=
he
>> replacement I purchased
>> =3D Powering new PC via UPS
>> =3D Booting the PC from the flash drive
>> =3D Allowing the degraded array to be assembled by mdadm when prompt=
ed at boot
>> =3D Adding the replacement drive to the array and allowing the array=
 to
>> be re-synchronized
>> =3D If I'm not able to access the flash drive I will create a fresh
>> install of Ubuntu Server and attempt to recreate the array in the
>> fresh install.
>>
>> All thoughts/ comments/ guidance much appreciated.
>
> Sounds good.
> Though I would discourage the boot sequence from assembling the degra=
ded
> array if possible.
> Just get the machine up with the drive untouched.  Then use "mdadm -E=
" to
> look at each device and make sure they are what you think they are (e=
=2Eg.
> consistent Event numbers etc).
> Then
>   mdadm --assemble /dev/mdWHATEVER ..list-of-devices...
>
> Then make sure that looks good.
> Then
>   mdadm /dev/mdWHATEVER --add new-device
>
> NeilBrown
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
