From: Lieven Van Acker <lieven.vanacker@ugent.be>
Subject: modifying a running array
Date: Mon, 15 Nov 2004 13:35:01 +0100
Message-ID: <1100522100.31575.12.camel@xstar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey folks,

I didn't find any direct pointers on this issue, so maybe you experts
can advice me...

I was setting up a system, had only one disk at setup time but wanted to
configure raid 1 in advance...

so I used 

mdadm --create /dev/md0 --force --run --level=1 --raid-devices=1
/dev/sda1

to create my array.

Now as I have the second disk available, after duplicating the partition
table I wanted to add add /dev/sdb1 to the array. 

But 

mdadm /dev/md0 -a /dev/sdb1 

adds this device as a spare one, so the number of active devices stays
1. I could use the build command to reinitialise the array, but I wonder
if there's a way to extend the raiddevice while it's running?

Is there any way to arrange this?

Regards,

Lieven

