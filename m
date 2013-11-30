From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: Growing array, duplicating data, shrinking array questions.
Date: Sat, 30 Nov 2013 16:07:27 +0000
Message-ID: <BLU0-SMTP228AF830EE9F7252DAE2AFF98E80@phx.gbl>
References: <BLU0-SMTP1655B70AE4DF50100E9817198E10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP1655B70AE4DF50100E9817198E10@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2013-11-21 at 18:09 +0000, Wilson Jonathan wrote:
> I think I know what I need to do to perform the operations I want, but
> wanted to check here first.
> 
> I currently have 2 disks used to hold OS/swap/(empty)home/somedata
> partitions (500G) and a six drive raid 6 (1TB, single partition not
> whole drive) setup.
> 
> What I want to do is replace the 6 drives with 4 3TB WD REDs, and also
> to move the OS and stuff onto the 4 3TB drives.
> 
> At the moment the 500GB drives are partitioned as following.
> 
> GPT: 
> 1MB (Bios boot)
> 210MB RAID1 (boot)
> 24GB  RAID1 (root) (current live boot)
> 8GB   *SWAP
> 54GB  RAID1 (root2) (new install, will replace root)
> 11GB  RAID1 (home)
> XXGB  RAID1 (data)
> The swap is amalgamated into 16GB total swap.
> 
> (root) and (root2) are different versions of debian, (root) is my
> current "live" and (root2) is my "testing" by the end of this excersize
> (root) will no longer exist, and (root2) will become my "live."
> 
> My idea is to fail and remove one of the RAID6 devices, then put the 3TB
> in its place and format it, using gptfdisk, as the following.
> 
> GPT:
> 1MB (Bios boot)
> 210MB RAID1 (boot)
> 84GB  RAID1 (root2)
> 16GB  RAID1 (*swap)
> XXGB  Space unused, to push the last partition to the end of the disk.
> 1TB   RAID6 (raid6)
> 
> From what I have read I can grow the (boot) (root2) by increasing the
> number of devices, even though (root2) is larger on the new disk it will
> be added and only the first 54GB will synced; basically increase the
> number of devices from 2 to 3.
> 
> I will also add/update the boot loader/mbr to the new drive.
> 
> By adding in the raid6 partition it will be re-synced as if it were the
> original failed drive being replaced.
> 
> I then replicate this process for the other 3 disks.
> eg (boot) (root2) no-devices=4
> ...=5
> ...=6
> 
> and obviously adding in a replacement for the failed/removed RAID6 1TB
> drive with the RAID6 partition (raid6) and updating the (bios boot)/mbr
> 
> I will create a new RAID1 (*swap) when all the 4 devices are in place.
> 
> Also I will then create a RAID6 partition on the 4 drives empty space
> unused partition (new6).
> 
> Once this is done, and checked if all working ok...
> 
> I will then fail and remove both the original, 500GB, RAID1 (boot)
> (root) (root2) drives, then grow the raids down to ..devices=4
> 
> I believe I will then need to grow the (root2) ..size=max to extend it
> from 54GB to 84GB, check the file system, grow the file system, then
> check it again.
> 
> I will then copy all the data from the (raid6) to (new6) run a check to
> see if they are identical, and then bring down and delete (raid6) remove
> the last 2 remaining 1TB drives, put them into USB caddies (from whence
> they originally came, was cheaper than buying the raw drives) and then
> backup to them.
> 
> Finally I will delete all the 4 (raid6) partitions, I will also change
> the size of the (new6) partition to include the now deleted (raid6)
> space. (I'm assuming changing the partition end will not affect the data
> contained within) for all 4 drives, then grow the partition ..size=max,
> check the file system, grow the file system, final check...
> 
> Finally I will update the mdadm.conf in both the (root) and (root2)
> directory to take note of changes.. create the swap on the (*swap) and
> also change the (root) and (root2) fstab to take note of the file system
> changes and the new swap partition...
> 
> ...to keep things clean, I will change the files slightly differently
> for both "/" so that (root) will no longer see (root2) and also the
> reverse, once all is complete (root) will no longer be used and will be
> removed... 
> 
> ..then check that they both boot ok, finally delete the now unused (bios
> boot) (boot) (root2) from the 500GB drives, do some house keeping and if
> all has gone to plan then I can finally breath again.
> 
> Is there anything I've got in the above that looks wrong, or is a
> disaster in the making as I've miss understood something?
> 
> Actually, thinking about it... will I need to update the initramfs at
> any point, for example when I delete the (root) from within (root2) as
> my final stage after all housekeeping, and also once I have updated
> everything in (root) such as fstab and mdadm.conf?


I have a couple of other questions/observations to add to the original
ones.

It seems as if I will need to update the initramfs due to changes to
fstab and mdadm, this is not a problem :-)

Now for a huge problem...

My system is a "bios" not a "UEFI" and as such it, within the bios, does
not report the disk sizes correctly, says is about 700GB (can't be exact
without rebooting)... however to my surprise linux sees the whole disk
as 3TB, I partitioned it using gptfdisk, then created a number of ext4
file systems, filled them up with real files, ran fsck tests, zeroed out
the highest partition, re-fsck'd the lower partitions and all seemed ok.

___question 1___
(it should be noted that I was concerned that if the bios miss-reported
the size and linux saw the whole disk I was worried that perhaps some
overlapping mapping might have been going on, say the first partition,
low on the disk, was somehow mapped into the last (700GB) of the disk..
I'm guessing, and its a big guess, that once the bios has turned over
control to linux then linux no longer uses the bios (or its hooks) to
access the HD and instead goes to it directly, would this be a correct
"guess"?)

Now here is where I know/think I have a big problem with a 3tb drive in
a "bios" system and need confirmation before going any further...

___question 2___
I'm guessing that as the bios can only see the tail end of the hard
drive it would not be able to load the data from the "mbr" (still there
despite being a GPT formatted disk) and proceed to load the first stage
boot loader because it will think the "mbr" should be at the start of
the "700GB" which in reality is 2.2TB into the disk, would this be a
correct assumption? (

Actually I could probably test this by installing
(grub-install /dev/sdX) then going into the bios and telling it to boot
from that disk while the original boot drives (containing
biosboot /boot /root) were still pluged in, if it failed then I know its
not going to work.

___question 3___
If it does not work, but linux can see and use the drive with no
problems, then is it possible to install the first (possibly second, i'm
guessing thats what gets put in the "biosboot" partiton) stage grub2
boot loaders to a USB drive, then have this load the rest of the system
"/boot" partition from the new 3tb drives or if not possible then
include the "/boot" on the usb drive as its only 200M its not a
hardship, if I "raid" it to the existing partitions then any changes
will be replicated, and should the usb fail I can just boot a system
rescue disk make a new usb boot, copy the "/boot" from the hard drive
and away we go.

___question 4___
I guess instead of using a USB, I could use the DVD drive, create a
first/second stage loader onto it that will then chain into the hd to
load the linux kernel.. is this possible?

I guess my last question is related to q3/q4 and that is... if its
possible then is there a simple set of commands required, my initial
thoughts are "grub-install" to the usb stick, as it will know to load
from "the first drive" and as I will replicate, mirror, "/boot" (as well
as "/") on the first 4 drives... if it fails then the second one will
become the first so will be found by grub and so on...



