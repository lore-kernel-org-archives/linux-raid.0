From: "David M. Strang" <dstrang@shellpower.net>
Subject: Horrific Raid 5 crash... help!
Date: Sun, 7 May 2006 22:40:49 -0400
Message-ID: <004b01c67248$d0e9e8c0$a300a8c0@enterprise.local>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd have to say, I'm currently rating in the top 10 most unlucky people in 
the linux software raid world right now.

I'm terrified of rebooting; I had 136 days uptime, and I needed to swap out 
my wireless card. So, I shut down my system. For some time now, anytime I 
reboot... my raid wants to rebuild a disk. It comes up 27 disks, 1 spare - 
clean, degraded, rebuilding. The disk rebuilds, and everything is hunky 
dory. It's a nusance, but oh well. I've had so many issues in the past where 
my raid would randomly kick disks (ended up being firmware) that I've always 
been greatful on how stable it's been since those issues were resolved. A 
few months back, I actually had a disk fail. I swapped in a spare, it 
rebuilt - all good.

Well today, during this illustrious rebuild... it appears I actually DID 
have a disk fail. So, I have 26 disks... 1 partially rebuilt, and 1 failed. 
Hoping and praying that a rebuild didn't actually wipe the disk and maybe 
just synced things up -- I did a create with the 26 disks + 1 partially 
rebuilt and 1 'missing disk'.... well, the array came up.... but I get 
access denied on a zillion things, and the filesystem is freaking out.

Before I proceed any further... what are my options? Do I have any options? 
I could run a fsck... but I held off fearing it could just make things 
worse.

Thanks,

David M. Strang 

