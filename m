From: David Greaves <david@dgreaves.com>
Subject: Re: Proactive Drive Replacement
Date: Fri, 24 Oct 2008 09:09:33 +0100
Message-ID: <490182BD.9070109@dgreaves.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com> <20081024055726.GA16857@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081024055726.GA16857@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Tue, Oct 21, 2008 at 09:38:17AM +0100, David Greaves wrote:
>> The main issue is that the drive being replaced almost certainly has a
>> bad
>> block. This block could be recovered from the raid5 set but won't be.
>> Worse, the mirror operation may just fail to mirror that block -
>> leaving it
>> 'random' and thus corrupt the set when replaced.
> False,
> if SMART reports the drive is failing, it just means the number of
> _correctable_ errors got too high, remember that hard drives (*) do use
> ECC and autonomously remap bad blocks.
> You replace a drive based on smart to prevent it developing bad blocks.
I have just been through a batch of RMAing and re-RMAing 18+ dreadful Samsung
1Tb drives in a 3 and 5 drive level 5 array.

smartd did a great job of alerting me to bad blocks found during nightly short
and weekly long selftests.

Usually by the time the RMA arrived the drive was capable of being fully read
(once with retries). I manually mirrored the drives using ddrescue since this
stressed the remaining disks less, had a reliable retry* facility.
About 3 times the drive had unreadable blocks. In this case I couldn't use the
mirrored drive which had a tiny bad area (a few Kb in 1Tb) - I had to do a rebuild.
In one of these cases I developed a bad block on another component and had to
restore from a backup.

That was entirely avoidable.


> Ignoring the above, your scenario is still impossible, if you tried to
> mirror a source drive with a bad block, md will notice and fail the
> mirroring process. You will never end up with one drive with a bad block
> and the other with uninitialized data.
Well done. Great nit you found <sigh>.
When I wrote that I was thinking about the case above which wasn't md mirroring
and re-reading it I realise that I was totally unclear and you're right; that
can't happen.

However you seem to ignore the part of the threads that demonstrate my
understanding of the issue when I talk about mirroring from the failing drive
and the need to have md resort to the remaining components/parity in the event
of a failed block precisely to avoid md failing the mirroring process and
leaving you stuck :)

> If what you are really worried about is not bad block, but silent
> corruption, you should run a check (see sync_action in
> /usr/src/linux/Documentation/md.txt)
No, what I am worried about is having a raid5 develop a bad block on one
component and then, during recovery, develop a bad block (different #) on
another component.
That results in unneeded data loss - the parity is there but nothing reads it.

There was some noise on /. recently when they pointed back to a year-old story
about raid5 being redundant.
Well, IMO this proposal would massively improve raid5/6 reliability when, not
if, drives are replaced.

David

*I was stuck on 2.6.18 due to Xen - though eventually I did recovery using a
rescue disk and 2.6.27.
-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
