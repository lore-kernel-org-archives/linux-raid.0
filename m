From: Martin Cracauer <cracauer@cons.org>
Subject: Superblock V 1.2
Date: Sun, 7 Nov 2010 14:15:07 -0500
Message-ID: <20101107191507.GA31052@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I created a new array after upgrading kernel and OS
(2.6.32.25-cracauer and Debian/squeeze, respectively, resulting in
mdadm - v3.1.4 - 31st August 2010)

The new array reads
md0 : active raid5 sdc2[4] sda2[2] sdb2[1] sdd2[0]
      292998144 blocks super 1.2 level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

I figure the "super 1.2" means the new version of the superblock.

Can I read that array if I ever connect the machine to an older
kernel/mdadm? I see that I can control which version to use in
mdadm(8), but I don't get what the advantage of the new format is if I
don't run out of # of components or total capacity.  I can see how
storing the superblock at 4 KB makes it more robust against accidents
that wipe out of the first 512 bytes or similar fun.  I think storing
it at the end will be a pain if you ever have to hexdump recover the
thing, no?

I also wonder why this is the only version announced in /proc/mdstat
if it is what is now the default? Shouldn't it announce the v0.9
blocks?

Is anybody here using the DDF format? I don't plan to get hardware
raid but why not prepare for it?

Thanks
	Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
