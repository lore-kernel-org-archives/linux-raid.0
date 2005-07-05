From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm memory leak?
Date: Tue, 5 Jul 2005 14:57:57 +1000
Message-ID: <17098.4949.378512.822529@cse.unsw.edu.au>
References: <42CA0B7E.4040109@shlrm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Kowis on Monday July 4
Sender: linux-raid-owner@vger.kernel.org
To: David Kowis <dkowis@shlrm.org>
Cc: linux-raid@vger.kernel.org, Eric Sandall <eric@sandall.us>
List-Id: linux-raid.ids

On Monday July 4, dkowis@shlrm.org wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I'm not entirely sure if this is mdadm's fault, but I cannot find anything else that would cause the problem, since mdadm is the only new
> thing and I'm pretty sure it's not 2.6.11.12's fault. Anyways, on to my issue:
> I'm running samba, apache2, mysql, postgresql, and a few other things. I've got an Athlon-XP 1700+ with 768Mb RAM. Right after startup I've
> got about 600Mb of free memory, and as time progresses, and I use samba for things (playing an MP3,) my amount of free memory declines
> rather rapidly. It hovers around 8Mb of free ram, with no swap usage. The computer has bogged down bad enough that oom-killer has had to
> kill just about everything. ps and top don't show anything eating up all my memory. I'm very impressed with mdadm and I'd like to keep using
> it, but i'd also like to have a bit of free memory on my computer. I'm using an XFS file system on a 200Gb mirrored RAID array, two drives,
> on seperate IDE channels (seperate cables.)
> Thanks for your time,

Hmmm.
There is an md related memory leak in 2.6.12, but I don't think it is
there in 2.6.11.anything.

If 'ps' doesn't show anything, the next place to look is
/proc/slabinfo (which 'slabtop' might display for you).

What does 'cat /proc/slabinfo' show?

NeilBrown
