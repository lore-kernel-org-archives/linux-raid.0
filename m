From: John Hendrikx <hjohn@xs4all.nl>
Subject: Selective spin-up
Date: Sun, 22 Jan 2006 03:19:45 +0100
Message-ID: <43D2EBC1.1000007@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently extended my raid array with a 9th drive, and I find that the 
300 watt PSU I use is insufficient to start the system.  What happens is 
that I activate the machine, the machine starts powering up for 3 
seconds orso (spinning all the hard drives up about half way) then power 
cuts out.  I've heard that it is possible to spin up disks one at a time 
or in groups, but cannot find any such option in the BIOS (Asus A8N-E 
board).  Any ideas?

What's fun however is that if I press the power button again immediately 
after it powers down (while the drives are still half way spinned up), 
it will have enough power to spin up the disks all the way, and the 
system starts normally.  It runs rock solid after that.





