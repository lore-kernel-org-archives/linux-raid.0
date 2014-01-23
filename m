From: David Brown <david.brown@hesbynett.no>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Thu, 23 Jan 2014 09:18:40 +0100
Message-ID: <52E0D060.3020508@hesbynett.no>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/01/14 01:48, Chris Murphy wrote:
> 
> On Jan 22, 2014, at 3:40 AM, David Brown <david.brown@hesbynett.no>
> wrote:
>> 
>> If the raid system reads in the whole stripe, and finds that the 
>> parities don't match, what should it do?
> 
> https://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf page 8
> shows how it can be determined whether data, or P, or Q are corrupt.
> Multiple corruptions could indicate if a particular physical drive is
> the only source of corruptions and then treat it as an erasure. Using
> normal reconstruction code, the problem is correctable. But I'm
> uncertain if this enables determination of the specific device/chunk
> when there is data corruption within a single stripe.

That's true - but (as pointed out in Neil's blog) there can be other
reasons why one block is "wrong" compared to the others.  Supposing you
need to change a single block in a raid 6 stripe.  That means you will
change that block and both parity blocks.  If the disk system happens to
write out the data disk, but there is a crash before the parities are
written, then you will get a stripe that is consistent if you "erase"
the new data block - when in fact it is the parity blocks that are wrong.

Another reason for avoiding "correcting" data blocks is that it can
confuse the filesystem layer if it has previously read in that block
(and the raid layer cannot know for sure that it has not done so), and
then the raid layer were to "correct" it without the filesystem's knowledge.

So automatic "correction" here would be hard, expensive (erasure needs a
lot more computation than generating or checking parities), and will
sometimes make problems worse.  There are good arguments for using such
erasure during an offline check/scrub (especially once the 3+ parity
raids are in place), but not online.  For online error correction, you
need more sophistication, such as battery backed memory to track the
write orders.

> 
> It seems there's still an assumption that if data chunks produce P'
> and Q' which do not match P or Q, that P and Q are both correct which
> might not be true.
> 
>> Before considering what checks can be done, you need to think
>> through what could cause those checks to fail - and what should be
>> done about it.  If the stripe's parities don't match, then
>> something /very/ bad has happened - either a disk has a read error
>> that it is not reporting, or you've got hardware problems with 
>> memory, buses, etc., or the software has a serious bug.
> 
> Yes but we know that these things actually happen, even if rare. I
> don't know how common ECC fails to detect error, or detects but
> wrongly corrects, but we know that there are (rarely) misdirected
> writes. That not lonly obliterates data that might have been stored
> where the data landed, but it also means it's missing where it's
> expected. Neither drive nor controller ECC helps in such cases.
> 

I have no disagreement about adding extra checking (and correcting, if
possible) into the system - but I think btrfs is the right place, not
the raid layer.  Btrfs will spot exactly these cases, and correct them
if it has redundant copies of the data.  And because it is at the
filesystem level, it has more knowledge and can do more sophisticated
error checking for a lot less effort than is done at the raid level.

It would be /nice/ if this could be done well - reliably and cheaply -
at the raid level.  But it can't.

>> In any case, you have to question the accuracy of anything you read
>> off the array - you certainly have no way of knowing which disk is
>> causing the trouble.
> 
> I'm not certain. From the Anvin paper, equation 27 suggests it's
> possible to know which disk is causing the trouble. But I don't know
> if that equation is intended for physical drives corrupting a mix of
> data, P and Q parities - or if it works to isolate the specific
> corrupt data chunk in a single (or more correctly, isolated) stripe
> data/parity mismatch event.

The principle is quite simple, although it involves quite a bit of
calculations.

Read the whole stripe - D0, D1, ..., Dn, P, Q at once.  We can assume
that the drive reports all reads as "good" - if not (and this is the
usual case on read errors), we know which block is bad.  Use the read
D0, ..., Dn to calculate new P' and Q'.  If these match the read P and
Q, we are happy.  If not, then something is wrong.  If P matches, then
assume the Q block is bad - if Q matches, assume the P block is bad.

Failing that, try assuming that D0 is bad - recreate D0' from D1, ...,
Dn, P.  Calculate a new Q'.  If this matches the read Q, then we can
make the stripe consistent by replacing D0.  We have no guarantees that
D0 is the problem, but it is the best bet statistically.  If we still
don't have a match for Q' = Q, then keep the read in D0 and guess that
D1 is wrong.  If we make it through all the drives without getting a
match, there is more than one inconsistency and we have no chance.

> 
> I think in the case of a single, non-overlapping corruption in a data
> chunk, that RS parity can be used to localize the error. If that's
> true, then it can be treated as a "read error" and the normal
> reconstruction for that chunk applies.

It /could/ be done - but as noted above it might not help (even though
statistically speaking it's a good guess), and it would involve very
significant calculations on every read.  At best, it would mean that
every read involves reading a whole stripe (crippling small read
performance) and parity calculations - making reads as slow as writes.
This is a very big cost for detecting an error that is /incredibly/
rare.  (The link posted earlier in this thread suggested 1000 incidents
in 41 PB of data.  At that rate, I know that it is far more likely that
my company building will burn down, losing everything, than that I will
ever see such an error in the company servers.  And I've got a backup.)

Checksuming at the btrfs level, on the other hand, is cheap - because
the filesystem already has the checksumming data on hand as part of the
metadata for the file.  This is a type of "shortcut" that the raid level
cannot possibly do with the current structure, because it knows nothing
about the structure of the data on the disks.  Of course, if the
computer had a nice block of fast non-volatile memory, md raid could use
it to store things like block checksums, write bitmaps, logs, etc., and
make a safer and faster system than we have today.  But there is no such
convenient memory available for now.

So if you worry about these sorts of errors, use btrfs or zfs.  Or
combine regular backups with extra checks (such as running your files
through sha256sum and comparing to old copies).

> 
>> Probably the best you could do is report the whole stripe read as 
>> failed, and hope that the filesystem can recover.
> 
> With default chunk size of 512KB that's quite a bit of data loss for
> a file system that doesn't use checksummed metadata.
> 
> 
> Chris Murphy
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

