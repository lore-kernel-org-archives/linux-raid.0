From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 20:33:49 +0200
Message-ID: <d5n1m2-rb5.ln1@news.it.uc3m.es>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com> <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com> <428E0A92.3060108@steeleye.com> <1116611115.23785.89.camel@compaq-rhel4.xsintricity.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford@redhat.com> wrote:
> >  Same goes if we wrote P and not D1, or some partial piece of 
> > either or both.

> Yep.  Now, reread my original email.  *WE DON'T CARE*.  If this stripe
> is in the filesystem proper, then whatever write we did to D1 and P will

I think Paul missed that too, but consider

   a) it is the journal (placed on the same raid partition) that we have the 
      bad luck to be talking about; OR

   b) rewriting is not necessarily idempotent, when half of it consists
      of using a parity to construct what you should write.

I explained further in a reply to Paul. reassure me!

> get replayed when the journal is replayed.  If this stripe was part of
> the journal, then those writes were uncommitted journal entries and are
> going to get thrown away (aka, they are transient, temporary data and
> before it's ever used again it will be rewritten).

You are saying the write to a journal on RAID will always be discarded
if incomplete.  Fine.  That's great.  I like that (I think that should
always happen, and one should never roll forward any incomplete write,
whether to the journal or not).

> Your only
> requirement is that if the array goes down degraded, then you need to
> replay the journal in that degraded state, prior to adding back in
> disk3.

Careful ...  I don't believe writes are necessarily idempotent in this
situation.

> That's it.  And since the journal will be replayed even before
> you get to the point of a single user login (unless the filesystem isn't
> checked in fstab), and nothing automatically readds disks into a
> degraded array, it's all a moot point.

Well, take one moot admin, and see what he can do! But sure, fine.

> > There's no way for a filesystem journal to protect us from D2 getting 
> > corrupted, as far as I know.

> Sure it does.  Since the replay happens in the same state as when the
> machine crashed, namely degraded, the replay repairs the corruption

Careful with your assumptions. Prove to me that write is idempotent.

> between D1 and P.  It doesn't touch D2.  Now when you readd disk3 into
> the array, the *proper* data for D2 gets reconstructed out of D1 and P,
> which are now in sync.  This is why my recommendation, if you have a
> big, fast software RAID4/5 array is to use journal=data and give a
> goodly journal size (I'd use a 64MB or larger journal) and be all safe
> and cozy in your combination of disk redundancy and double writes to
> keep you safe.


Peter

