From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 14:06:56 -0700
Message-ID: <CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra>
	<51534450.8050905@hardwarefreak.com>
	<CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com>
	<51535252.2080105@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51535252.2080105@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 27, 2013 at 1:10 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 3/27/2013 2:23 PM, Mark Knecht wrote:
>
>> Note that another level of understanding (which I don't have) has to
>> do with getting chunk sizes that work well for my needs. That's a
>> whole other kettle of fish...
> ...
>> mark@c2stable ~ $ cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>> md6 : active raid5 sdc6[1] sdd6[2] sdb6[0]
>>       494833664 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>       bitmap: 0/2 pages [0KB], 65536KB chunk
>>
>> md3 : active raid6 sdd3[2] sdc3[1] sdb3[0] sde3[3] sdf3[5]
>>       157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>>
>> md7 : active raid6 sdd7[2] sdc7[1] sdb7[0] sde2[3] sdf2[4]
>>       395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>>
>> md126 : active raid1 sdb5[0] sdd5[2] sdc5[1]
>>       52436032 blocks [3/3] [UUU]
>
> Your problem isn't chunk sizes, but likely the 4 md/RAID devices atop
> the same set of physical disks.  If you have workloads that are
> accessing these md devices concurrently that will tend to wreak havoc
> WRT readahead, the elevator, and thus the disk head actuators.  If these
> are low RPM 'green' drives it will be exacerbated due to the slow
> spindle speed.
>

The drives are WD RE3 so at least I have that in my favor.

I started learning these lessons about multiple RAIDs on one set of
physical disks after building the machine. The plan I'm moving _very_
slowly toward is migrating from the md126 RAID1 which is currently
root to the md3 RAID6. I've built a new, bootable Gentoo install on
the RAID6. It's up and running and basically I think I just need to
move my user account and the stuff in /home and I'm there. With that
done md126 is gone.

md7 is manageable. It's all Virtualbox VMs which I backup externally
every week so I can do a backup of that, delete md126 & md7 and then
(hopefully) resize md3 larger.

md6 isn't used much. I mount it, do quick backups to it, and then
unmount. It's used about once a day and not in use most of the time. I
could probably get rid of it completely but I'd want another external
drive to replace it. Anyway, if's not overly important one way or
another.

All that said, I still don't really know if I was starting over today
how to choose a new chunk size. That still eludes me. I've sort of
decided that's one of those things that make you guys pros and me just
a user. :-)

Cheers,
Mark




> The purpose of RAID is to prevent data loss when a drive fails.  The
> purpose of striped RAID is to add performance atop that.  Thus you
> normally have one RAID per set of physical disks.  The Linux md/RAID
> driver allows you to stack multiple RAIDs atop one set of disks, thus
> shooting yourself in the foot.  Look at any hardware RAID card, SAN
> controller, etc, and none of them allow this--only one RAID per disk set.
>
> At this point you obviously don't won't to blow away your current setup,
> create one array and restore, as you probably don't have backups.
> Reshaping with different chunk sizes won't gain you anything either.  So
> about the only things you can optimize at this point are your elevator
> and disk settings such as nr_requests and read_ahead_kb.  Switching from
> CFQ to deadline could help quite a lot.
>
> --
> Stan
>
