From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 15:50:15 +0100
Message-ID: <7e6rg2-pj1.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-03-18T13:52:54, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:
> 
> > (proviso - I didn't read the post where you set out the error
> > situations, but surely, on theoretical grounds, all that can happen is
> > that the bitmap causes more to be synced than need be synced).
> 
> You missed the point.

Probably!

> The problem is for multi-nodes, both sides have their own bitmap. When a

Wait - I'm unaware of what that should mean exactly.  What level is your
clustering done at?  The above makes it sound as though it's kernel
level, so that somehow the raid "device" exists on two nodes at once,
and everything written anyahere gets written everywhere.

Well, could it be less than kernel level?  ...  Yes, if we are talking
about a single (distributed) application, and it writes to "two places
at once on the net" every time it writes anything. Maybe a distributed
database.

'K.

> split scenario occurs,

Here I think you mean that both nodes go their independent ways, due to
somebody tripping over the network cables, or whatever.

> and both sides begin modifying the data, that
> bitmap needs to be merged before resync, or else we risk 'forgetting'
> that one side dirtied a block.

Hmm.  I suppose your application is writing two places at once - it
won't presumably get/pass back an ack until both are done.  It sounds
like it is implementing raid1 at application level itself.  But I really
am struggling to grasp the context!

If you have a sort of networked device that covers several real
physical devices on separate nodes, then how is raid involved? Surely 
each node won't have a raid device (and if it does, it's its own
business)? Isn't the network device supposed to fix up what happens so
that nobody is any the wiser?



> This scenario _could_ occur for single nodes, but less likely so.
> 
> That can either happen outside md (if one is careful in the wrappers
> around setting up network replication), or it could happen inside
> generic md (if each mirror had its own local bitmap).

Could you set out the scenario very exactly, please, for those of us at
the back of the class :-). I simply don't see it. I'm not saying it's
not there to be seen, but that I have been unable to build a mental
image of the situation from the description :(.

> Which also has the advantage of providing inherent redundancy for the
> bitmap itself, BTW.


Now - in very general terms - if you are worrying about getting
different bitmaps on different nodes, I'dd have to ask if it matters?
Doesn't each node then get written to at wherever its bitmap indicates
it still has to be written to? Is the problem in trying to decide where
to read the data from?

o( - is that it?  That the problem is the problem of knowing who has the
latest information, that we may read from it when doing what the
various bitmaps say has to be done?


Peter

