From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 14:27:45 +0100
Message-ID: <hvltg2-ss8.ln1@news.it.uc3m.es>
References: <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-03-19T12:43:41, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:
> 
> > Well, there is the "right data" from our point of view, and it is what
> > should by on (one/both?) device by now.  One doesn't get to recover that
> > "right data" by copying one disk over another, however efficiently one
> > does it.
> 
> It's about conflict resolution and recovery after a split-brain and
> concurrent service activation has occured.

It surely doesn't matter what words one uses, Lars, the semantics does
not change?  If you have different stuff in different places, then
copying one over the other is only one way of "resolving the conflict",
and resolve it it will, but help it won't necessarily.  Why should the
kind of copy you propose be better than another kind of copy?

> Read up on that here:
> http://www.linux-mag.com/2003-11/availability_01.html (see the blob
> about split-brain with drbd).

I didn't see anything that looked relevant :(. Sure that's the right
reference? It's a pretty document but I didn't see any detail.

  As mentioned earlier, DRBD is a disk replication package that makes
  sure every block written on the primary disk gets copied to the
  secondary disk. From DRBD's perspective, it simply mirrors data from
  one machine to another, and switches which machine is primary on
  command. From Heartbeat's perspective, DRBD is just another resource
  (called datadisk) that Heartbeat directs to start or stop (become pri
  ...

Clicking on the glyph with a box in it with the word "DRBD" in (figure
two?) just gets a bigger image of the figure.


> It all depends on the kind of guarantees you need.

Indeed - and I haven't read any!  If you want the disks to be
self-consistent, you can just do "no copying" :-). But in any case I
haven't seen anyone explain how the disks can get into a state where
both sides have written to them ...

OK - this is my best guess from the evidence so far .. you left a
journal behind on system A when it crashed, and you accidentally
brought up its FS before starting to sync it from B. So you
accidentally got A written to some MORE before the resync started, so
you need to write some MORE than would normally be necessary to undo
the nasties.

Well, "Don't Do That Then" (tm). Don't bring up the FS on A before
starting  the resync from B. Do make sure to always write the whole
journal from B across to A in a resync.

Or don't use a journal (tm :-).

Another aproach is to have the journal on the mirror.  Crazy as it
sounds (for i/o especially), this means that B will have a "more
evolved" form of the journal than A, and copying B to A will _always_ be
right, in that it will correct the journal on A and bring it up to date
with the journal on B. No extra mapping required, I believe (not having
had my morning tequila).


> > But neither mirror is necessarily right.  We are already in a bad
> > situation.  There is no good way out.  You can merely choose which of
> > the two data possibilities you want for each block.  They're not
> > necesarily either of them "right", but one of them may be, but which one
> > we don't know.
> 
> It's quite clear that you won't get a consistent state of the system by
> mixing blocks from either side; you need to declare one the 'winner',
> throwing out the modifications on the other side (probably after having
> them saved manually, and then re-entering them later). For some
> scenarios, this is acceptable.

OK - I agree. But one can do better, if the problem is what I guessed
at above (journal left behind that does its replay too late and when
it's not wanted). Moreover, I really do not agree that one should ever
be in this situation. Having got in it, yes, you can choose a winning
side and copy it.

> > Why should one think that copying all of one disk to the other (morally)
> > gets one data that is more right than copying some of it? Nothing one
> > can do at this point will help.
> 
> It's not a moral problem. It is about regaining consistency.

Well, morality is about what it is good to do. I agree that you get a
consistent result this way. 

> Which one of the datasets you choose you could either arbitate via some
> automatic mechanisms (drbd-0.8 has a couple) or let a human decide.

But how on earth can you get into this situation? It still is not clear
to me, and it seems to me that there is a horrible flaw in the managing
algorithm for the failover if it can happen, and one should fix it.

> The default with drbd-0.7 is that they will detect this situation has
> occured and refuse to start replication unless the admin intervenes and
> decides which side wins.

Hmm. I don't believe it can detect it reliably. It is always possible
for both sides to have written different data in the ame places, etc.

Peter

