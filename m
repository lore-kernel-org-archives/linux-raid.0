From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: A few mdadm questions
Date: Mon, 15 Nov 2004 10:42:33 +1100
Message-ID: <16791.60777.951575.384927@cse.unsw.edu.au>
References: <200411140203.iAE23rN08652@www.watkins-home.com>
	<419783F7.5030807@osiel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Osiel on Sunday November 14
Sender: linux-raid-owner@vger.kernel.org
To: Robert Osiel <bob@osiel.org>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 14, bob@osiel.org wrote:
> 
> I'll wait and see if Neil has any advice. *crosses fingers*
> 

Well, my reading of the information you sent (very complete, thanks),
is:

At
   Update Time Sat Sep 25 22:07:24 2004

when /dev/hdk1 last had a superblock update, the array have one failed
drive (not present) and one spare.
At this point it *should* have been rebuilding the spare to replace the
missing device, but I cannot tell if it actually was.

At
   Update Time Sat Sep 25 22:07:26 2004
(2 seconds later) when /dev/hdi1 was last written another drive had
failed, apparently [major=56, minor=1] which is /dev/hdi1 on my
system, but seems to be different for you.

If that drive, whichever it is, is really dead, then you have lost all
your data.  If, however, it was a transient error or even a
single-block-error then you can recover most of it with
  mdadm -A /dev/md0 --uuid=ec2e64a8:fffd3e41:ffee5518:2f3e858c --force /dev/hd?1

This will choose the best 4 drives and assemble a degraded array with
them.  It will only update the superblocks and assemble the array - it
won't touch the data at all.

You can then try mounting the filesystem read-only and dumping the
data to backup.

When you add the 5th drive (hdi?) it should start rebuilding.  If it
gets a read error on one of the drives, the rebuild will fail, but the
data should still be safe.

I'm still very surprised that you managed to "raidhotremove" without
"raidsetfaulty" first... What kernel (exactly) are you running?

NeilBrown
