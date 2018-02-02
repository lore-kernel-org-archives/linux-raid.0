From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multi-layer raid status
Date: Fri, 02 Feb 2018 15:50:41 +0100
Message-ID: <5A747AC1.8030206@hesbynett.no>
References: <5A708F8E.2040604@hesbynett.no> <87372k2aix.fsf@notabene.neil.brown.name> <5A744054.4060305@hesbynett.no> <5A7448AF.3050108@youngman.org.uk> <5A744C4B.7030704@hesbynett.no> <5A7474B1.1020807@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A7474B1.1020807@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/18 15:24, Wols Lists wrote:
> On 02/02/18 11:32, David Brown wrote:
>> You already do that during a scrub.  You don't want to do it during
>> normal operations - unless you have a usage pattern with mostly big
>> reads, you will cripple performance.  A small performance drop is
>> acceptable if it can be shown to significantly improve reliability - but
>> making every read a full stripe read will give you random read
>> performance closer to that of a single disk than a raid array.
> 
> Unless integrity is more important than speed?

There are scenarios where it is realistic to expect integrity problems -
sudden decay of a disk sector is not a likely event.  There is /no/ good
reason for saying that when you read sector 1000 from disk A, you should
also read sector 1000 from disk B just in case that happened to go bad.
 Reading a whole stripe when you need to read one sector gives you
/nothing/.  Reading the whole stripe and checking the parity gives you
/almost/ nothing - if there is an error on the sector you are reading,
the disk tells you.  Undetected read errors are the pink unicorns of the
computing world - there are people who swear they have seen them, but
real evidence is very hard to come by.  And even then, there are much
better ways to deal with them (btrfs checksums, for example).

And, yet again, you have regular scrubs.  These have low bandwidth cost
(because you run them slowly, and because they do not flood your block
and stripe caches), and will detect any such errors.

Integrity is important, but it is not so important that nothing else
matters.  Do you make sure all your servers are six stories underground
in concrete bunkers?  Don't tell me you are unwilling to pay that cost -
surely you don't want to risk losing data to a meteorite strike?

Do you drive a tank to work?  After all, surely your personal safety is
more important than speed, or fuel costs.

> 
> Unless (like in your own example) you know there's a problem and you
> want to find it?

First, it is not an unknown problem - it is a known event.  Second,
reading full stripes for every disk read will not help in any way,
because your chances of reading the sector in question are tiny for most
normal usage pattern.  Third, normal regular scrubs will catch it just
the same, merely with a bit of delay.  If you want to get it faster and
don't mind low performance, increase the scrub bandwidth.

All I am asking is if is possible to have a targeted scrub on just the
relevant blocks, to minimise the low redundancy period.

> 
> Yup I know it will knacker performance - I said so. But there are plenty
> of use cases where it would actually be very useful, and probably the
> lesser of two evils.

What are these cases?  We have already eliminated the rebuild situation
I described.  And in particular, which use-cases are you thinking of
where you not be better off with alternative integrity improvements
(like higher redundancy levels) without killing performance?

> 
> (Actually, re-reading your original email, it actually sounds like the
> right thing to do would be to call hdparm to mark the sector bad on sda,
> rather than use badblocks, so it will rewrite and clear itself. And this
> is also a perfect example of where my technique would be useful - it's
> probably not the raid-5 parity block that gets corrupted, therefore the
> data itself has been corrupted, therefore my utility would find the
> damaged file for you so you could recover from backup. A scrub at the
> raid-5 level would just "fix" the parity and leave you with a corrupted
> file waiting to blow up on you.)
> 

That does not make sense.  The bad block list described by Neil will do
the job correctly.  hdparm bad block marking could also work, but it
does so at a lower level and the sector is /not/ corrected
automatically, AFAIK.  It also would not help if the raid1 were not
directly on a hard disk (think disk partition, another raid, an LVM
partition, an iSCSI disk, a remote block device, an encrypted block
device, etc.).



