From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: split RAID1 during backups?
Date: Thu, 27 Oct 2005 10:04:02 +1000
Message-ID: <43601972.6020006@nighthawkrad.net>
References: <E1EU01c-0001sZ-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU01c-0001sZ-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
> Hi all,
> 

[...]

> So - I'm thinking of the following backup scenario.  First, remount
> /dev/md0 readonly just to be safe. Then mount the two component
> paritions (sdc1, sdd1) readonly. Tell the webserver to work from one
> component partition, and tell the backup process to work from the
> other component partition. Once the backup is complete, point the
> webserver back at /dev/md0, unmount the component partitions, then
> switch read-write mode back on.

Isn't this just the sort of scenario LVM snapshots are meant for ?  It 
might not help with the duration aspect, but it will mean your services 
aren't down/non-redundant for the entire time it takes to backup.

> Everything on this system seems bottlenecked by disk I/O. That
> includes the rate web pages are served as well as the backup process
> described above. While I'm always hungry for perforance tips, faster
> backups are the current focus. For those interested in gory details
> such as drive types, NCQ settings, kernel version and whatnot, I
> dumped a copy of dmesg output here: http://www.jab.org/dmesg

I think this might be one of those situations where SCSI really does 
offer a significant performance advantage, although if you're actually 
filling up that 500G, it'll be a quite a bit more expensive.

See if you can get hold of a reasonably sized array using SCSI drives 
and do some comparitive benchmarking.

You might also want to experiment with different filesystems, although 
that may not be feasible...

CS
