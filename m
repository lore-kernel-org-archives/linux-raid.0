From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Wed, 7 Dec 2005 11:04:50 +1100
Message-ID: <17302.10018.330421.986669@cse.unsw.edu.au>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Milo on Tuesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: Milo <search.lists@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 6, search.lists@gmail.com wrote:
> Hello, I have been trying to figure out how to fix my raid system,
> SUSE 9.3, linux 2.6.11.4-21.9-default. A hard reset put my raid in
> unstable state, almost same errors as
> http://sumo.genetics.ucla.edu/pipermail/nelsonlab-dev/2004-August/000150.html
> except, sda1 seems to be the problem.
> md: kicking non-fresh sda1 from array!
> 
> I did
> mdadm -A -f /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> and then /proc/mdstat shows the 2 disk raid active, but I could not
> mount it, mounting /dev/md0 hangs.  Later I tried
> mdadm --assemble /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc1
> same thing.
> 
> If the raid is ok in degraded (missing 1 drive) mode, shouldn't I be
> able to mount it?

Yes you should.  
The fact that you cannot tends to suggest something wrong at a
hardware level, but it is hard to be sure.

Can you get any kernel messages between assembling the array and the
mount hanging?
If you could
   echo t > /proc/sysrq_trigger

and capture the output
   dmesg > /some/file

that might also be helpful.

NeilBrown
