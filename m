From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: reducing the number of disks a RAID1 expects
Date: Mon, 10 Sep 2007 14:29:46 +1200
Message-ID: <46E4AC1A.3010509@sauce.co.nz>
References: <46E49991.9000000@getsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E49991.9000000@getsu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

J. David Beutel wrote:
> My /dev/hdd started failing its SMART check, so I removed it from a RAID1:
> 
> # mdadm /dev/md5 -f /dev/hdd2 -r /dev/hdd2
> 
> Now when I boot it looks like this in /proc/mdstat:
> 
> md5 : active raid1 hdc8[2] hdg8[1]
>      58604992 blocks [3/2] [_UU]
> 
> and I get a "DegradedArray event on /dev/md5" email on every boot from 
> mdadm monitoring.  I only need 2 disks in md5 now.  How can I stop it 
> from being considered "degraded"?  I added a 3rd disk a while ago just 
> because I got a new disk with plenty of space, and little /dev/hdd was 
> getting old.
> 
> mdadm - v1.6.0 - 4 June 2004
> Linux 2.6.12-1.1381_FC3 #1 Fri Oct 21 03:46:55 EDT 2005 i686 athlon i386 
> GNU/Linux
> 

Have a look at the "Grow Mode" section of the mdadm man page.

It looks as though you should just need to use the same command you used 
to grow it to 3 drives, except specify only 2 this time.

Regards,

Richard
