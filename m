From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: problem w/crazy config
Date: Wed, 16 Feb 2005 18:48:42 +0800
Message-ID: <4213250A.1030402@fastmail.co.uk>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm using a somewhat stupid config. due to lack of dosh.

I have two promise PCI dual-channel EIDE cards, each with 4 drives on.

I have 4 200GB drives in a RAID-5 array as masters of each channel, and 
4 80GB drives in a RAID-5 array as slaves of each channel.

I also upgraded mdadm to mdadm-1.9.0-1 to fix the problem with 'auto' in 
mdadm.conf, but I'm not sure if that actually makes any difference.

In any case, the problem is that one of my drives keeps going 'dirty'. I 
have since commented out the other array in fstab so it isn't being 
used, and it works fine now.

I did a 'smartctl -t long' and used the ibm disk tool thingy to test the 
drive, and both say it is fine.

I figured it would be OK to make one array as master devices and one 
array as slaves because I 'know' I will 'never' access both at the same 
time - at least, not intensively.

Can anyone suggest why this might be happening?

Max.
