From: Michael Hardy <mhardy@h3c.com>
Subject: raid5 + smartctl + uncorrectable read error + single-block-resync
 ?
Date: Thu, 03 Jun 2004 12:34:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BF7D45.3020403@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've got smartd running (great tool: http://smartmontools.sf.net) and it 
just alerted me to an unreadable sector in one drive on a software raid5 
array I have (linux kernel 2.4.18, I believe, I know its old)

smartctl is capable of telling me exactly what LBA on the drive is 
unreadable, and I was reading this, which indicates it would be possible 
to remap that single block:

http://cgi.cse.unsw.edu.au/~neilb/me/SoftRaid/01084418693

...but I'm guessing that's just an idea, since its from May 13th 2004 
and there a couple of indications of kernel hacking in it ("maintain a 
list of bad blocks", check thresholds, work on the recovery thread, etc)

Is there any motion to get raid to implement this?

If there is, I guess my only input (I'm a sysadmin level hacker, not a 
kernel hacker) would be to say - there should be some interface for 
external utilities to "educate" the linux raid module that a specific 
disk has a specific sector going bad.

That way you could script smartd to take the results of a failed offline 
SMART test and send the bad LBAs to the raid module for read tests and 
resync

Oh, and I want a pony. ;-) I couldn't resist asking that, since this is 
basically a gigantic feature request

In the meantime, I guess logically failing the drive and re-adding it is 
the only way to remap the sectors, right?

-Mike
