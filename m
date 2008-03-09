From: Neil Brown <neilb@suse.de>
Subject: Re: auto-assembling arrays without a configuration file
Date: Mon, 10 Mar 2008 10:25:43 +1100
Message-ID: <18388.29175.293547.438@notabene.brown>
References: <20080308004009.GA32251@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Saturday March 8
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday March 8, keld@dkuug.dk wrote:
> I want to assemble the root partition automatically, without having 
> a configuration file. Is that possible? 
> 
> mdadm -A --scan 
> 
> does seem to require a configuration file.
> 
> On the other hand, I think all info needed is available in the super
> blocks, and a traversal of the partitions present on the system (ala
> fdisk -l) could give consistent naming - there seems to be no /dev/md
> association available in the superblock.

The information that is not present in the super blocks is which
array you want to assemble.
This becomes particularly important if you move some drives from one
machine to another.
If the target machine and a "/dev/md0" and the drives that are moved
are from a "/dev/md0" on the source machine, then any auto-assembly on
the target machine has not obvious way to know which set of "/dev/md0"
devices to assemble.

For that reason mdadm knows about a "homehost".  You can tag each
array with a hint about what host it expects to be assembled on.
If you run

  mdadm -As --homehost=`hostname`

then it will auto-assemble any arrays for the current host.
If you arrays haven't been tagged for at particular host, then

  mdadm -As --homehost=`hostname` --auto-update-homehost

will automatically tag everything that is found for the current host.
This is not something that should be done automatically, but it OK to
do one when you know you haven't done anything interesting with
devices.

NeilBrown
