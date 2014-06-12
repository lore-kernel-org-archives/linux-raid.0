From: David Brown <david.brown@hesbynett.no>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 13:27:07 +0200
Message-ID: <53998E8B.1090905@hesbynett.no>
References: <5397FBCE.3060009@bartk.us>	<53990D44.300@fnarfbargle.com>	<20140612122814.2db74377@natsu>	<5399561A.4030405@hesbynett.no> <20140612140644.352e8c69@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140612140644.352e8c69@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/06/14 10:06, Roman Mamedov wrote:
> On Thu, 12 Jun 2014 09:26:18 +0200
> David Brown <david.brown@hesbynett.no> wrote:
> 
>> Secondly, hard disks already have ECC, in several layers.  There is
>> /far/ more error detection and correction on the data read from the
>> platters than you could hope to do in software at the md layer.  There
>> is nothing that you can do on the md layer to detect bad reads that
>> could not be better handled on the controller on the disk itself.  So if
>> you are getting /undetected/ read errors from a disk (as distinct from
>> /unrecoverable/ read errors), then something has gone very bad.  It is
>> at least as likely to be a write error as a read error, and you will
>> have no idea how long it has been going on and how much of your data is
>> corrupt.  It is probably a systematic error (such as firmware bug) in
>> either the disk controller or the interface card.  Such faults are
>> fortunately very rare - and thus very rarely worth the cost of checking
>> for online.
> 
> In one case which Brad was describing, it was a hardware design fault in his
> RAID controller, resulting in it returning bad data only when all ports are
> utilized at high speeds. If MD had online checksum mismatch detection, it
> would alert him immediately that something's going wrong, rather than have
> this bug happily chew through all his data, with "months of read/modify/write
> cycles combined with corrupt data spread the corruption all over the array".

More regular scrubs would have spotted the issue sooner, though not as
soon as online checks.  Fortunately, cases like this are rare.

> 
>> And since an undetected read error is not just an odd occasional event,
>> but a catastrophic system failure, the correct response is not
>> "re-create the data from parities" - it is "full scale panic - assume
>> /all/ your data is bad, check from backups, call the hardware service
>> people, replace the entire disk system".
> 
> Sure, it could and should loudly complain with "zomg, we just had a data
> corruption and had to correct it from parity" messages to dmesg.
> 

I would be tempted to consider a "kernel panic" rather than a log
message.  If such a serious problem is found, you don't want to write
anything more to the disks in case you make things worse - the user may
be better off disconnecting the disks and re-connecting them on another
system to get the data off them.

Of course, it would be nicer to make the level of reaction configurable.

>> Another is to maintain and check lists of checksums (md5, sha256, etc.)
>> of files - this is often done as a security measure to detect alteration
>> of files during break-ins.
> 
> Not always feasible at all, in case of e.g. VM images, including those of
> "other" operating systems, also in case of e.g. actively modified databases.
> 

Yes - it works for some usage patterns, but not others.

>> Finally, you can use a filesystem that does checksumming (it is vastly
>> easier and more efficient to do the checksumming at the filesystem level
>> than at the md raid level) - btrfs is the obvious choice.
> 
> Btrfs could not be further from the obvious choice at the moment, as Btrfs
> RAID5/6 support is still in its infancy.
> 
> Sure you could use Btrfs in a single-device mode over MD; then it would detect
> any checksum errors as they happen. But of course it will not be able to
> correct them.

That's correct.  But since the chances of you having an undetectable
read error are tiny, and there is /no/ good answer for how to "correct"
it, then a simple detection is absolutely fine.

> 
> Which is sad, since MD (on RAID6) *has* all the parity information needed to
> recover a read error, and there isn't even any need for a special filesystem
> on top of it, but it's like it just won't help you, almost out of principle.

Before going any further, you must understand that there is /no/ way to
recover from such read errors.  There are ways that /might/ help,
depending on the underlying cause.  Detection is important here, not
recovery, so a filesystem checksum that turns an undetected read error
into a detected one is all that's needed.

Another thing to note here is that there are a few circumstances in
which a parity mismatch is actually normal behaviour - and any automatic
online system would have to be able to distinguish those.  If parts of
the array are out of sync, such as when first building the array, while
writing a stripe, or after an unclean shutdown, then you will get
mismatches.  Swap areas can also be out of sync for short times if
memory changes while the pages are being written.  Such issues make it
harder than it might first seem to implement online checking.

> 
>> If you disagree so strongly, you are free to do something about it.  The
>> people (Neil and others) who do the work in creating and maintaining md
>> raid know a great deal about the realistic problems in storage systems,
>> and realistic solutions.  They understand when people want magic, and
>> they understand the costs (in development time and run time) of
>> implementing something that is at best a very partial fix to an almost
>> non-existent problem (since the most likely cause of undetected read
>> errors is things like controller failure, which have no possible
>> software fix).  Given their limited time and development resources, they
>> therefore concentrate on features of md raid that make a real difference
>> to many users.
> 
> Absolutely, however the thing is, having a mode to always full-check RAID1/5/6
> reads does not even seem like an extremely complicated feature to implement;
> it's just the collective echo chamber of "this is useless; we don't need this;
> md is the wrong place to do this; etc" that discourages any work in this area.
> And those who think that on the contrary this is a good idea (as Brad said,
> "this comes up at least once a year") typically lack the necessary experience
> with the MD or kernel programming to implement it themselves.
> 
>> However, this is all open source development.  If you can write code to
>> support new md modes that do on-line scrubbing and smart recovery, then
>> I'm sure many people would be interested.  If you can't write the code
>> yourself, but can raise the money to hire a qualified developer, then
>> I'm sure that would also be of interest.
> 
> Sure, but that also does not stop me from doing my part by whining^W providing
> valuable input on mailing lists, to signal to any interested developers that
> yes, that's indeed one feature which is very much in demand by some users in
> the real world :)
> 

That's certainly true - user pressure and demands is always an influence
when prioritising development!

