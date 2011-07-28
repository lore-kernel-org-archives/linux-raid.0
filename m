From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Thu, 28 Jul 2011 11:25:13 +0200
Message-ID: <j0r9tp$p96$1@dough.gmane.org>
References: <20110727141652.7511fc51@notabene.brown> <j0p0d6$aj6$1@dough.gmane.org> <4E300828.3000601@anonymous.org.uk> <j0p2g2$nmp$1@dough.gmane.org> <20110728065541.3e2d5cac@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110728065541.3e2d5cac@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/27/2011 10:55 PM, NeilBrown wrote:
> When md finds that it might be good to write to a known-bad-block it has two
> options - to write or not.
> It makes the choice based on whether it has seen any write errors on that
> device since the array was assembled.
> If it has - it just doesn't write and leaves the block 'bad'.
> If it has not it tries to write.  On success it clears the record of the bad
> block.

Sounds reasonable.

> On failure it decides not to write to and more bad blocks on that
> device.

This sentence may just miss one verb, but that might be an important
one. Did you mean to say "on failure (of writing to a block that had
been marked as bad, after a re-assembly) that one block will not be
written to (until after the next re-assembly)"?


> The idea of marking a device as 'rotational' always seemed dumb to me.
> Because people assume that 'rotational' is a disk drive and '!rotational' is
> an SSD.  But what if some other technology comes along with behaviour
> somewhere between the two??

The naming of that flag is really awkward.

> I think the primary meaning of 'rotational' as implemented is 'seek is
> instant'.

(That would be the meaning of 'not rotational'.)

> This is quite a different meaning to 'blocks migrate around the
> device' even though both are true of current SSDs.

Right, the seeking and "wear levelling" features are completely orthogonal.

> I'm not sure that md can usefully do anything different on SSDs than on
> spinning rust.

At least MD could make block devices it creates inherit the "rotational"
flag, as an "OR"ed combination of the slave block devices (because if one
slave needs time for seeking, so probably will the RAID as a whole).

 From that the scheduler could benefit when writing to the MD device -
at least the amount of places where the "rotational" flag is checked
for in the scheduler code suggests that such a benefit may exist.


> You certainly still want to record read errors.

It probably cannot harm to record them, but it probably has no benefit, either.
I've had SSDs returning read errors for single blocks (which were gone after
rewriting), and the SSD, unlike a magnetic disk, will certainly not take
any significant extra time to report such an error, it's just a checksum-mismatch,
after all, and retries are either extremely fast or futile (no wait for
the next rotation involved).


> If you get a write error it
> probably means that a large part of the device is bad ... but I suspect you
> will notice that soon enough anyway.

I'd guess so, too.

Regards,

Lutz Vieweg



