From: Thomas Garner <tlg1466@neo.tamu.edu>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 00:30:07 -0400
Message-ID: <435DB4CF.9080301@neo.tamu.edu>
References: <E1EU01c-0001sZ-00@toko.jab.org>
Reply-To: tlg1466@neo.tamu.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU01c-0001sZ-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Should there be any consideration for the utilization of the gigabit 
interface that is passing all of this backup traffic, as well as the 
speed of the drive that is doing all of the writing during this 
transaction?  Is the 18MB/s how fast the data is being copied over the 
network, or is it some metric within the host system?

Thomas

Jeff Breidenbach wrote:
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
