From: David Anderson <david.anderson@calixo.net>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 01:37:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9DBA46.7020806@calixo.net>
References: <3F9DAD4C.3000002@verizon.net>
Reply-To: david.anderson@calixo.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F9DAD4C.3000002@verizon.net>
To: linux-raid@vger.kernel.org
Cc: berk walker <berk.walker@verizon.net>
List-Id: linux-raid.ids

Hi there.

First of all, as a satisfied swraid5 user for some time, I would like to 
point out someting: data loss is not just about the redundancy of a raid 
array. If you bought your disks from a faulty batch and they all die, 
you're still hosed. Raid is absolutely no excuse for not backing up data.

Now, on to the questions ;)

> is there an advantage to >more< than 1 spare drive?

If several disks die _in a row_. ie one dies, a spare is synced, a 
second dies after the sync. A fairly rare occurence I reckon (in my 
experience, multiple failures come in flocks, not in rows). And if it 
does happen, you'll have a little degraded mode time while you add a 
clean disk and add it to the array. No big deal _if_ you have an 
efficient backup routine.

> .. more than 3 drives in mdx?

Depends on how many you have, and how much failure you want your array 
to tolerate. The more you add disks, the more your array becomes 
intolerant to failure (more active disks means more potential failure 
points, but the threshold of 1 failed disk only remains). But you "lose" 
less space to parity.
In short, if you can afford it, stick to 3-disk raid5 with a few spares.

> why not cp old boot/root/whatever drive to mdx after 
> booting on floppy?

I wasn't aware of anything against that... When I got hold of higher 
capacity disks I created a new larger raid5 array and copied the old to 
the new (not a raw copy of course, a copy at the file system level).
But then again, my array was for a special mountpoint (/var/data), so I 
could mount it readonly and copy it. Maybe the warnings against copying 
/ were because of the write issue which could leave you with an 
inconsistent copy?

> is there an advantage to having various mdx's allocated to various 
> /directories?..ie: /home, var, /etc

I don't see any myself. The only advantage would be less data loss in 
the event of a failure, but since you backup on a regular basis, a 
catastrophic failure shouldn't bring you down too long anyway.

A final reminder: Have efficient backup routines!! Raid will help you 
prevent disasters, but when a disaster does occur (not if, when), you'll 
need fast recovery with minimal loss.

David Anderson

PS: did I tell you about the importance of backups? ;)


