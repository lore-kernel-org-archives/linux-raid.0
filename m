From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm RAID5 Grow
Date: Thu, 5 Oct 2006 14:35:43 +1000
Message-ID: <17700.35743.152233.689956@cse.unsw.edu.au>
References: <6652499.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mickg on Wednesday October 4
Sender: linux-raid-owner@vger.kernel.org
To: mickg <mickg@mickg.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 4, mickg@mickg.net wrote:
> 
> I have been trying to run: 
> mdadm --grow /dev/md0 --raid-devices=6 --backup-file /backup_raid_grow
> I get:
> mdadm: Need to backup 1280K of critical section..
> mdadm: /dev/md0: Cannot get array details from sysfs

It shouldn't do that.... 
Can you 
  strace -o /tmp/trace -s 300 mdadm --grow .....

and send a copy of /tmp/trace.  I'd like to see how far it gets at
reading information from sysfs.

> 
> Would it need to be unmounted to work properly (It is currently mounted
> under lvm)?

No.  unmounting isn't needed and won't make any difference.

NeilBrown
