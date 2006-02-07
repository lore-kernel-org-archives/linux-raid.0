From: dean gaudet <dean@arctic.org>
Subject: Re: Raid5 & Debian Yaird Woes
Date: Mon, 6 Feb 2006 18:52:48 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0602061843510.12302@twinlark.arctic.org>
References: <200602031229.37972.mylists@blue-matrix.org>
 <200602040958.20183.mylists@blue-matrix.org> <Pine.LNX.4.64.0602031622100.19604@twinlark.arctic.org>
 <200602050907.31735.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200602050907.31735.mylists@blue-matrix.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lewis Shobbrook <mylists@blue-matrix.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Feb 2006, Lewis Shobbrook wrote:

> On Saturday 04 February 2006 11:22 am, you wrote:
> > On Sat, 4 Feb 2006, Lewis Shobbrook wrote:
> > > Is there any way to avoid this requirement for input, so that the system
> > > skips the missing drive as the raid/initrd system did previously?
> >
> > what boot errors are you getting before it drops you to the root password
> > prompt?
> 
> Basically it just states waiting X seconds for /dev/sdx3 (corresponding to the 
> missing raid5 member). Where X cycles from 2,4,8,16 and then drops you into a 
> recovery console, no root pwd prompt.
> It will only occur if the partition is completely missing, such as a 
> replacement disk with a blank partition table, or a completely missing/failed 
> drive.
> > is it trying to fsck some filesystem it doesn't have access to?
> 
> No fsck seen for bad extX partitions etc.

try something like this...

	cd /tmp
	mkdir t
	cd t
	zcat /boot/initrd.img-`uname -r` | cpio -i
	grep -r sd.3 .

that should show us what script is directly accessing /dev/sdx3 ... maybe 
there's something more we can do about it.

i did find a possible deficiency with the patch i posted... looking more 
closely at my yaird /init i see this:

	mkbdev '/dev/sdb' 'sdb'
	mkbdev '/dev/sdb4' 'sdb/sdb4'
	mkbdev '/dev/sda' 'sda'
	mkbdev '/dev/sda4' 'sda/sda4'

and i think that means that "mdadm -Ac partitions" will fail if one of my 
root disks ends up somewhere other than sda or sdb... because the device 
nodes won't exist.

i suspect i should update the patch to use mdrun instead of "mdadm -Ac 
partitions"... because mdrun will create temporary device nodes for 
everything in /proc/partitions in order to find all the possible raid 
pieces.

-dean
