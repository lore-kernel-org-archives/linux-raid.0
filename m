From: Tyler <pml@dtbb.net>
Subject: raid sync looping filling log files
Date: Wed, 27 Apr 2005 04:14:47 -0700
Message-ID: <426F7427.3070504@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The other day i ran across a problem trying to rebuild a raid using a 
spare, but didn't seem to be getting anywhere.  Below is what is in the 
log files, over and over and over, eventually filling up the small 2gb 
root partition with log files (six hundred plus megabytes worth).  
Thankfully this was just a new raid, and didn't have any data on it yet, 
and i found the easiest way to fix it, was to stop the array, and 
re-create it.  Currently its syncing, and I will write the list again if 
it happens again.. but I am curious if this is a known problem, and what 
might have caused it, as I have other raid5's that i hope don't have the 
same problem one day.

.<6>md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 195360896 blocks.
md: md0: sync done.

over and over and over, the above message hits the logs several times 
per second.

Regards,
Tyler.
