From: dean gaudet <dean@arctic.org>
Subject: Re: Auto-assembling arrays using mdadm
Date: Thu, 9 Mar 2006 13:51:01 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603091344010.32502@twinlark.arctic.org>
References: <20060309192334.12864.qmail@web35314.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060309192334.12864.qmail@web35314.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Puttergill <puttergi@yahoo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 9 Mar 2006, Sean Puttergill wrote:

> This is the kind of functionality provided by kernel
> RAID autodetect.  You don't have to have any config
> information provided in advance.  The kernel finds and
> assembles all arrays on disks with RAID autodetect
> partition type.  I want to do the same thing, but with
> mdadm.

you know i've been bitten by that several times... the kernel sees the 
autodetect partition type of a disk which used to belong in another box 
(which for various reasons i've not yet been able to zero the old raid 
superblock)... and brings up a raid minor which conflicts with another 
array already present in the system... which causes device renaming to 
occur and can mess up the boot.  (although if i'm using UUIDs or labels 
for mounting the filesystems it can almost work -- there are still a few 
cases where those don't help... such as xfs external log partition.)

i suppose what i suggested doesn't do what you want... but i prefer not 
using kernel autoassembly these days because of the above problem.

the 1.12 man page has more examples which can help you...

	echo "DEVICE partitions" >tmp.mdadm.conf
	mdadm --detail --scan --config=tmp.mdadm.conf >>tmp.mdadm.conf
	mdadm --assemble --scan --config=tmp.mdadm.conf

i think that'll do what you want...

-dean
