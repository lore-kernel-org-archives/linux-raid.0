From: Neil Brown <neilb@suse.de>
Subject: Re: accessing mirrired lvm on shared storage
Date: Wed, 12 Apr 2006 14:09:52 +1000
Message-ID: <17468.32144.316047.478627@cse.unsw.edu.au>
References: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
	<20060407134636.2bce1917@mwdsp001>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Osicki on Friday April 7
Sender: linux-raid-owner@vger.kernel.org
To: Chris Osicki <osk@admin.swisscom-mobile.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday April 7, osk@admin.swisscom-mobile.ch wrote:
> Unfortunately md lacks the ability to mark an array as
> used/busy/you_name_it. Sometime ago I asked on this list for such an
> enhancement (see thread with subject "Question: array locking,
> possible"). Although I managed (with great help from few people on 
> this list) to attract Neil's attention, I couldn't fine enough
> arguments to convince him to put this topic on hist TO-DO list.
> Neil, you see the constantly growing number of potential users of this
> feature? ;-)

I don't think that just marking an array "don't mount" is really a
useful solution.  And if it was, it would be something done in 'mdadm'
rather than in 'md'.

What you really want is cluster wide locking using DLM or similar.
That way when the node which has active use of the array fails,
another node can pick up automatically.
Then we could put a flag in the superblock which says 'shared', and md
would need a special request to assemble such an array.

One thing that is on my todo list is supporting shared raid1, so that
several nodes in the cluster can assemble the same raid1 and access it
- providing that the clients all do proper mutual exclusion as
e.g. OCFS does.

Your desire to have only-assembled-once would be trivial to include in
that.

NeilBrown

