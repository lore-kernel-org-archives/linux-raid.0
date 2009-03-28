From: Patrick Ringl <patrick.ringl@gmx.de>
Subject: 2.6.29 - raid10 issue - spares do not get synched automatically
Date: Sat, 28 Mar 2009 13:37:04 +0100
Message-ID: <49CE19F0.5040809@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am using 2.6.29 on a debian lenny. Anyway, I am having problems with a 
raid10 sandbox setup consisting of 4 loopback devices. To make a long 
story short:

I created a raid10 array with all these 4 devices (loop0-loop3)
then I set two devices faulty, removed them .. checked if I can still 
write to the array (which I could, so I/O errors, nothing in dmesg):

BUT - here it comes: once I am trying to (re)add them (I zero'ed the 
superblock before) they're only getting added as spares and the array 
will not sync.

Here's the logfile with mdadm -D /dev/md0 in between so one can see what 
is going on:

http://paste.debian.net/31758/


Any ideas?


PS: Please CC to me since I am not subscribed.


regards,
Patrick
