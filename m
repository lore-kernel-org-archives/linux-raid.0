From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Re: accessing mirrired lvm on shared storage
Date: Wed, 12 Apr 2006 18:47:19 +0200
Message-ID: <20060412184719.4e857070@mwdsp001>
References: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
	<20060407134636.2bce1917@mwdsp001>
	<17468.32144.316047.478627@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17468.32144.316047.478627@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Wed, 12 Apr 2006 14:09:52 +1000
Neil Brown <neilb@suse.de> wrote:

> On Friday April 7, osk@admin.swisscom-mobile.ch wrote:
> > Unfortunately md lacks the ability to mark an array as
> > used/busy/you_name_it. Sometime ago I asked on this list for such an
> > enhancement (see thread with subject "Question: array locking,
> > possible"). Although I managed (with great help from few people on 
> > this list) to attract Neil's attention, I couldn't fine enough
> > arguments to convince him to put this topic on hist TO-DO list.
> > Neil, you see the constantly growing number of potential users of this
> > feature? ;-)
> 
> I don't think that just marking an array "don't mount" is really a
> useful solution.  And if it was, it would be something done in 'mdadm'
> rather than in 'md'.

I don't think I understand this bit, sorry, but see below.

> 
> What you really want is cluster wide locking using DLM or similar.
> That way when the node which has active use of the array fails,
> another node can pick up automatically.

But I also want to prevent accidentally activation of the array on the
stand-by node. That would mean make mdadm cluster or a lock manager
aware, which we certainly don't want. 
That's why I'm asking for a flag on the array which would be far less complex 
solution than a Lock Manager.

> Then we could put a flag in the superblock which says 'shared', and md
> would need a special request to assemble such an array.

That would mean, if I get you right, "Attention, it could be used on
another host, go and check or let me assemble it anyway if you know
what you're doing". 

I was thinking about a flag saying "locked" which would
mean "array is assembled/used". 
Look, if I have a cluster (active/stand-by) when starting it I assemble
my array in exclusive mode by setting the "locked" flag. If I do a
manual fail-over of my package/service using the array in question,
when stopping the array the flag gets cleared. The node which takes
over finds the array "unlocked", locks, assembles and uses it. Now the
active node crashes without clearing the flag. It is now
responsibility of the cluster software to force the assembly of the
array on the node taking over.
And nobody can accidentally/unwittingly assemble the array on stand-by
node (without giving the option -I_know_what_I_am_doing ;-), 
which currently is my main concern as I haven't experienced any
crashes or malfunction of my clusters yet. Touching wood ....

It is how ServiceGuard cluster software on HP-UX works except that
disk mirroring and locking is done in LVM. Moreover LVM does know
about SG Cluster and prevents you from doing certain operations
depending on the current state of the cluster.

> 
> One thing that is on my todo list is supporting shared raid1, so that
> several nodes in the cluster can assemble the same raid1 and access it
> - providing that the clients all do proper mutual exclusion as
> e.g. OCFS does.
> 
> Your desire to have only-assembled-once would be trivial to include in
> that.

If this is what I described above, I hold my breath ;-)

> 
> NeilBrown
> 

Thanks very much for your time.

Regards,
Chris
