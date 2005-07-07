From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bugreport mdadm-2.0-devel-1
Date: Thu, 7 Jul 2005 10:10:13 +1000
Message-ID: <17100.29413.164442.415932@cse.unsw.edu.au>
References: <1684363827.20050706121331@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maxim Kozover on Wednesday July 6
Sender: linux-raid-owner@vger.kernel.org
To: Maxim Kozover <maximkoz@netvision.net.il>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 6, maximkoz@netvision.net.il wrote:
> Hi!
> I'm getting problems with raid1 creation using new superblock format.
> Kernel used is 2.6.12.2 (with drivers/md and include/linux/raid taken from
> 2.6.13-rc1 to have a support for bitmaps and bug correction of md
> failing when starting resync), all compiled together.
> 
> For mdadm I tried both mdadm-2.0-devel-1 and mdadm-2.0-devel-1a.
> Compiles only if -Werror is removed from the Makefile, otherwise
> /usr/include/asm/byteorder.h:6:2: #warning using private kernel header; include <endian.h> instead!

Hmmm... I don't get that.  I must have different header files.  And my
<endian.h> doesn't provide the needed functionality :-(

Anyway, try
  http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-2.0-devel-2.tgz

(and remove -Werror).  It works for me with the command line that you
give.

NeilBrown
