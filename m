From: Nick Lindsell <nick@nexnix.co.uk>
Subject: Re: Am I dead?  NO!  (yaay!)
Date: Mon, 02 Dec 2002 13:42:45 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.0.20021202133235.069a5c98@core>
References: <20021202125611.GD6155@unthought.net>
 <5.1.1.6.0.20021202124116.0699afe8@core>
 <5.1.1.6.0.20021202114409.06af4530@core>
 <5.1.1.6.0.20021202114409.06af4530@core>
 <5.1.1.6.0.20021202124116.0699afe8@core>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.1.6.0.20021202131942.0697d690@core>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to Jakob I have my data back.  <phew>.
Just for the record I made a raidtab with the following:-

raiddev /dev/md5
	raid-level 5
	nr-raid-disks 3
	chunk-size 64k
	persistent-superblock 1
	nr-spare-disks 0
	device /dev/sda2
	raid-disk 0
	device /dev/sdb2
	raid-disk 1
	device /dev/sdc2
	raid-disk 2

and ran "raidstart /dev/md5". Looking in the syslog
showed that the raiddev was wrong - needed to be /dev/md2.
So I corrected that and ran "mkraid --really-force /dev/md2"
The array now corrected I was able to mount the root filesystem
and copy the original raidtab to my repair disk and run mkraid
on the other partitions. I now have my data.

Finally, what could have caused this? I'm pretty confident about the
hardware (I've not replaced anything yet) - could a power outage have
broken my arrays?

many thanks
nick.





















