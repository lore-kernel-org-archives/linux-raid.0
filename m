From: Neil Brown <neilb@suse.de>
Subject: Re: raidtools mdadm conversion query
Date: Mon, 16 Jan 2006 08:43:37 +1100
Message-ID: <17354.49673.910151.270425@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0601151237480.27906@homer22.u.washington.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Darwin O.V. Alonso on Sunday January 15
Sender: linux-raid-owner@vger.kernel.org
To: "Darwin O.V. Alonso" <dalonso@u.washington.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 15, dalonso@u.washington.edu wrote:
> 
> I upgraded a system from FC2 to FC4,
> The system had a working raidtools linear raid partition 
> (md0 = sda1 and sdb1)
> I now need to get the partition going using mdadm, while maintaining the data.
> 
> I used raidtabtomdadm.sh to create /etc/mdadm.conf
> ================================================================
> DEVICE partitions
> ARRAY /dev/md0 level=linear num-devices=2 UUID=ba95446a:6fe4d353:9ba80e0f:181c0117 auto=yes
> ================================================================
> but I am unsure of the next step. I imagine I do somethink like:
>   mdadm --assemble --verbose /dev/md0 --level=linear --raid-devices=2 /dev/sda1 /dev/sdb1
> but I don't want to blunder ahead and wipe out the existing data.

Just
  mdadm --assemble /dev/md0
or even
  mdadm -As

should be all you need.

NeilBrown
