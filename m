From: Neil Brown <neilb@suse.de>
Subject: Re: 3-disk RAID1 - only two disks active
Date: Wed, 16 Nov 2005 10:01:10 +1100
Message-ID: <17274.26806.260020.822459@cse.unsw.edu.au>
References: <20051115152622.A2237@turing.netspan.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from vherva@turing.netspan.fi on Tuesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, vherva@turing.netspan.fi
List-Id: linux-raid.ids

On Tuesday November 15, vherva@turing.netspan.fi wrote:
> I had two disks taken off from the three-disk raid set (hda,hdb,hdc - hdc
> failed by itself, hdb was marked bad with raidsetfaulty). When the new disks
> were added back to the set (with raidhotadd), only two of them became active
> and one remained as a hot spare.
> 
> I there a way to reconfigure all three to become active again?

It looks from the details you gave that it never was a three-disk
set.  It was only ever two-disk, possibly with a spare.

> 
> This is kernel 2.4.32-rc1.

With a recent 2.6 kernel, you could
   mdadm --grow --raid-disk=3 /dev/md1
but with a 2.4 kernel, the only option is to re-create the array:

  mdadm --stop /dev/md1
  mdadm --create /dev/md1 --level=1 --raid-disks=3 /dev/hda1 /dev/hdc1 missing
  mdadm /dev/md1 --add /dev/hdb1

NeilBrown
