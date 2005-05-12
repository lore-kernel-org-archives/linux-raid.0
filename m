From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Failed RAID5
Date: Thu, 12 May 2005 09:52:33 -0500
Message-ID: <1115909553.6694.6.camel@langvan2.homenetwork>
References: <4283172b.242.630.20549@clanwind.com>
	 <17027.10878.872935.948925@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17027.10878.872935.948925@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2005-05-12 at 05:05, Neil Brown wrote:
> On Thursday May 12, janaka@clanwind.com wrote:
> > Hey,
> > 
> > I am trying to rebuild a failed raid 5.  I have one disk
> > that's bad, and one disk that, in the confusion, has become
> > convinced that it is a spare.  I don't know where it got
> > this idea, but I have drive "mdadm --assemble --force
> > /dev/md2 /dev/hda3 /dev/hdc3 /dev/hde3 /dev/hdg3 /dev/hdi3
> > /dev/hdk3" as well as "mkraid --force /dev/md2" and my
> > raidtab hasn't changed except to state that HDA has failed.
> > 
> > Is there anyway for me to force the "spare disk" to
> > reconsider its purpose in life?  Which is presently to make
> > my data accessable so I can move to raid 10 or some other
> > more simple raid format.
> > 
> > I mean, I am sure it is some bit in the superblock that is
> > miss set, but how do I fix that?
> 
> If you are confident that you know what belongs where, then the best
> thing is to recreate the array. Make sure you leave a "missing" device
> so that it doesn't do a resync.
> e.g.
> 
>   mdadm --create /dev/md2 -l5 -n6 /dev/hda3 /dev/hdc3 /dev/hde3 \
>       missing /dev/hdi3 /dev/hdk3
> 
> or whatever happens to be right in your situation.
> This will rewrite all superblocks but will not touch any data (unless
> you try to write to md2).A
> I suggest that after this you "fsck -n" the make sure the data looks
> reasonably OK, and if it does, mount read-only and copy the data off.
> 
> If fsck thinks it is trash, then maybe you got the order wrong.  Just
> "mdadm -S /dev/md2" and try again.

Also, "mdadm --examine" will give you a good idea of how things were put
together.
eg.
    mdadm --examine /dev/hda3

--
Regards,
Mike T.

