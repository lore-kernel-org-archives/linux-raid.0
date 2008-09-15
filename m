From: Maarten <maarten@ultratux.net>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 22:57:55 +0200
Message-ID: <48CECC53.6010004@ultratux.net>
References: <48CE250C.8000603@ultratux.net> <18638.13844.94632.293014@notabene.brown> <48CE8E28.8030705@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48CE8E28.8030705@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Replying to myself...

Maarten wrote:
> Neil Brown wrote:
>> On Monday September 15, maarten@ultratux.net wrote:
>>> This weekend I promoted my new 6-disk raid6 array to production use 
>>> and was busy copying data to it overnight. The next morning the 
>>> machine had crashed, and the array is down with an (apparent?) 4-disk 
>>> failure, as witnessed by this info:

>> So sda1 and sdj1 are newer, but not by much.
>> Looking at the full --examine output below, the time difference
>> between 1057343 and 1057345 is 61 seconds.  That is probably one or
>> two device timeouts.
> 
> Ah. How can you tell, I did not know this...

(Duh...)

>>> 2) Can/should I try to assemble --force, or it that very bad in these 
>>> circumstances?
>>
>> Yes, you should assemble with --force.  The evidence is strong that
>> nothing was successfully written after 'k' failed, so all the data
>> should be consistent.  You will need to sit through a recovery with
>> probably won't make any changes, but it is certainly safest to let it
>> try.

I did some rewiring, verified the PCI connections, rearranged the order 
of the drives, changed the realtek Gbit card to an intel (To be safe-- I 
did experience an earlier crash, very possibly due to the eth card...), 
updated the kernel, added the seventh drive and booted.
I did the --assemble --force thingy and all seems to be well, as far as 
one can see at this point that is:

apoc ~ # mdadm --assemble --force /dev/md5  /dev/sd[fhijkl]1
mdadm: forcing event count in /dev/sdl1(0) from 1057343 upto 1057345
mdadm: forcing event count in /dev/sdj1(1) from 1057343 upto 1057345
mdadm: forcing event count in /dev/sdf1(3) from 1057343 upto 1057345
mdadm: forcing event count in /dev/sdi1(5) from 1057343 upto 1057345
mdadm: /dev/md5 has been started with 6 drives (out of 7).

md5 : active raid6 sdl1[0] sdi1[5] sdh1[4] sdf1[3] sdk1[2] sdj1[1]
       2437863040 blocks level 6, 64k chunk, algorithm 2 [7/6] [UUUUUU_]

apoc ~ # pvscan;vgscan;lvscan;vgchange -a y
apoc ~ # xfs_check /dev/volume/video
ERROR: The filesystem has valuable metadata changes in a log which needs 
to be replayed.  Mount the filesystem to replay the log, and unmount it 
before re-running xfs_check.  If you are unable to mount the filesystem, 
then use the xfs_repair -L option to destroy the log and attempt a 
repair. Note that destroying the log may cause corruption -- please 
attempt a mount of the filesystem before doing this.
apoc ~ # mount /dev/volume/video  /video/
apoc ~ # umount /dev/volume/video
apoc ~ # xfs_check /dev/volume/video
apoc ~ #

But: The array did not resync. I think this may be correct but my 
understanding of raid-6 is still a bit flaky. It is degraded, but not 
fully degraded, that would mean two drives missing as it is raid-6. So 
there is indeed parity information now. Do I have to force some resync ?
Or did you mean to --assemble five disks instead of six, and hot-add the 
sixth ? If so, is it still useful to do that or is that either too late 
or pointless ?

I'm planning to add the last drive to it, to make it fully synced. 
However, since these are 500GB SATA drives and a resync of my smaller 
raid-5 array with just 5 250GB disks takes 180 mins, my guesstimate 
would be that it takes at least 7 hours to resync. Maybe this is not the 
best time to do that kind of stresstest, what with the possible 
instabilities still in there... But do I first have to make sure it is 
consistent as is...?

I think the hardware as is is at least fairly stable; probably due to 
the same crash my smaller 5-disk array resynced today (in 180 mins) and 
there has been no errors or malfunction during this process this morning.

>>> 3) Should I say farewell to my ~2400 GB of data ? :-(
>>
>> Not yet.

Indeed. :-)

>> NeilBrown

Thanks again.

For completeness sake: this is the current kernel as of now:
Linux apoc 2.6.25-gentoo-r7 #1 Mon Sep 15 20:35:31 CEST 2008 i686 AMD 
Sempron(tm) 2200+ AuthenticAMD GNU/Linux

...and lspci:
apoc ~ # lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] 
Host Bridge (rev 80)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:07.0 RAID bus controller: Silicon Image, Inc. SiI 3114 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:08.0 RAID bus controller: Silicon Image, Inc. SiI 3114 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:09.0 RAID bus controller: Silicon Image, Inc. SiI 3114 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:0a.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial 
ATA Controller (rev 02)
00:0b.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet 
Controller
00:0f.0 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
[KT600/K8T800/K8T890 South]
01:00.0 VGA compatible controller: ATI Technologies Inc Rage XL AGP 2X 
(rev 65)

Regards, and thanks everyone for the timely and perfect help !
Maarten

>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

