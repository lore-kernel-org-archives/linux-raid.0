From: Ben Bucksch <linux.news@bucksch.org>
Subject: md dropping disks too early (was: Use RAID-6!)
Date: Wed, 17 Apr 2013 01:42:09 +0200
Message-ID: <516DE1D1.1050704@bucksch.org>
References: <15345091.8.1366130671716.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15345091.8.1366130671716.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The purpose of my RAID system is 1) to protect against hardware disk 
failures, both that a harddrive is entirely broken and won't read at all 
anymore. I know that this *will* happen at some point, but it's still a 
fairly rare event. The chance that 2 out of 8 drives go bad *in the same 
week* (!) is very small.

I am also concerned about 2) bit errors and silently broken sectors, and 
want my RAID to detect and fix those. I am not sure that Linux md does that.

There is a good chance that a controller or some wiring is bad, and many 
disks fail at the same time. Neither RAID5 nor RAID6 will protect 
against that, but a re-cabling should fix it without data loss, as the 
data on the disks is not affected.

Given that this RAID array is for my personal use, and the amount of 
disk slots in a machine is limited, and drives need 24/7 power, too, a 
RAID5 is the right choice for me, given the above situation.

---

BUT - and this is the main purpose of my post - Linux md causes problems 
by itself:

In my case, and from what I read in other posts in forums and on this 
mailing lists, many people have the problem that Linux md simply drops a 
disk from the RAID5, even though there was NOT an unrecoverable hardware 
failure. There are many situations where this happens:

 1. Upgrade (my case)
 2. Disk temporarily not accessible
 3. Disk has bad sectors (but the other content can still be read)

None of these should be fatal. But it seems that md marks the disk as 
faulty and requires a resync. There does not seem to be any way to get a 
disk that was once marked spare or faulty back into the array, unless I 
do a resync. (If somebody knows a way, please show me, see thread 'Disk 
wrongly marked "spare", need to force re-add it'.) Now, the resync needs 
to read all data from all disks and can be the event that uncovers a 
problem with one of the other disks. That disk is then dropped as well, 
again with no way to re-add, and the array is entirely lost. However, 
that is completely unnecessary, given that there are often only a few 
bad sectors, and these - while bad - are no reason to say goodbye to 
several TB of data.

Essentially, by being overly cautious with the data and dropping disks 
too early and being too instant about it, md actually achieves the 
opposite of what it was made for. It was intended to protect my data 
against disk problems, but md actually makes minor or even temporary 
problems resulting in a total dataloss.

I'm not overstating, because that's the exact situation I am in right 
now. I have only 1 disk that's actually failing, and a RAID5, so in 
theory I am fine. But I see no way to safely get at my data anymore. My 
array is offline and I have no idea how to get it online again without 
risking to lose all data.

And worst: the whole situation was triggered by md dropping a disk from 
the array that is wasn't even failing, but just because I upgraded. :-(

Ben

