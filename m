From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 robust read and read/write correct patch
Date: Wed, 23 Feb 2005 22:15:16 +0100
Message-ID: <4c8ve2-qug.ln1@news.it.uc3m.es>
References: <421C628D.8080908@getsu.com> <p97ue2-1ld.ln1@news.it.uc3m.es> <421CEC3A.5010609@getsu.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

J. David Beutel <jdb@getsu.com> wrote:
> Peter T. Breuer wrote, on 2005-Feb-23 1:50 AM:
> 
> > Quite possibly - I never tested the rewrite part of the patch, just
> >
> >wrote it to indicate how it should go and stuck it in to encourage
> >others to go on from there.  It's disabled by default.  You almost
> >certainly don't want to enable it unless you are a developer (or a
> >guinea pig :).
> 
> Thanks for taking a look at it!  Unfortunately, I'm not a kernel 
> developer.  I haven't even been using C for the last 8 years.  But I'd 
> really like to have that rewrite functionality, and I can dedicate my 
> system as a guinea pig for at least a little while, if there's a way I 
> can test it in a finite amount of time and build some confidence in it 
> before I start to really use that system.

I'd say that theres's about a 50/50 chance that it will work as it is
without crashing the kernel. But it's impossible to say until somebody
tries it unless more people offer their kibbitzing thought-experiments
first!

I can run the 2.4 UML kernel safely for tests, but it's not as good as
running a real kernel because you don't get an OOPS when things go bad.
You just don't have to suffer the psych pain of rebooting! So you can
do more debugging, although the debugging is not as good. And you stil 
have to set up the test again each time.

I'm particularly unclear in the present patch if end_io is run on the
original read request after it's been retried and used as the first
half of a read-write resync pair. I simply can't see from the code, and
running is the only way of finding out. There are also possible race
conditions against the resync thread proper under some conditions, but
that won't be a problem in testing.

> I'd like to start with an md unit test suite.  Is there one?  I don't 

!! I always simply do

   dd if=/dev/zero of=/tmp/core0 bs=4k count=1k
   dd if=/dev/zero of=/tmp/core1 bs=4k count=1k
   losetup /dev/loop0 /tmp/core0
   losetup /dev/loop1 /tmp/core1
   mdadm -C -l 1 -n 2 -x 0 --force /dev/md0 /dev/loop[01]

or something very like that.

> know if the architecture would allow for this, but naively I'm thinking 
> that the test suite would use a mock disk driver (e.g., in memory only) 
> to simulate various kinds of hardware failures and confirm that md 

Uh, one can do that via the devicemapper (dmsetup?) but I've never
bothered - it's much simpler to add a line or two to the code along the
lines of "if (bio->b_sector == 1024) return -1;" in order to simulate an
error. 

One could add ioctls to make that configurable, but by then we're in dm
territory.

> responds as expected to both the layer above (the kernel?) and below 
> (the disk driver?).  Unit tests are also good for simulating unlikely 
> and hard to reproduce race conditions, although stress tests are better 

Well, if you could make a dm-based testrig, yes please!

> at discovering new ones.   But, should the test suite play the roll of 
> the kernel by calling md functions directly in a user space sandbox 

Never mind that for now. The actual user space reads or writes
can be in a makefile. The difficulty is engineering the "devices"
to have the intended failures.

> (mock kernel, threads, etc)?  Or, should it play the roll of a user 
> process by calling the real kernel to test the real md (broadening the 

No - nothing like that. The testsuite will be run under a kernel. It's
not your business to know if it's a real kernel or a uml kernel or some
other kind of sandbox.

> scope of the test)?  I'd appreciate opinions or advice from kernel or md 
> developers.
> 
> Also, does anyone have advice on how I should do system and stress tests 
> on this?

Well, setting up is the major problem. After that running the tests is
just standard scripting.

Peter

