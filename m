From: Jeremy Huddleston <jeremyhu@uclink4.berkeley.edu>
Subject: Getting the spare disks back to being spare disks
Date: Sat, 23 Nov 2002 15:28:05 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DE00F05.7050803@uclink4.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have moved to a RAID 5 setup in my linux box with 4 drives set to 
master on 4 IDE channels, and one spare drive as the slave on one of 
those channels.  In setting things up, I marked one of the 'master' 
drives as 'failed-disk' in my raidtab so that I could copy the data from 
that disk onto the raid then raidhotadd it in once the data had been 
copied over and my system was running entirely on the raid.

So, when I mkraid'd the array, the spare disk was used in liu of the 
failed disk as I would suspect.  I copied over all my data to the raid, 
rebooted, partitioned the formerly 'failed-disk' properly, changed 
'failed-disk' to 'raid-disk' in /etc/raidtab, and 'raidhotadd'd it back 
into the array.  I expected the array to reconstruct on this disk and 
put the spare-disk back as a spare, but that's not the case.  Now, the 
newly added disk seems to be the spare, and the 'slave' disk is still in 
the array (which makes for bad performance).  How can I tell the array 
to replace the slave disk with the disk that I just added?  I figure I 
could just unplug the slave and let it reconstruct, but that doesn't sit 
well with me.

