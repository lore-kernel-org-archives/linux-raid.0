From: Brad Campbell <brad@wasp.net.au>
Subject: Re: journaling raidreconf status?
Date: Thu, 12 Aug 2004 12:05:22 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411B24C2.9040000@wasp.net.au>
References: <411B0DB6.3000605@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <411B0DB6.3000605@earthlink.net>
To: Mike Baynton <mikeb414@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Baynton wrote:
> Just politely asking where development of the raidreconf that can 
> semi-gracefully deal with power failures (discussed in 
> http://marc.theaimsgroup.com/?l=linux-raid&m=108287727504009&w=2 ) is, 
> it would be pretty significant to my situation (home system with no 
> power backup and no way to back up 100% of my stuff.)

It's paused while I save up for a couple of new hard disks. One took a dive onto a tiled floor and 2 
days ago one of the others chucked a serious wobbly with SMART telling me that it can't write data 
to the media.
It's on my list although at the moment I'm spending most of my time looking at 
integrating/interfacing raidreconf with mdadm to get it away from raidtools.

raid-6 support, > 2TB and mdadm integration are my priorities at the moment.

I did manage to resize a 1.6TB raid-5 into a 2.2TB raid-5 a while back, but then I also had a full 7 
drive tar backup of the array so I was not that concerened about power failures.

I have also added off-line parity block checking/reconstruction to the todo list for both raid-5 and 
raid-6 as I figure if we could build the parity blocks as part of the reconf and then boot into a 
completely clean new raid it is a bit safer in the long run. (Plus I'd like to be able to take my 
array offline and do a parity block integrity check while doing a read test of every sector of every 
drive, that way if one drive has a read error or two, we may be able to force a reallocation on that 
disk and re-write that block with recreated data)

Don't get too excited though as I'm struggling just getting raid-6 and mdadm support happening at 
the moment (time and all that)

Regards,
Brad

