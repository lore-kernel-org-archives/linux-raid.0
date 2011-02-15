From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: recovering from an aborted reshape op - boot messages
Date: Tue, 15 Feb 2011 13:16:36 +1100
Message-ID: <20110215131636.3ed62e81@notabene.brown>
References: <20110215124107.7b6edea3@notabene.brown>
	<729509.31129.qm@web65105.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <729509.31129.qm@web65105.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 18:04:01 -0800 (PST) Gavin Flower <gavinflower@yahoo.com>
wrote:

> output from: fsck.ext4 -f -n /dev/md1
> 
> e2fsck 1.41.12 (17-May-2010)
> The filesystem size (according to the superblock) is 76799952 blocks
> The physical size of the device is 76799616 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort? no
> 
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -9626 -(9728--9752) +(405344--405369)
> Fix? no
> 
> 
> I suspect that it might be simple to recover.  Are you able to advise on this, or should I run further diagnostics, or ask elsewhere.
> 

No I am not.

e2fsck has a very good reputation so if it seems to claim that it can fix
things then it almost certainly can.

Did you try asking on ext3-users@redhat.com ??

NeilBrown
