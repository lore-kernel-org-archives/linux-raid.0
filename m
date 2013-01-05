From: "Alex Leach" <beamesleach@gmail.com>
Subject: Fwd: Re: RAID5 member disks shrunk
Date: Sat, 05 Jan 2013 15:17:54 -0000
Message-ID: <op.wqf134gs8s54ea@metabuntu>
References: <op.wqcditj08s54ea@metabuntu> <50E6FF8E.5040309@mpstor.com>
 <op.wqeiuj0e8s54ea@metabuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.wqeiuj0e8s54ea@metabuntu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(Sorry, keep replying only to sender!).

Hi,

Thanks for the reply. Really helpful :)


On Fri, 04 Jan 2013 16:13:02 -0000, Benjamin ESTRABAUD <be@mpstor.com>
wrote:

>
> Not sure if this will help but I had something similar recently. After  
> updating from mdadm-2.6.9 on kernel 2.6.35 to mdadm-3.2.6 on kernel  
> 3.6.6 I noticed that reusing the same "create" command with the same  
> "size" argument did not work anymore, complaining about devices being  
> too small.

I'm also currently running mdadm-3.2.6, but on kernel 3.7.1.
The Kubuntu ext4 partition (used to be my main OS) was on about kernel
3.5.5, but was running dmraid (don't know off-hand what version, but I
kept everything up to date with the main Ubuntu repositories).

The RAID arrays weren't originally created in Linux. I imagine the initial
RAID0 was created in the BIOS (by the PC assemblers), but they might have
done it in Windows.. I can phone up and ask tomorrow. Don't know off-hand
what version of the Windows utility was installed, but could figure it out
if necessary.

I've tried (and failed) to upgrade the Intel BIOS Option ROM. This is what
is and has always been installed:

       $ mdadm --detail-platform
          Platform : Intel(R) Matrix Storage Manager
           Version : 8.0.0.1038
       RAID Levels : raid0 raid1 raid10 raid5
       Chunk Sizes : 4k 8k 16k 32k 64k 128k
       2TB volumes : supported
         2TB disks : not supported
         Max Disks : 6
       Max Volumes : 2 per array, 4 per controller
    I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)

I've seen it recommended to always stick to whatever tools you used to
create the array in the first place, and don't change between dmraid and
mdadm. I've always used dmraid (until I installed Arch, a couple weeks
ago), but never for creating or manipulating the array. mdadm seems a bit
safer and has more, specific recovery options in this sort of scenario,
and did just fine when accessing the initially degraded array.


I saw this excellent answer / set of tests on serverfault.com, which
furthered my confidence in mdadm :
     http://serverfault.com/questions/347606/recover-raid-5-data-after-created-new-array-instead-of-re-using/347786#347786

Having read that and seen all the extra functionality mdadm provides over
dmraid, I'd quite like to stick with mdadm over dmraid.


>
> The command having worked before, I looked deeper into it and realized  
> that between the time the array was initially created on mdadm-2.6.9 and  
> when it was re-created on mdadm-3.2.6 some changes to mdadm were made  
> that reserved more space for superblocks etc.
>
> While I used to simply allocate an extra 256KB of space for the  
> superblock when passing in the "size" argument, I changed this to a lot  
> higher for any subsequent array.

Thanks for the tip. Bit late now, but I'll be sure to keep some extra tail
space in the future!

>
> Considering that your array was built on one system and that you tried  
> to run the "create" command on another, this is what could have happened.

Intel's manual says all data will be lost when you create an array, which
is why I've avoided using their Windows tool for this recovery, even
though they say the same for mdadm. AFAICT, the windows utility doesn't
seem to allow specifying device order, essential if I'm to recover
anything. Perhaps I should have a go in the BIOS, after zero'ing the
superblocks? Any thoughts for, or (more importantly) against that?


>
> In a more positive light, the fact that it did not do anything probably  
> saved you from it overwriting the old array by creating it at a so  
> slightly different array.

Yes, cheers. I'm hoping there wasn't anything essential at the end of the
ext4 partition, but I haven't read (or understood) anything specifying an
essential bit of ext4 data at the end of a partition. I have a suspicion
that there's some sort of marker at the end of an ext4 partition, which
may have been overwritten by an enlarged RAID superblock. What I'm
confused about is how the partition starts seem to have changed location,
higher up the disk, according to testdisk results...

>
> Not sure what the guideline is here in this case, but I would recommend  
> only "recreating" arrays to repair them in last resort, and if necessary  
> to do, only by using the same version of mdadm/kernel, just to be sure  
> there aren't any changes in the code that will cause your array to be  
> recreated not in the same exact way.
>

The same RAID utility would be Intel's windows one.. Would mdadm have been
compatible with whatever Windows version was available at the time? I
could figure out what mdadm version was available at the same time, and
could potentially use that from an older recovabuntu kernel.



> Minors numbers are irrelevant to ext4, a device can be allocated  
> different minor numbers and still have its filesystem read (devices do  
> not always mount on the same sdX device after all)

Cool, thanks for the clarification. Yea, I noticed that; after writing a
partition table with testdisk, the sdX codes had changed. Fortunately, I
managed to match the new letters with the old (and have been posting
consistent drive letters here for simplicity).


>
> My guess is that there is corruption (to an unknown extent) but that  
> NTFS is more forgiving about it. Have you made sure that the data you  
> recovered on your NTFS partition is still good?

Haven't checked it all.. I've played through a couple albums I copied off
the NTFS partition, without a hitch, and the directory structures and file
names of my Documents seem to be fine. I've rescued a 6GB Ubuntu VM from
the NTFS partition; haven't tried running it since, but I think that'd be
a good test for integrity...

>
> The fact that your ext4 partition "shrunk" (assuming it is the last one)  
> should not (to be tested, simply a hunch out of memory) prevent it from  
> mounting, at least when trying to force it.

That would be cool. Do you know, if I was to use `mke2fs` to update the
partition table to fit on the drive and not to overlap the previous, NTFS
partition, is there a possibility the old file system and journal could be
picked up? Would it work even if the partition table said it extended
beyond the available size of the array? With the old partition table, I
was unable to mount any of the partitions... I guess a valid partition
table, even if inconsistent with the old one, would allow me to then use
extundelete, which I've been unable to do without a partition / device
file.


>>
> Mhhhh, had not seen the part where your array got created in the end. If  
> your NTFS partition on the RAID is here, chances are the other should be  
> too. Try to look for ext3 file headers by examining the contents of your  
> RAID with hexdump at the offset at which your partition is supposed to  
> start.

I could give that a go, but don't have a clue what to expect ext3 file
headers to look like. Haven't used hexdump before, but I'll see if I can
figure out what to do from the man page.

>
> The fact that "create" was ran and that there are no backups of the  
> images does not help your case.

Yep, I know :( Tragic circumstances...



Feel like that was a bit all over the place. So gonna detail my plan of
action.. Any comments extremely welcome.

    Current working status
    ======================
     NB I did another re-create yesterday, and minor numbers changed back,
but size still small :-/

       $ sudo mdadm -D /dev/md/RAID5

/dev/md/RAID5:
         Container : /dev/md/imsm0, member 0
        Raid Level : raid5
        Array Size : 586065920 (558.92 GiB 600.13 GB)
     Used Dev Size : 293033024 (279.46 GiB 300.07 GB)
      Raid Devices : 3
     Total Devices : 3

             State : clean
    Active Devices : 3
Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-asymmetric
        Chunk Size : 64K


              UUID : 1a11fb7c:d558fd23:c0481cee:268cb5e0
       Number   Major   Minor   RaidDevice State
          0       8        0        0      active sync   /dev/sda
          3       8       96        1      active sync   /dev/sdg
          1       8       16        2      active sync   /dev/sdb


       $ sudo sfdisk -d /dev/md/RAID5
       $ sudo testdisk /dev/md/RAID5
# Intel Partition -> Analyse -> Quick Search
Disk /dev/md/RAID5 - 600 GB / 558 GiB - CHS 146516480 2 4
Analysing cylinder ...... (57%)
Warning: Incorrect number of heads/cylinder 255 (NTFS) != 2 (HD)
Warning: Incorrect number of sectors per track 63 (NTFS) != 4 (HD)
     HPFS - NTFS            266   0  1 25865   1  4     204800
Warning: Incorrect number of heads/cylinder 255 (NTFS) != 2 (HD)
Warning: Incorrect number of sectors per track 63 (NTFS) != 4 (HD)
     HPFS - NTFS          26816   0  1 83526079   1  4  667994112
     Linux                83526080   0  1 146517183   1  4  503928832

# Stop (at ~57%)
The following partition can't be recovered:
        Partition               Start        End    Size in sectors
>  Linux                83526080   0  1 146517183   1  4  503928832

# Continue
Disk /dev/md/RAID5 - 600 GB / 558 GiB - CHS 146516480 2 4
        Partition               Start        End    Size in sectors
> * HPFS - NTFS            266   0  1 25865   1  4     204800
    P HPFS - NTFS          26816   0  1 83526079   1  4  667994112

Structure: Ok.  Use Up/Down Arrow keys to select partition.
Use Left/Right Arrow keys to CHANGE partition characteristics:
*=Primary bootable  P=Primary  L=Logical  E=Extended  D=Deleted

# Continue -> Quit.


How is the start sector now 266? Is it something to do with the CHS
values? testdisk reports partition boundaries that don't seem to be
aligned with the cylinder boundaries, but if I change the Sectors per head
to 63, and heads per cylinder to 255, in testdisk options, it then doesn't
find these partitions, which are almost definitely my old partitions that
I want to recover...


     2. Make a copy of old partition table file; the one I originally dumped
   from sfdisk, here for convenience:

>>     $ sudo sfdisk -d /dev/md126  # this is: /dev/md/RAID5
>>
>> # partition table of /dev/md126
>> unit: sectors
>>
>> /dev/md126p1 : start=     2048, size=   204800, Id= 7, bootable
>> /dev/md126p2 : start=   206848, size=667994112, Id= 7
>> /dev/md126p3 : start=668200960, size=503928832, Id= 7
>> /dev/md126p4 : start=        0, size=        0, Id= 0
>>

     3. Copy new start and end numbers reported by testdisk into above copy
of sfdisk output. Figure out start and end sectors for ext4 partition.
These will be for the first sector after NTFS partition, and last sector
before end of array. Copy that into sfdisk output. I'm quite confused by
the numbers testdisk reports, as the start and end numbers reported
wouldn't fit the 'size in sectors'..


     4. $ sudo sfdisk /dev/md/RAID5 < md126.out

     5. Hope udev picks up the partition table change, reboot if nothing
happens, and hope for the best.

     6. See what extundelete can find...

     7. Backup! Backup! Backup!

Thanks again for the help and advice.

Cheers,
Alex


-- 
Using Opera's mail client: http://www.opera.com/mail/
