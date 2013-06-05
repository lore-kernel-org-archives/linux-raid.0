From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 recovery
Date: Wed, 05 Jun 2013 14:29:47 +0100
Message-ID: <51AF3D4B.8030107@anonymous.org.uk>
References: <51AF28F2.3010701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AF28F2.3010701@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philipp Frauenfelder <philipp.frauenfelder@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/06/2013 13:02, Philipp Frauenfelder wrote:
> Hi
>
> I am new to this list and RAID problems (but not to Linux).
>
> My RAIDs run well but one of my colleague in a Synology has failed. It
> was a 4-disk RAID5 and the hot-spare disk and one of the used disks (the
> middle one) failed. Unfortunately, he returned the disks to the vendor
> the get new ones.
>
> So, we ended up with 2 out of 4 disks and trying to get the data of the
> disks now. My colleague copied the disks and we were trying to rebuild
> the RAID5 on the copies. We tried to do the rebuild on a PC runing a
> fairly recent Knoppix:
>
> root@Microknoppix:~# mdadm --create --assume-clean --level=5
> --raid-devices=4 --size=1948662272 /dev/md2 missing /dev/sda3 missing
> /dev/sdb3
> mdadm: /dev/sda3 appears to be part of a raid array:
>      level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
> mdadm: /dev/sdb3 appears to be part of a raid array:
>      level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: RUN_ARRAY failed: Input/output error
>
> Apparently, this did not work. :-(
>
> In the RAID wiki, it says one should ask here before trying a destroying
> to much, that's why I am asking here....
>
> Btw, attached is the raid.status and the dmesg output.
>
> Is there a hint what we need to do?

Unfortunately you've almost certainly already lost or destroyed too much.

Firstly, you say a hot-spare and one of the used discs failed. That 
would be a 3-drive array with a spare, not a 4-drive array.

You then attempted to create a 4-drive array with two drives missing. By 
doing that, and saying "y" when you ran the create command, you 
destroyed any remaining info about the original array.

Somewhat helpfully, the create command told you a little about the 
previous metadata. It says it was a 4-drive array. Was this the first 
time you'd try to run the create command?

If the original array was indeed a 4-drive array - rather than 3 plus a 
spare - then you have lost your data because a RAID-5 can only tolerate 
losing one drive.

If the original array was in fact a 3-drive array with a spare, someone 
here might be able to do something. Re-image from the original drives, 
then post `fdisk -lu` from each disc and `mdadm -Ev` from each disc and 
all their partitions.

Cheers,

John.

