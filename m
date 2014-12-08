From: Emery Guevremont <emery.guevremont@gmail.com>
Subject: Re: On RAID5 read error during syncing - array .A.A
Date: Mon, 8 Dec 2014 11:31:09 -0500
Message-ID: <CAB_L8sZNxNDO_f0X_uXwLuM8kcRgT=p+f8+-wtYDhEQPy_dX5Q@mail.gmail.com>
References: <CAB_L8sZoinCMbp7wrjYaQ=XgCOiBWZBLHkMsV_g+nUyM9pc7CQ@mail.gmail.com>
	<20141206185600.GA2343@cthulhu.home.robinhill.me.uk>
	<CAB_L8sYkWFO0hC-rUHednzy=BWZoBaVS_DhoBedg-viPnTdU-g@mail.gmail.com>
	<20141208094841.GA8530@cthulhu.home.robinhill.me.uk>
	<CAB_L8sYfFNaeUNiCFhidGVuRtMOP1XjJ4e=edsXp1bqe-FYBww@mail.gmail.com>
	<20141208151419.GB8530@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141208151419.GB8530@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's the adjusted command.

mdadm --create --assume-clean --level=5 --metadata=1.2 --chunk=512
--size=1952795136 --raid-devices=4 /dev/md0 missing \
92589cc2:9d5ed86c:1467efc2:2e6b7f09 \
390bd4a2:07a28c01:528ed41e:a9d0fcf0 \
4156ab46:bd42c10d:8565d5af:74856641

For the --size option, I'm not quite sure I understood what you tried
to explain to me. I re-read the manpage and I came up with this 2
equations:

(My understanding of your explanation) Used Dev size (3905590272)
divided by 2 = size (1952795136)
(My understanding from the manpages) Used Dev size (3905590272)
divided by chunk size (512) = size (7628106)

As for the device, I should order them with the device UUID (as shown
above) and I replace those UUID with the /dev/sdX3 that returns the
same device uuid from a mdadm -E command I will currently get? i.e.
mdadm -E /dev/sdd3 returns a device uuid of
92589cc2:9d5ed86c:1467efc2:2e6b7f09 , my first device with be
/dev/sdd3...?

One last question, after running mdadm --create command, can I run
mdadm -E and verify the values I get (chunk size, used dev size...)
match the ones I got from my first mdadm -E command, and if it
doesn't, to rerun the mdadm --create command to eventually get
matching values?

On Mon, Dec 8, 2014 at 10:14 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Mon Dec 08, 2014 at 09:13:13AM -0500, Emery Guevremont wrote:
>> On Mon, Dec 8, 2014 at 4:48 AM, Robin Hill <robin@robinhill.me.uk> wrote:
>> > On Sat Dec 06, 2014 at 03:49:10PM -0500, Emery Guevremont wrote:
>> >> On Sat, Dec 6, 2014 at 1:56 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>> >> > On Sat Dec 06, 2014 at 01:35:50pm -0500, Emery Guevremont wrote:
>> >> >
>> >> >> The long story and what I've done.
>> >> >>
>> >> >> /dev/md0 is assembled with 4 drives
>> >> >> /dev/sda3
>> >> >> /dev/sdb3
>> >> >> /dev/sdc3
>> >> >> /dev/sdd3
>> >> >>
>> >> >> 2 weeks ago, mdadm marked /dev/sda3 as failed. cat /proc/mdstat showed
>> >> >> _UUU. smarctl also confirmed that the drive was dying. So I shutdown
>> >> >> the server and until I received a replacement drive.
>> >> >>
>> >> >> This week, I replaced the dying drive with my new drive. Booted into
>> >> >> single user mode and did this:
>> >> >>
>> >> >> mdadm --manage /dev/md0 --add /dev/sda3  a cat of /proc/mdstat
>> >> >> confirmed the resyncing process. The last time I checked it was up to
>> >> >> 11%. After a few minutes later, I noticed that the syncing stopped. A
>> >> >> read error message on /dev/sdd3 (have a pic of it if interested)
>> >> >> appear on the console. It appears that /dev/sdd3 might be going bad. A
>> >> >> cat /proc/mdstat showed _U_U. Now I panic, and decide to leave
>> >> >> everything as is and to go to bed.
>> >> >>
>> >> >> The next day, I shutdown the server and reboot with a live usb distro
>> >> >> (Ubuntu rescue remix). After booting into the live distro, a cat
>> >> >> /proc/mdstat showed that my /dev/md0 was detected but all drives had
>> >> >> an (S) next to it. i.e. /dev/sda3 (S)... Naturally I don't like the
>> >> >> looks of this.
>> >> >>
>> >> >> I ran ddrescue to copy /dev/sdd onto my new replacement disk
>> >> >> (/dev/sda). Everything, worked, ddrescue got only one read error, but
>> >> >> was eventually able to read the bad sector on a retry. I followed up
>> >> >> by also cloning with ddrescue, sdb and sdc.
>> >> >>
>> >> >> So now I have cloned copies of sdb, sdc and sdd to work with.
>> >> >> Currently running mdadm --assemble --scan, will activate my array, but
>> >> >> all drives are added as spares. Running mdadm --examine on each
>> >> >> drives, shows the same Array UUID number, but the Raid Devices is 0
>> >> >> and raid level is -unknown- for some reason. The rest seems fine and
>> >> >> makes sense. I believe I could re-assemble my array if I could define
>> >> >> the raid level and raid devices.
>> >> >>
>> >> >> I wanted to know if there are a way to restore my superblocks from the
>> >> >> examine command I ran at the beginning? If not, what mdadm create
>> >> >> command should I run? Also please let me know if drive ordering is
>> >> >> important, and how I can determine this with the examine output I'll
>> >> >> got?
>> >> >>
>> >> >> Thank you.
>> >> >>
>> >> > Have you tried --assemble --force? You'll need to make sure the array's
>> >> > stopped first, but that's the usual way to get the array back up and
>> >> > running in that sort of situation.
>> >> >
>> >> > If that doesn't work, stop the array again and post:
>> >> >  - the output from mdadm --assemble --force --verbose /dev/md0 /dev/sd[bcd]3
>> >> >  - any dmesg output corresponding with the above
>> >> >  - --examine output for all disks
>> >> >  - kernel and mdadm versions
>> >> >
>> >> > Good luck,
>> >> >     Robin
>> >
>> >> You'll see from the examine output, raid level and devices aren't
>> >> defined and notice the role of each drives. The examine output (I
>> >> attached 4 files) that I took right after the read error during the
>> >> synching process seems to show a more accurate superblock. Here's also
>> >> the output of mdadm --detail /dev/md0 that I took when I got the first
>> >> error:
>> >>
>> >> ARRAY /dev/md/0 metadata=1.2 UUID=cf9db8fa:0c2bb553:46865912:704cceae
>> >> name=runts:0
>> >>    spares=1
>> >>
>> >>
>> >> Here's the output of how things currently are:
>> >>
>> >> mdadm --assemble --force /dev/md127 /dev/sdb3 /dev/sdc3 /dev/sdd3
>> >> mdadm: /dev/md127 assembled from 0 drives and 3 spares - not enough to
>> >> start the array.
>> >>
>> >> dmesg
>> >> [27903.423895] md: md127 stopped.
>> >> [27903.434327] md: bind<sdc3>
>> >> [27903.434767] md: bind<sdd3>
>> >> [27903.434963] md: bind<sdb3>
>> >>
>> >> cat /proc/mdstat
>> >> root@ubuntu:~# cat /proc/mdstat
>> >> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
>> >> [raid1] [raid10]
>> >> md127 : inactive sdb3[4](S) sdd3[0](S) sdc3[5](S)
>> >>       5858387208 blocks super 1.2
>> >>
>> >> mdadm --examine /dev/sd[bcd]3
>> >> /dev/sdb3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0
>> >>   Creation Time : Tue Jul 26 03:27:39 2011
>> >>      Raid Level : -unknown-
>> >>    Raid Devices : 0
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : active
>> >>     Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da
>> >>
>> >>     Update Time : Sat Dec  6 12:46:40 2014
>> >>        Checksum : 5e8cfc9a - correct
>> >>          Events : 1
>> >>
>> >>
>> >>    Device Role : spare
>> >>    Array State :  ('A' == active, '.' == missing)
>> >> /dev/sdc3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0
>> >>   Creation Time : Tue Jul 26 03:27:39 2011
>> >>      Raid Level : -unknown-
>> >>    Raid Devices : 0
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : active
>> >>     Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0
>> >>
>> >>     Update Time : Sat Dec  6 12:46:40 2014
>> >>        Checksum : f69518c - correct
>> >>          Events : 1
>> >>
>> >>
>> >>    Device Role : spare
>> >>    Array State :  ('A' == active, '.' == missing)
>> >> /dev/sdd3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0
>> >>   Creation Time : Tue Jul 26 03:27:39 2011
>> >>      Raid Level : -unknown-
>> >>    Raid Devices : 0
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : active
>> >>     Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09
>> >>
>> >>     Update Time : Sat Dec  6 12:46:40 2014
>> >>        Checksum : 571ad2bd - correct
>> >>          Events : 1
>> >>
>> >>
>> >>    Device Role : spare
>> >>    Array State :  ('A' == active, '.' == missing)
>> >>
>> >> and finally kernel and mdadm versions:
>> >>
>> >> uname -a
>> >> Linux ubuntu 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:41:14 UTC
>> >> 2012 i686 i686 i386 GNU/Linux
>> >>
>> >> mdadm -V
>> >> mdadm - v3.2.3 - 23rd December 2011
>> >
>> > The missing data looks similar to a bug fixed a couple of years ago
>> > (http://neil.brown.name/blog/20120615073245), though the kernel versions
>> > don't match and the missing data is somewhat different - it may be that
>> > the relevant patches were backported to the vendor kernel you're using.
>> >
>> > With that data missing there's no way to assemble though, so a re-create
>> > is required in this case (it's a last resort, but I don't see any other
>> > option).
>> >
>> >> /dev/sda3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0  (local to host runts)
>> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >>      Raid Level : raid5
>> >>    Raid Devices : 4
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : clean
>> >>     Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da
>> >>
>> >>     Update Time : Tue Dec  2 23:15:37 2014
>> >>        Checksum : 5ed5b898 - correct
>> >>          Events : 3925676
>> >>
>> >>          Layout : left-symmetric
>> >>      Chunk Size : 512K
>> >>
>> >>    Device Role : spare
>> >>    Array State : A.A. ('A' == active, '.' == missing)
>> >
>> >> /dev/sdb3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0  (local to host runts)
>> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >>      Raid Level : raid5
>> >>    Raid Devices : 4
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : clean
>> >>     Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09
>> >>
>> >>     Update Time : Tue Dec  2 23:15:37 2014
>> >>        Checksum : 57638ebb - correct
>> >>          Events : 3925676
>> >>
>> >>          Layout : left-symmetric
>> >>      Chunk Size : 512K
>> >>
>> >>    Device Role : Active device 0
>> >>    Array State : A.A. ('A' == active, '.' == missing)
>> >
>> >> /dev/sdc3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0  (local to host runts)
>> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >>      Raid Level : raid5
>> >>    Raid Devices : 4
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : clean
>> >>     Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0
>> >>
>> >>     Update Time : Tue Dec  2 23:15:37 2014
>> >>        Checksum : fb20d8a - correct
>> >>          Events : 3925676
>> >>
>> >>          Layout : left-symmetric
>> >>      Chunk Size : 512K
>> >>
>> >>    Device Role : Active device 2
>> >>    Array State : A.A. ('A' == active, '.' == missing)
>> >
>> >> /dev/sdd3:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >>            Name : runts:0  (local to host runts)
>> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >>      Raid Level : raid5
>> >>    Raid Devices : 4
>> >>
>> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >>     Data Offset : 2048 sectors
>> >>    Super Offset : 8 sectors
>> >>           State : clean
>> >>     Device UUID : 4156ab46:bd42c10d:8565d5af:74856641
>> >>
>> >>     Update Time : Tue Dec  2 23:14:03 2014
>> >>        Checksum : a126853f - correct
>> >>          Events : 3925672
>> >>
>> >>          Layout : left-symmetric
>> >>      Chunk Size : 512K
>> >>
>> >>    Device Role : Active device 1
>> >>    Array State : AAAA ('A' == active, '.' == missing)
>> >
>> > At least you have the previous data anyway, which should allow
>> > reconstruction of the array. The device names have changed between your
>> > two reports though, so I'd advise double-checking which is which before
>> > proceeding.
>> >
>> > The reports indicate that the original array order (based on the device
>> > role field) for the four devices was (using device UUIDs as they're
>> > consistent):
>> >     92589cc2:9d5ed86c:1467efc2:2e6b7f09
>> >     4156ab46:bd42c10d:8565d5af:74856641
>> >     390bd4a2:07a28c01:528ed41e:a9d0fcf0
>> >     b2bf0462:e0722254:0e233a72:aa5df4da
>> >
>> > That would give a current device order of sdd3,sda3,sdc3,sdb3 (I don't
>> > have the current data for sda3, but that's the only missing UUID).
>> >
>> > The create command would therefore be:
>> >     mdadm -C -l 5 -n 4 -c 512 -e 1.2 -z 1952795136 \
>> >         /dev/md0 /dev/sdd3 /dev/sda3 /dev/sdc3 missing
>> >
>> > mdadm 3.2.3 should use a data offset of 2048, the same as your old
>> > array, but you may want to double-check that with a test array on a
>> > couple of loopback devices first. If not, you'll need to grab the
>> > latest release and add the --data-offset=2048 parameter to the above
>> > create command.
>> >
>> > You should also follow the instructions for using overlay files at
>> > https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
>> > in order to safely test out the above without risking damage to the
>> > array data.
>> >
>> > Once you've run the create, run a "fsck -n" on the filesystem to check
>> > that the data looks okay. If not, the order or parameters may be
>> > incorrect - check the --examine output for any differences from the
>> > original results.
>> >
>> Just to double check, would this be the right command to run?
>>
>> mdadm --create --assume-clean --level=5 --size=5858385408
>> --raid-devices=4 /dev/md0 missing /dev/sdb3 /dev/sdc3 /dev/sdd3
>>
>> Are there any other options I would need to add? Should I specify
>> --chunk and --size (and if I entered the right size)?
>>
> You don't need --assume-clean as there's a missing device, so no scope
> for rebuilding one of the disks (which is all the flag prevents). It
> won't do any harm leaving it in though.
>
> The size should be the per-device size in kiB (which is half the Used
> Dev Size value listed in the --examine output, as that's given in
> 512-byte blocks) and I gave you the correct value above. I'd recommend
> including this as it will ensure that mdadm isn't calculating the size
> any different from the version originally used to create the array.
>
> The device order you've given is incorrect for either the original
> device numbering or the numbering you posted as being the most recent.
> The order I gave above is based on the order as in the latest --examine
> results you gave. If you've rebooted since then, you'll need to verify
> the order based on the UUIDs of the devices though (again, the original
> order should be the one I gave above, based on the device role order in
> your original --examine output). If you're using different disks, you'll
> need to be sure which one was mirrored from which original. If you use
> the incorrect order, you'll get a lot of errors in the "fsck -n" output
> but, as long as you don't actually write to the array, it shouldn't
> cause any data corruption as only the metadata will be overwritten.
>
> There shouldn't be any need to specify the chunk size, as 512k should be
> the default value, but I'd probably still stick it in anyway, just to be
> on the safe side.
>
> Similarly with the metadata version - 1.2 is the default (currently
> anyway, I'm not certain with 3.2.3), so shouldn't be necessary. Again,
> I'd add it in to be on the safe side.
>
>> By the way thanks for the help.
>>
>
> No problem.
>
> Cheers,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
