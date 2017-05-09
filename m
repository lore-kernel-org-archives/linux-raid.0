From: David Brown <david.brown@hesbynett.no>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 13:09:37 +0200
Message-ID: <5911A371.3030008@hesbynett.no>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>        <590B3039.3060000@youngman.org.uk>        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>        <87vapb6s9h.fsf@esperi.org.uk>        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> <87inla73vz.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87inla73vz.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Anthony Youngman <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/05/17 11:53, Nix wrote:
> On 8 May 2017, Anthony Youngman told this:
> 
>> If the scrub finds a mismatch, then the drives are reporting
>> "everything's fine here". Something's gone wrong, but the question is
>> what? If you've got a four-drive raid that reports a mismatch, how do
>> you know which of the four drives is corrupt? Doing an auto-correct
>> here risks doing even more damage. (I think a raid-6 could recover,
>> but raid-5 is toast ...)
> 
> With a RAID-5 you are screwed: you can reconstruct the parity but cannot
> tell if it was actually right. You can make things consistent, but not
> correct.
> 
> But with a RAID-6 you *do* have enough data to make things correct, with
> precisely the same probability as recovery of a RAID-5 "drive" of length
> a single sector. 

No, you don't have enough data to make things correct.  You /might/ have
enough data to make a guess what /might/ be right to make things wrong,
but might also be wrong.  And you don't have enough data to have the
slightest idea about the probabilities.  And you don't have enough data
to know if "fixing" it will help overall, or make things worse if you
accidentally "fix" the wrong block.  (See the link I gave on other posts
for details.)

> It seems wrong that not only does md not do this but
> doesn't even tell you which drive made the mistake so you could do the
> millions-of-times-slower process of a manual fail and readdition of the
> drive (or, if you suspect it of being wholly buggered, a manual fail and
> replacement).
> 
>> And seeing as drives are pretty much guaranteed (unless something's
>> gone BADLY wrong) to either (a) accurately return the data written, or
>> (b) return a read error, that means a data mismatch indicates
>> something is seriously wrong that is NOTHING to do with the drives.
> 
> This turns out not to be the case. See this ten-year-old paper:
> <https://indico.cern.ch/event/13797/contributions/1362288/attachments/115080/163419/Data_integrity_v3.pdf>.
> Five weeks of doing 2GiB writes on 3000 nodes once every two hours
> found, they estimated, 50 errors possibly attributable to disk problems
> (sector- or page-size regions of corrupted data) on 1/30th of their
> nodes. This is *not* rare and it is hard to imagine that 1/30th of disks
> used by CERN deserve discarding. It is better to assume that drives
> misdirect writes now and then, and to provide a means of recovering from
> them that does not take days of panic. RAID-6 gives you that means: md
> should use it.

RAID-6 does not help here.  You have to understand the types of errors
that can occur, the reasons for them, the possibilities for detection,
the possibilities for recovery, and what the different layers in the
system can do about them.

RAID (1/5/6) will let you recover from one or more known failed reads,
on the assumption that the driver firmware is correct, memories have no
errors, buses have no errors, block writes are atomic, write ordering
matches the flush commands, block reads are either correct or marked as
failed, etc.

RAID will /not/ let you reliably detect or correct other sorts of
errors.  It is designed to cheaply and simply reduce the risk of a
certain class of possible errors - it is not a magic method of stopping
all errors.  Similarly, the drive firmware works under certain
assumptions to greatly reduce other sorts of errors (those local to the
block), but not everything.  And ECC memory, PCI bus CRCs, and other
such things reduce the risk of other kinds of error.

If you need more error checking or correction, you need different
mechanisms.  For example, BTRFS and ZFS will do checksumming on the
filesystem level.  They can be combined with raid/duplication to allow
correction on checksum error.  And they can usefully build on top of a
normal md raid layer, or use their own raid (with its pros and cons).
Or you can have multiple servers and also track md5 sums of files, with
cross-server scrubbing of the data.  There are lots of possibilities,
depending on what you want to get.

What does /not/ work, however, is trying to squeeze magic capabilities
out of existing layers in the system, or expecting more out of them that
they can give.


