From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 19:43:14 +0100
Message-ID: <23krg2-4rr.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
> [ptb]
> > Could you set out the scenario very exactly, please, for those of us at
> > the back of the class :-). I simply don't see it. I'm not saying it's
> > not there to be seen, but that I have been unable to build a mental
> > image of the situation from the description :(.
> 
> Typically, in a cluster environment, you set up a raid1 with a local 
> disk and an nbd (or one of its variants) below it:

      system A
> 
>     [raid1]
>     /     \
> [disk]  [nbd] ---------> other system

Alright.  That's just raid with one nbd device as well as a local device
in the mirror.  On failover from this node we will serve directly from
the remote source instead.


> The situation he's talking about is, as you put it "somebody tripping 
> over the network cables".
> 
> In that case, you'll end up with this:
> 
>     system A       system B
>     [raid1]        [raid1]
>     /     \        /     \
> [disk]  [XXX]  [disk]  [XXX]

Well, that is not what I think you should end up with.  You should end
up (according to me) with the floating IP moving to the other system in
degraded raid mode:

                   system B
                   [raid1]
                    /   \ 
                  disk  missing
     
and system A has died - that's what triggered the failover, usually.
And I believe the initial situation was:

      system A      system B
      [raid1]   .--- nbd      
      /     \   |     |
  [disk]  [nbd]-' [disk] 

You are suggesting a failure mode in which A does not die, but B thinks
it does, and takes the floating IP address.  Well, sorry, that's tough,
but the IP is where the IP address is no matter what A may believe. No
writes will go to A.

What seems to be the idea is that the failover mechanism has fouled up
- well, that's not a concern of md. If the failover mechanism does that
it's not right. The failover should tell A to shutdown (if it hasn't
already) and tell B to start serving.

Is the problem a race condition? One would want to hold off or even 
reject writes during the seconds of transition.


> Where there's a degraded raid1 writing only to the local disk on each 
> system (and a dirty bitmap on both sides).

This situation is explicitly disallowed by failover designs. The
failover mechanism will direct the reconfiguration so that this does
not happen. I don't even see exactly how it _can_ happen. I'm happy to
consider it, but I don't see how it can arise, since failover
mechanisms do exactly their thing in not permitting it.

> The solution is to combine the bitmaps and resync in one direction or 
> the other. Otherwise, you've got to do a full resync...

I don't see that this solves anything. If you had both sides going at
once, receiving different writes, then you are sc&**ed, and no
resolution of bitmaps will help you, since both sides have received
different (legitimate) data. It doesn't seem relevant to me to consider 
if they are equally up to date wrt the writes they have received. They
will be in the wrong even if they are up to date.

OK - maybe the problem is in the race between sending the writes
across to system B, and shutting down A, and starting serving from B.
This is the intended sequence:

   1  A sends writes to B
   2  A dies
   3  failover blocks writes
   4  failover moves IP address to B
   5  B drops nbd server
   6  B starts serving directly from a degraded raid, recording in bitmap
   7  failover starts passing writes to B

I can vaguely imagine some of the writes from (1) being still buffered in
B for write to B somewhere about the (6) point. Is that a problem?  I
don't see that it is. The kernel will have them in its buffers.
Applications will see them.

What about when A comes back up? We then get a 

                 .--------------.
        system A |    system B  |
          nbd ---'    [raid1]   |
          |           /     \   |
       [disk]     [disk]  [nbd]-'

situation, and a resync is done (skipping clean sectors). 

So I don't see where these "two" bitmaps are.


Peter

