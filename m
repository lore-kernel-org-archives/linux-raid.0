From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 02:07:27 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310280207.27787.maarten@vbvb.nl>
References: <3F9DAD4C.3000002@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F9DAD4C.3000002@verizon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 28 October 2003 00:42, berk walker wrote:
> The purpose of my going to raid is to ensure, short of a total
> meltdown/fire, etc, data loss prevention.  If my house and business
> burn, I'm hosed anyway.
>
> I am buying 4 maxtor 40 gb/200mb ultra 133 drives, and another promise
> board, to finally do swraid5 (after reading this list for a few months,
> it seems pretty scary in failure).

Having just been there (lots of problems these last weeks...) but also a 
longtime user of linux raid in all levels 0, 1 and 5 I'll comment.

> is there an advantage to >more< than 1 spare drive? .. more than 3
> drives in mdx?  why not cp old boot/root/whatever drive to mdx after
> booting on floppy?

I don't know those answers. Let me describe what I've built and for what 
purposes.  At home I have a need for a big storage which costs little. These 
are opposites from what my business needs are.

At home I have a raid5 array of 400G composed of 7 80GB disks. (5+1+1).
Before this week, I had no spare drive. I just suffered a two-disk failure and 
it almost took all my data with it. :(  I now have 3 promise cards and 1 
spare drive.  Later this week I found out I _still_ had a bad drive which 
hung the whole system when accessed (at a certain area), yet was NOT being 
rejected or marked failed.  It took a lot of searching and eventually running 
'badblocks' to find the culprit.  This was really rather nasty.
I don't know why the machine locks up instead of the raid layer realising 
whats happening and killing the bad drive off...  But it puzzles and 
irritates me. However, a drive can go dead in so many ways, one never knows.
At home my _system_ is not critical, just the data is. That makes life very 
much simpler; I have an old drive with linux on it, and the raid volume is 
only mounted on /mnt. So there are no boot dependancies or stuff.

At work, after experimenting with raid5, I decided raid5 was not worth it (for 
my needs) and I now run raid1 exclusively, mostly over 3 disks since todays 
hardware is a far cry from what it used to be...  Using raid1 has some very 
nice features which makes rollout simpler, like, I keep one master image in 
the closet and when I need a new system I boot from that and clone a couple 
of disks for the system. This would never be possible with a raid5 setup.
Also, since cost is not (should not be) a factor, raid1 is just perfect here. 
Needless to say, in this setup the data is not so much important as the uptime 
and / or time-to-recovery is. So here, everything is mirrored and on seperate 
raid volumes (/,  /usr, /var, /home). /boot is not really a raid volume but 
it is mirrored (cloned) to enable a quick recovery.
Also with these setups I experienced nastyness; when a drive fails it very 
often does not get kicked but remains online. It takes the whole machine 
'down' (for all intents and purposes) because every read or write does 
numerous dead slow retries, tying up so many resources that the 
responsiveness of the machine measures in several minutes instead of 
microseconds. Maybe this is an IDE issue, maybe it's a RAID issue, I don't 
know, I'm no coder.  I just report what I notice.
In any case, after a reboot and marking the disk failed all is well again.

Maybe the moral of this is: If you have the money, go SCSI.  I'm sure a lot of 
the problems I experienced come from the IDE system. Maybe someone else has 
insights in this regard.

> is there an advantage to having various mdx's allocated to various
> /directories?..ie: /home, var, /etc

Not for md, but for linux, yea... If you run a multiuser system and you don't 
want to have your system _crash_ when someone fills up /home (and by that, /) 
you should definitely go for seperate partitions.

> looking for meaningful help pls. not flamage.

All in all I'm a happy linux sw raid user since ehm... back to '99 I think. 
(it was round the time the glibc came into distros) 

I don't know if it suits own your needs but be sure to read the 
boot+root+raid+lilo howto. It might help you. And... Good luck !

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
