From: Ralph =?iso-8859-1?q?Pa=DFgang?= <ralph@debianbase.de>
Subject: Re: new RAID-1 Array always shows filesystem errors...
Date: Tue, 24 Feb 2004 03:06:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402240306.56989.ralph@debianbase.de>
References: <200402211300.38709.ralph@debianbase.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200402211300.38709.ralph@debianbase.de>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have made some more investigation in the problem I described and I think it 
has something to do with changes in the raid code betweed 2.4.25 and 2.6.1 
(that's the versions I used at last).

Here in short the problem I noticed:

An old raid-1 array (2/2 disks) worked with with 2.6.1, but if I wanted to 
create a new one that I had problems.

I always started in degraded mode (1/2 drives), because the second hard drive 
for the raid-1 array was in the moment in use. Later I added the missing 
drive and after the sync procress I can't access a lot of files and the files 
I could access were damages (seems to miss about 50% or at least 50% was crap 
content). After remove the second disk again the data was okay again. dmesg / 
syslog showed reiserfs/fs errors (see my first mail)

Now I downgraded to 2.4.25 again and I still had the raid-1 array with the 
missing hard drive in degraded mode, which I set up under the 2.6.1 kernel. 
So I added now the missing drive again.

After syncing the content is still okay, now broken files, no data 
corruption... After even two reboots. The only difference between distaster 
and a perfect system seems to be my kernel-version:

Here the facts of my system once again:

AMD Duron 900, 1x60GB (Linux System itself),4x120GB (2xRAID1), VIA IDE 
Controller + Promise Ultra 133 Controller.

Debian Unstable with GCC 3.3,2, libc6 2.3.2
Vanilla Kernel 2.4.25 / Vanilla Kernel 2.6.1 (plus pnpbios patch)
mdadm 1.4.0
raidtools 0.42

/proc/mdstat example for my setup:
read_ahead 1024 sectors
md1 : active raid1 hdf[0] hdg[1]
      120627264 blocks [2/2] [UU]

md0 : active raid1 hde[0]
      120627264 blocks [2/1] [U_]

Because my old raid array worked under 2.6.1 without a problem with both disks 
(never made a resync under the 2.6) I think it has something to do with the 
sync... I use to hotadd a harddrive:

mdadm /dev/md0 -a /dev/hdf (for example)

Is the sync process a kernel oder a userland thing? If it is userland maybe it 
i also a debian bug, if so, please notice me, than I will put it in the 
debian bug tracking system.

thanks,

--Ralph

Am Samstag, 21. Februar 2004 13:00 schrieben Sie:
> Hi,
>
> in the past I used a raid1 with two 123,5GB drives for about 1,5 years now
> and never expierenced problems with the raid part... A month ago one drive
> fails (IRQ timeouts all the time) so I was thinking of a new system.
>
> I decided to start from the beginning, this time with: 2x RAID-1 (so 4
> disks all together). I wanted a lvm (one big vg) over the two
> raid-arrays...
>
> So I created the 2 NEW raid arrays, but I started in one of the two arrays
> with only one disk  and the second mirror disk was missing (because I had
> the old raid device (degraded due to the disk failure) with my old data
> which I wanted to copy to the new lvm and then use the old disk to complete
> the new raid array).
>
> At first everything went fine, but later on I noticed massive filesystem
> errors, so I deleted the new lvm and the 2 new raid1 arrays. I was happy
> that I still had my old raid1 array with the old data, so no data loss
> happend...
>
> Then I created the 2 raid arrays again but this time without the lvm,
> because I though the lvm part was the problem... I started again in the
> degraded mode with only one disk out of two in each array.
>
> This time the data seems to be ok, so I completed the frist new array with
> puting the seconds disk in. The sync process was ok but then I noticed
> problems again. If I want to read data I get massive filesystem errors... I
> was suprised and removed the mirror disk (the one I just hotadded). Now the
> data seems to be fine again, no data corruption, no filesystem errors...
>
> I tried the same on the second raid-array and notice the same strange
> errors... In the degraded one-disk mode the raid is ok, but if the second
> disk is added and resynced than I got these problems.
>
> On the second raid are some mp3, so I played some of them (to see if that
> are actually errors or bogus errors) and I noticed that the song skips
> every 2-3 seconds for 1-2 seconds. One could think that the read access to
> disc 1 is okay, but the half time disk2 should deliver the data and it
> doesn't... in the log the filesystem errors are reported when i am playing
> mp3s...
>
> Even some Files or directories aren't accessible anymore. (Even if they
> would, the data would be useless). If i "ls" in a directory inside the
> raid1 devices (with two synced disks) it says for example for about half
> the files: "perrmission denied"  or "file not found" (on a ls *) (i am
> root!)
>
> Strage is, that the old raid is/was fine, I just can't build a new raid1,
> because after the disk sync I got these errors...
>
> Here a example filesystem errors I see (thousands in my log):
> Feb 21 01:27:52 services kernel: vs-5150: search_by_key: invalid format
> found in block 3783953. Fsck?
> Feb 21 01:27:52 services kernel: is_tree_node: node level 0 does not match
> to the expected one 1
> Feb 21 01:27:52 services kernel: vs-5150: search_by_key: invalid format
> found in block 3783953. Fsck?
> ...
>
> (It can't be a filesystem error, because as soon as I remove a drive the
> errors are gone)
>
> My Setup is this:
> DEVICE  /dev/hde /dev/hdf /dev/hdb /dev/hdg
>
> ARRAY   /dev/md0 devices=/dev/hde,/dev/hdb
> ARRAY   /dev/md1 devices=/dev/hdf,missing
>
> (that are only the two new arrays, the old one is deleted now!!!...
> /dev/md1 is working in this setup... md0 gives the error (because both
> disks are in))
>
> I use: Debian Unstable with: linux-2.6.1 (vanilla +pnpbios patch), mdadm
> 1.4.0-3 (bugs.debian.org says there is no such bug in mdadm) and a reiserfs
> 3.6 partition on the md-devices.
>
> My hdd Setup is this:
>     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:DMA
>     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, hdd:pio
>     ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:pio, hdf:pio
>     ide3: BM-DMA at 0xdc08-0xdc0f, BIOS settings: hdg:pio, hdh:pio
> hda: IC35L060AVV207-0, ATA DISK drive
> hdb: IC35L120AVVA07-0, ATA DISK drive
> hde: IC35L120AVV207-1, ATA DISK drive
> hdf: IC35L120AVV207-1, ATA DISK drive
> hdg: IC35L120AVV207-0, ATA DISK drive
>
> hda: 120103200 sectors (61492 MB) w/1821KiB Cache, CHS=16383/255/63,
> UDMA(100) hda: hda1 hda2
> hdb: max request size: 128KiB
> hdb: 241254720 sectors (123522 MB) w/1863KiB Cache, CHS=65535/15/63,
> UDMA(100) hdb: unknown partition table
> hde: max request size: 1024KiB
> hde: 241254720 sectors (123522 MB) w/7965KiB Cache, CHS=16383/255/63,
> UDMA(100)
>  hde: unknown partition table
> hdf: max request size: 1024KiB
> hdf: 241254720 sectors (123522 MB) w/7965KiB Cache, CHS=16383/255/63,
> UDMA(100)
>  hdf: unknown partition table
> hdg: max request size: 1024KiB
> hdg: 241254720 sectors (123522 MB) w/1821KiB Cache, CHS=16383/255/63,
> UDMA(100)
>  hdg: unknown partition table
>
> Personalities : [raid1]
> md1 : active raid1 hdf[0]
>       120627264 blocks [2/2] [UU]
>
> md0 : active raid1 hde[0]
>       120627264 blocks [2/1] [U_]
>
> unused devices: <none>
>
> the raid (/mdadm) doesn't seem to detect this error... I am quite sure that
> is nothing with the drive or the pc... I use 4 drives with 2 raids, so it
> is not a "one drive is broken" thing.
>
> Please help me, because the data on the two arrays is quite important to
> me, so that running two normal disks which holds the data is no solution
> for me. I had a drive failure once and the raid saved me... I need the two
> new raid arrays... Maybe a kernel thing? 2.6.1 is not the latest... should
> I upgrade to 2.6.3? Could it be mdadm? Should I recompile it against my
> kernel?
>
> Thanks for your help... and sorry for my bad english :)
>
> best regard,
>  Ralph
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
