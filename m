From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Call for RAID-6 users
Date: Sat, 31 Jul 2004 02:28:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407310228.27969.maarten@ultratux.net>
References: <cds76e$ee7$1@terminus.zytor.com> <200407302311.04942.maarten@ultratux.net> <200407302338.33823.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407302338.33823.maarten@ultratux.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 30 July 2004 23:38, maarten van den Berg wrote:
> On Friday 30 July 2004 23:11, maarten van den Berg wrote:
> > On Saturday 24 July 2004 01:32, H. Peter Anvin wrote:

Again replying to myself.   I have a full report now.

Realizing this all took way too much time I started from scratch and defined 
multiple small partitions (2GB) and defined a raid6 array on one set and a 
raid5 array on the other. Both are full arrays; no missing drives. I used 
reiserfs on both. Hard- and software specs as before, back in the thread.

I tested it by copying trees from / to the respective raid arrays and running 
md5sum on the source and the copies (and repeating after reboots).
Then I went and disconnected SATA cables to get them degraded. The first cable 
went perfect, both arrays came up fine and a md5sum on the available files, 
and a new copy + md5sum on that went fine too.
The second cable however, went wrong; I inadvertently moved a third cable so I 
was left with three missing devices, so let's skip over that: when I 
reattached that cable the md1 raid6 device was still fine, with two failed 
drives. I did the <copy new stuff, run md5sum over it> thing again.

Then I reattached all cables. I did verify the md5sums before refilling the 
raid6 array using mdadm -a, and did that afterwards too.  To my astonishment, 
the raid5 array was back up again.  I thought raid5 with two drives missing 
was deactivated, but obviously things have changed now and a missing drive 
does not equal anymore a failed drive.  I presume.  
/proc/mdstat just after booting looked like this:

Personalities : [raid1] [raid5] [raid6]
md1 : active raid6 hdg3[2] hda3[0] sda3[3]
      5879424 blocks level 6, 64k chunk, algorithm 2 [5/3] [U_UU_]

md2 : active raid5 hdg4[2] hde4[1] hda4[0] sda4[3]
      7839232 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]

md0 : active raid1 sda1[1] hda1[0]
      1574272 blocks [3/2] [UU_]

The md5sums after hotadding were the same as before and verified fine.

Now seen as the <disconnect cable> trick doesn't mark a drive failed, should I 
now repeat the tests with marking failed by either doing that through mdadm 
or maybe pull the cable while the system is up ?  Cause I'm not totally 
convinced now that the array got marked degraded. I could mount it with two 
drives missing [raid6], but the fact that the raid5 device didn't get broken 
puzzles me a bit...  

Oh well, since I'm just experimenting I'll take the plunge anyway and pull a 
live cable now:
...
Well, the first thing to observe is that the system becomes unresponsive 
immediately. New logins don't spawn, and /var/logmessages says this:
	kernel: ATA: abnormal status 0x7F on port 0xD481521C
Now even the keyboard doesn't respond anymore...  reset-button !

Upon reboot, mdadm --detail reports the missing disk as "removed", not failed.
But maybe that is the same(?).  Rebooting again after reattaching the cable, 
this time the arrays stayed degraded.  I ran the ubiquitous md5sums but found 
nothing wrong either before hotadding the missing drives and after.

So, at least in my experience raid6 works fine.  Also, the problems reported 
with SuSE 9.1 could not be observed (probably due to updating the kernel).
Moreover, it also seems the underlying SATA is stable [with these cards], 
which I'm very glad to notice, reading some of the stories...

More version-info etcetera upon request.

Maarten

P.S.: My resync speed stays this low.  Anything that can be done...? 

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

