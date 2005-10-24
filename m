From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 15:05:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0510241444330.12711-100000@firewall2.tmr.com>
References: <E1EU01c-0001sZ-00@toko.jab.org>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU01c-0001sZ-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Oct 2005, Jeff Breidenbach wrote:

> 
> Hi all,
> 
> I have a two drive RAID1 serving data for a busy website. The
> partition is 500GB and contains millions of 10KB files. For reference,
> here's /proc/mdstat
> 
> Personalities : [raid1]
> md0 : active raid1 sdc1[0] sdd1[1]
>       488383936 blocks [2/2] [UU]
> 
> For backups, I set the md0 partition to readonly and then use dd_rescue
> + netcat to copy the parition over a gigabit network. Unfortuantely,
> this process takes almost 10 hours. I'm only able to copy about 18MB/s
> from md0 due to disk contention with the webserver. If I had the full
> attention of a single disk, I could read at nearly 60MB/s.

Sounds like the wrong solution... how about this:
  Get one more drive of the same size, and at backup time add it to the 
mirror. After rebuild take it back out of the mirror. Put a remount r/o in 
there at your discresion. Now you have a valid copy of your data, back 
that up as you like.

  If you want to try something "which used to work" see nbd, export 500GB 
from another machine, add the network block device to the mirror, let it 
sync, break the mirror. Haven't tried since 2.4.19 or so.

  The real problem is that you should be able to search the disk faster 
than that, identify the modified files, and do incrementals regularly. I 
have 400GB of 2-5MB files, and it takes minutes, not hours, to scan them. 
That's PATA not SATA, I suspect there may still be issues there, SATA is 
not as well explored, certainly not by me!

> 
> So - I'm thinking of the following backup scenario.  First, remount
> /dev/md0 readonly just to be safe. Then mount the two component
> paritions (sdc1, sdd1) readonly. Tell the webserver to work from one
> component partition, and tell the backup process to work from the
> other component partition. Once the backup is complete, point the
> webserver back at /dev/md0, unmount the component partitions, then
> switch read-write mode back on.
> 
> Am I insane? 

I don't like the failure scenarios on that one, personally.

One last thought, the slowness of the disk may result from the extended 
times to do directory operations which you mention. You don't have all 
those thousands of files in a single directory, do you? How long does it 
take to do an unsuccessful "find" from the root? Like "find /base -name 
spvgZy3G" or other name it's not going to find.

> 
> Everything on this system seems bottlenecked by disk I/O. That
> includes the rate web pages are served as well as the backup process
> described above. While I'm always hungry for perforance tips, faster
> backups are the current focus. For those interested in gory details
> such as drive types, NCQ settings, kernel version and whatnot, I
> dumped a copy of dmesg output here: http://www.jab.org/dmesg
> 
> Cheers,
> Jeff
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

