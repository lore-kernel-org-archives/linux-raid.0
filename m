From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: strangre drive behaviour.
Date: Sun, 06 Mar 2005 15:00:55 +0800
Message-ID: <422AAAA7.6080106@fastmail.co.uk>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been reconfiguring my raid drives.

I used to have it this way...

4 Parallel IDE i/f's
each i/f's master was a WD800 in a RAID5
each i/f's slave was a WD2000 in a RAID5

I am removing the WD800 array and moving the WD2000 array to masters; so 
there are no slaves.

However, in the process, one of my WD2000's seems to be having problems.

It seems to work as a slave device, but not as a master. I have tried 
many combinations of interfaces/cables/power/etc.

I can even put it on an i/f on it's own as a slave device, and it seems 
to work (the device name changes to show that it is actually the 2nd 
device on the channel - ie when testing it on the motherboard, it shows 
up as hdd, not hdc).

I am not sure what to do.

Can I just make it a slave device? How will that effect performance?

Any ideas?

Max.
