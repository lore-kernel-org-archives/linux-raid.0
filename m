From: Who Knows <quien-sabe@metaorg.com>
Subject: Okay, finally saved by RAID now what?
Date: Mon, 19 Jul 2004 21:12:19 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40FC7F83.1080003@metaorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This morning going through my logs/mail I first noticed a down/up alert 
from my http monitor. I rarely get them but it had been awhile.

Next browsing the daily logwatch report I saw that the server had 
rebooted. Again although this is VERY rare, not unknown to happen, even 
big data centers occasionaly have a power outage.

Further down in the log however, I saw that one of the two drives I had 
configured in a RAID1 array didn't seem to be working as it was logging 
errors and had been marked as failed when the array started on boot, but 
despite the errors all the services seemed to be up and working, so I 
patted myself on the back for deciding to deploy the server with 
software RAID, and went for a second cup of coffee.

Upon returning I decided to figure out how to use the raidtools and shut 
the bad drive down. Okay I know the HOWTO said to test it all when I 
first set it up, but heck...I figured it would either work or not...and 
it seems to have worked.

I read a couple of howto's and decided I needed to install mdadm. Then 
following the procedures outlined I removed the two failing partitions 
from /dev/md0 and /dev/md1 respectively. After this seemed successfully 
done the number of hdc errors filling my log did diminish greatly, but I 
still see a good many errors to the drive that is supposedly no longer a 
member of either md.

The server has continued to degrade throughout the day however, as 
xinetd and mysqld have both just died which has never happened before. I 
was able to restart them, but of course now I am suspecting other issues 
like a flaky powersupply.

My question here is, why is the disk still logging errors after being 
removed from the two raid arrays.

Regards,
Jim

-- 
Helping Business Profit From Technology
http://www.aidant.net

