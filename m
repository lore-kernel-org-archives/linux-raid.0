From: Neil Brown <neilb@suse.de>
Subject: Re: Diagnosis of assembly failure and attempted recovery - help
 needed
Date: Mon, 31 May 2010 13:55:14 +1000
Message-ID: <20100531135514.10de5901@notabene.brown>
References: <AANLkTinWIekb9QHZB3sMrrvZE8CEFIcbHmMHE4eGzDIY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinWIekb9QHZB3sMrrvZE8CEFIcbHmMHE4eGzDIY@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: davef@davefisher.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 30 May 2010 10:20:41 +0100
Dave Fisher <davef@davefisher.co.uk> wrote:

> Hi,
> 
> My machine suffered a system crash, a couple of days ago. Although the
> OS appeared to be still running, there was no means of input by any
> external device (except the power switch), so I power cycled it. When
> it came back up, it was obvious that there was a problem with the RAID
> 10 array containing my /home partition (c. 2TB). The crash was only
> the latest of a recent series.
> 
> First, I ran some diagnostics, whose results are printed in the second
> text attachment to this email (the first attachment tells you what I
> know about the current state of the array, i.e. after my
> intervention).
> 
> The results shown in the second attachment, together with the recent
> crashes and some previous experience, led me to believe that the four
> partitions in the array were not actually (or seriously) damaged, but
> simply out of synch.
> 
> So I looked up the linux-raid mailing list thread in which I had
> reported my previous problem:
> http://www.spinics.net/lists/raid/msg22811.html
> 
> Unfortunately, in a moment of reckless hope and blind panic I then did
> something very stupid ... I applied the 'solution' which Neil Brown
> had recommended for my previous RAID failures, without thinking
> through the differences in the new context.
> 
> ... I realised this stupidity, at almost exactly at the moment when
> the ENTER key sprang back up after sending the following command:
> 
> $ sudo mdadm --assemble --force --verbose /dev/md1 /dev/sdf4 /dev/sdg4
> /dev/sdh4 /dev/sdi4
> 
> Producing these results some time later:
> 
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md_d0 : inactive sdi2[0](S)
>       9767424 blocks
> 
> md1 : active raid10 sdf4[4] sdg4[1] sdh4[2]
>       1931767808 blocks 64K chunks 2 near-copies [4/2] [_UU_]
>       [=====>...............]  recovery = 29.4% (284005568/965883904)
> finish=250.0min speed=45440K/sec
> 
> unused devices: <none>
> 
> 
> $ sudo mdadm --detail /dev/md1
> /dev/md1:
>         Version : 00.90
>   Creation Time : Tue May  6 02:06:45 2008
>      Raid Level : raid10
>      Array Size : 1931767808 (1842.28 GiB 1978.13 GB)
>   Used Dev Size : 965883904 (921.14 GiB 989.07 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun May 30 00:25:19 2010
>           State : clean, degraded, recovering
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : near=2, far=1
>      Chunk Size : 64K
> 
>  Rebuild Status : 25% complete
> 
>            UUID : f4ddbd55:206c7f81:b855f41b:37d33d37
>          Events : 0.8079536
> 
>     Number   Major   Minor   RaidDevice State
>        4       8       84        0      spare rebuilding   /dev/sdf4
>        1       8      100        1      active sync   /dev/sdg4
>        2       8      116        2      active sync   /dev/sdh4
>        3       0        0        3      removed
> 
> This result temporally raised my hopes because it indicated recovery
> in a degraded state ... and I had read somewhere
> (http://www.aput.net/~jheiss/raid10/) that 'degraded' meant "lost one
> or more drives but has not lost the right combination of drives to
> completely fail"
> 
> Unfortunately this result also raised my fears, because the
> "RaidDevice State" indicated that it was treating /dev/sdf4 as the
> spare and writing to it ... whereas I believed that /dev/sdf4 was
> supposed to be a full member of the array ... and that /dev/sdj4 was
> supposed to be the spare.
> 
> I think this belief is confirmed by these data on /dev/sdj4 (from the
> second attachment):
> 
>     Update Time : Tue Oct  6 18:01:45 2009
>     Events : 370
> 
> It may be too late, but at this point I came to my senses and resolved
> to stop tinkering and to email the following questions instead.
> 
> QUESTION 1: Have I now wrecked any chance of recovering the data, or
> have I been lucky enough to retain enough data to rebuild the entire
> array by employing /dev/sdi4 and/or /dev/sdj4?

Everything in -pre looks good to me.  The big question is, of course, "Can you
see you data?".

The state shown in pre-recovery-raid-diagnostics.txt suggests that since
Monday morning, the array has been running degraded with just 2 of the 4
drives being used.  I have no idea what happened to the other two, but the
dropped out of the array at the same time - probably due to one of your
crashes.

So just assembling the array should have worked, and "-Af" shouldn't really
have done anything extra.  It looks like "-Af" decided that sdf was probably
meant to be in slot-3 (i.e. the last of 0, 1, 2, 3) so it put it there even
though it wasn't needed.  So the kernel started recovery.

sdj hasn't been a hot spare since October last year.  It must has dropped out
for some reason and you never noticed.  For this reason it is good to put 
e.g. "spare=1" in  mdadm.conf and have "mdadm --monitor" running to warn you
about these things.


Some odd has happened by "post-recovery-raid-diagnostics.txt".  sdh4 and sdg4
are no longer in sync.  Did you have another crash on Sunday morning?

I suspect your first priority is to make sure these crashes stop happening.

Then try the "-Af" command again.  That is (almost) never the wrong thing to
do.  It only put things together in a way that looks like it was right
recently.

So I suggest:
 1/ make sure that whatever caused the machine to crash has stopped.  Replace
 the machine if necessary.
 2/ use "-Af" to force-assemble the array again.
 3/ look in the array to see if your data is there.
 4/ report the results.

NeilBrown


> 
> QUESTION 2: If I have had 'the luck of the stupid', how do I proceed
> safely with the recovery?
> 
> QUESTION 3: If I have NOT been unfeasibly lucky, is there any way of
> recovering some of the data files from the raw partitions?
> 
> N.B. I would be more than happy to recover data at the date shown by
> /dev/sdi4's update time. The non-backed-up, business critical data,
> has not been modified in several weeks.
> 
> I hope you can help and I'd be desperately grateful for it.
> 
> Best wishes,
> 
> Dave Fisher

