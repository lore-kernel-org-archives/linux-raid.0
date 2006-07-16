From: Neil Brown <neilb@suse.de>
Subject: Re: Can't add disk to failed raid array
Date: Sun, 16 Jul 2006 20:19:18 +1000
Message-ID: <17594.4774.17991.656057@cse.unsw.edu.au>
References: <200607152056.55090.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Waldo on Saturday July 15
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 15, pwaldo@waldoware.com wrote:
> Hi all,
> 
> I have a RAID6 array where a disk went bad.  I removed the old disk, put in an 
> identical one, and repartitioned the new disk.  I am now trying to add the 
> new partition to the array, but I get this error: 
> 
> [root@paul ~]# mdadm --add /dev/md1  /dev/hdd2
> mdadm: add new device failed for /dev/hdd2 as 2: Invalid argument
> 
> When I perform that command, /var/log/messages says this:
> Jul 15 20:48:39 paul kernel: md: hdd2 has invalid sb, not importing!
> Jul 15 20:48:39 paul kernel: md: md_import_device returned -22


Rings a bell, but I cannot quite place it..

What version of mdadm are you running?  If not 2.5.2, try that.

...
>     Number   Major   Minor   RaidDevice State
>        0       3        2        0      active sync   /dev/hda2
>        1      22        2        1      active sync   /dev/hdc2
>    3157553       0        0        5      removed
     ^^^^^^^
That looks very odd.  If 2.5.2 does that I'll have to look into why.

NeilBrown


>        3      33        2        3      active sync   /dev/hde2
>        4      34        2        4      active sync   /dev/hdg2
>        5       8        2        5      active sync   /dev/sda2
>        6       8       18        6      active sync   /dev/sdb2
> 
> [root@paul log]# uname -rv
> 2.6.17-1.2139_FC5 #1 Fri Jun 23 12:40:16 EDT 2006
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
