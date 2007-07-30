From: Max Amanshauser <linux-raid@lambdalifting.org>
Subject: Re: Homehost suddenly changed on some components
Date: Mon, 30 Jul 2007 21:01:49 +0200
Message-ID: <B6D3B554-A931-4CA4-8779-E2F9510191AC@lambdalifting.org>
References: <A2BCA40B-B212-4ECD-BEE1-29C50A7A13ED@lambdalifting.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2BCA40B-B212-4ECD-BEE1-29C50A7A13ED@lambdalifting.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Amanshauser <linux-raid@lambdalifting.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For the record:

After reading in the archives about similar problems, which were  
probably caused by something else but still close enough, I recreated  
the array with the exact same parameters from the superblock and one  
missing disk.

 > mdadm -C /dev/md0 -l 5 -n 10 -c 64 -p ls /dev/sdb1 /dev/sdd1 /dev/ 
sde1 /dev/hde1 /dev/hdb1 /dev/hdf1 /dev/hdh1 /dev/hdg1 /dev/sdc1 missing

Seems to have done the trick, fsck is working right now.


Funny things seem to happen to the superblocks more often than I  
thought. Recreating with one missing disk appears more like a hack  
than a solution to me. Maybe mdadm should have some kind of explicit  
superblock manipulation, like copying from other components or  
importing/exporting from/to a file, so such problems can be solved in  
a safe way?

Just a quick thought. :)


--
Regards,
Max Amanshauser

