From: Brad Campbell <brad@wasp.net.au>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 15:37:58 +0400
Message-ID: <435CC796.4000207@wasp.net.au>
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

> So - I'm thinking of the following backup scenario.  First, remount
> /dev/md0 readonly just to be safe. Then mount the two component
> paritions (sdc1, sdd1) readonly. Tell the webserver to work from one
> component partition, and tell the backup process to work from the
> other component partition. Once the backup is complete, point the
> webserver back at /dev/md0, unmount the component partitions, then
> switch read-write mode back on.

Why not do something like this ?

mount -o remount,ro /dev/md0 /web
mdadm --fail /dev/md0 /dev/sdd1
mdadm --remove /dev/md0 /dev/sdd1
mount -o ro /dev/sdd1 /target

<do backup here>

umount /target
mdadm -add /dev/md0 /dev/sdd1
mount -o remount,rw /dev/md0 /web

That way the web server continues to run from the md..
However you will endure a rebuild on md0 when you re-add the disk, but given everything is mounted 
read-only, you should not practically be doing anything and if you fail a disk during the rebuild 
the other disk will still be intact.

I second jurriaan's vote for rsync also, but I would be inclined just to let it loose on the whole 
disk rather than break it up into parts.. but then I have heaps of ram too..

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
