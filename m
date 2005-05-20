From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 13:45:15 -0400
Message-ID: <1116611115.23785.89.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
	 <17029.12773.197506.463977@cse.unsw.edu.au>
	 <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com>
	 <17037.35615.456231.737766@cse.unsw.edu.au>
	 <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com>
	 <428E0A92.3060108@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428E0A92.3060108@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-05-20 at 12:04 -0400, Paul Clements wrote:
> Hi Doug,
> 
> Doug Ledford wrote:
> > On Fri, 2005-05-20 at 17:00 +1000, Neil Brown wrote:
> 
> >>There is a converse to this.  People should be made to take notice if
> >>there is possible data corruption.
> >>
> >>i.e. if you have a system crash while running a degraded raid5, then
> >>silent data corruption could ensue.  mdadm will currently not start
> >>any array in this state without an explicit '--force'.  This is somewhat
> >>akin to fsck sometime requiring human interaction.  Ofcourse if there
> >>is good reason to believe the data is still safe, mdadm should -- and
> >>I believe does -- assemble the array even if degraded.
> > 
> > 
> > Well, as I explained in my email sometime back on the issue of silent
> > data corruption, this is where journaling saves your ass.  Since the
> > journal has to be written before the filesystem proper updates are
> > writting, if the array goes down it either is in the journal write, in
> > which case you are throwing those blocks away anyway and so corruption
> > is irrelevant, or it's in the filesystem proper writes and if they get
> > corrupted you don't care because we are going to replay the journal and
> > rewrite them.
> 
> I think you may be misunderstanding the nature of the data corruption 
> that ensues when a system with a degraded raid4, raid5, or raid6 array 
> crashes.

No, I understand it just fine.

>  Data that you aren't even actively writing can get corrupted. 
> For example, say we have a 3 disk raid5 and disk 3 is missing. This 
> means that for some stripes, we'll be writing parity and data:
> 
> disk1   disk2   {disk3}
> 
>   D1       P      {D2}
> 
> So, say we're in the middle of updating this stripe, and we're writing 
> D1 and P to disk when the system crashes. We may have just corrupted D2, 
> which isn't even active right now. This is because we'll use D1 and P to 
> reconstruct D2 when disk3 (or its replacement) comes back.

Correct.

>  If we wrote 
> D1 and not P, then when we use D1 and P to reconstruct D2, we'll get the 
> wrong data.

Absolutely correct.

>  Same goes if we wrote P and not D1, or some partial piece of 
> either or both.

Yep.  Now, reread my original email.  *WE DON'T CARE*.  If this stripe
is in the filesystem proper, then whatever write we did to D1 and P will
get replayed when the journal is replayed.  If this stripe was part of
the journal, then those writes were uncommitted journal entries and are
going to get thrown away (aka, they are transient, temporary data and
before it's ever used again it will be rewritten).  Your only
requirement is that if the array goes down degraded, then you need to
replay the journal in that degraded state, prior to adding back in
disk3.  That's it.  And since the journal will be replayed even before
you get to the point of a single user login (unless the filesystem isn't
checked in fstab), and nothing automatically readds disks into a
degraded array, it's all a moot point.

> There's no way for a filesystem journal to protect us from D2 getting 
> corrupted, as far as I know.

Sure it does.  Since the replay happens in the same state as when the
machine crashed, namely degraded, the replay repairs the corruption
between D1 and P.  It doesn't touch D2.  Now when you readd disk3 into
the array, the *proper* data for D2 gets reconstructed out of D1 and P,
which are now in sync.  This is why my recommendation, if you have a
big, fast software RAID4/5 array is to use journal=data and give a
goodly journal size (I'd use a 64MB or larger journal) and be all safe
and cozy in your combination of disk redundancy and double writes to
keep you safe.

> Note that if we lose the parity disk in a raid4, this type of data 
> corruption isn't possible. Also note that for some stripes in a raid5 or 
> raid6, this type of corruption can't happen (as long as the parity for 
> that stripe is on the missing disk). Also, if you have a non-volatile 
> cache on the array, as most hardware RAIDs do, then this type of data 
> corruption doesn't occur.

And it's not possible with normal raid4/5 if you use a journaling
filesystem and the raid layer does the only sane thing which is make
parity writes synchronous with regular data block writes in degraded
mode as opposed to letting the parity be write behind.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


