From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 13:10:34 +0100
Message-ID: <qehtg2-6c1.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
> Peter T. Breuer wrote:
> > I don't see that this solves anything. If you had both sides going at
> > once, receiving different writes, then you are sc&**ed, and no
> > resolution of bitmaps will help you, since both sides have received
> > different (legitimate) data. It doesn't seem relevant to me to consider 
> 
> You're forgetting that journalling filesystems and databases have to 
> replay their journals or transaction logs when they start up.

Where are the journals located?  Offhand I don't see that it makes a
difference _how_ the data gets to the disks (i.e., via journal or not
via journal) but it may do - I reserve judgement :-) -, and it may
certainly affect the timings.

Can you also pin this down for me in the same excellent way you did
with the diagrams of the failover situation?

> > What about when A comes back up? We then get a 
> > 
> >                  .--------------.
> >         system A |    system B  |
> >           nbd ---'    [raid1]   |
> >           |           /     \   |
> >        [disk]     [disk]  [nbd]-'
> > 
> > situation, and a resync is done (skipping clean sectors). 
> 
> You're forgetting that there may be some data (uncommitted data) that 
> didn't reach B that is on A's disk (or even vice versa).

You are saying that the journal on A (presumably not raided itself?) is
waiting to play some data into its own disk as soon as we have finished
resyncing it from B? I don't think that would be a good idea at all.

I'm just not clear on what the setup is, but in the abstract I can't
see that having a data journal is at all good - having a metadata
journal is probably helpful, until the time that we remove a file on one
FS and add it on another, and get to wondering which of the two ops to
roll forward ..

> That is why 
> you've got to retrieve the bitmap that was in use on A and combine it 
> with B's bitmap before you resync from B to A (or do a full resync).

The logic still eludes me. This operation finds the set of blocks that
_may be different_ atthis time between the two disks.  THat enables one
to efficiently copy A to B (or v.v.) because we know we only have to
write the blocks marked.  But whether that is a good idea or not is an
orthogonal question, and to me it doesn't look necesarily better than
some of the alternatives (doing nothing, for example). What makes it a
good idea?

Peter

