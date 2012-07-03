From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Tue, 3 Jul 2012 22:27:34 +0200
Message-ID: <20120703202734.GA10087@lazy.lzy>
References: <10900468.MPSjVn2C3J@peanut>
 <1436304.MN64neqUEr@peanut>
 <20120630114831.GA3034@lazy.lzy>
 <2116390.poR22k1RqP@peanut>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2116390.poR22k1RqP@peanut>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Buchholz <robert.buchholz@goodpoint.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Robert,

On Tue, Jul 03, 2012 at 09:10:41PM +0200, Robert Buchholz wrote:
[...]
> > Why always two blocks?
> 
> The reason is simply to have less cases to handle in the code. There's 
> already three ways to regenerate regenerate two blocks (D&D, D/P&Q and 
> D&P), and there would be two more cases if only one block was to be 
> repaired. With the original patch, if you can repair two blocks, that 
> allows you to repair one (and one other in addition) as well.

sorry, I express myself not clearly.

I mean, a two parities Reed-Solomon system can
only detect one incorrect slot position, so I would
expect to have the possibility to fix only one, not
two slots.

So, I did not understand why two. I mean, I understand
that a RAID-6 can correct exact up two incorrect slots,
but the "unknown" case might have more and correcting
will mean no correction or, maybe, even more damage.

I would prefer, if you agree, to simply tell "raid6check"
to fix a single slot, or the (single) wrong slots it finds
during the check.

Does it make sense to you, or, maybe, you're considering
something I'm missing?

> > Of course, this is just a statistical assumption, which
> > means a second, "aggressive", option will have to be
> > available, with all the warnings of the case.
> 
> As you point out, it is impossible to determine which of two failed 
> slots are in error. I would leave such decision to an admin, but giving 
> one or more "advices" may be a nice idea.

That would be exactly the background.
For example, considering that "raid6check" processes
stripes, but the check is done per byte, already
knowing how many bytes per stripe (or block) need
to be corrected (per device) will hint a lot about
the overall status of the storage.
 
> Personally, I am recovering from a simultaneous three-disk failure on a 
> backup storage. My best hope was to ddrescue "most" from all three disks 
> onto fresh ones, and I lost a total of a few KB on each disk. Using the 
> ddrescue log, I can even say which sectors of each disk were damaged. 
> Interestingly, two disks of the same model failed on the very same 
> sector (even though they were produced at different times), so I now 
> have "unknown" slot errors in some stripes. But with context 
> information, I am certain I know which slots need to be repaired.

That's good!
Did you use "raid6check" for a verification?
 
[...]
> checksums. I may send another patch implementing this, but I wanted to 
> get general feedback on inclusion of such changes first (Neil?).

Yeah, last time Neil mentioned he needs re-triggering :-),
I guess you'll have to add "[PATCH]" tag to the message too...

> I am a big supporter of getting it to work, then make it fast. Since a 
> full raid check takes the magnitude of hours anyway, I do not mind that 
> repairing blocks from the user space will take five minutes when it 
> could be done in 3. That said, I think the faster code in the kernel is 
> warranted (as it needs this calculation very often when a disk is 
> failed), and if it is possible to reuse easily, we sure should.

The check is pretty slow, also due to the terminal
print out, which is a bit too verbose, I think.

Anyhow, I'm really happy someone has interest in
improving "raid6check", I hope you'll be able to
improve it and, maybe, someone else will join
the bandwagon... :-)

bye,

-- 

piergiorgio
