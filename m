From: David Brown <david.brown@hesbynett.no>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 09:26:18 +0200
Message-ID: <5399561A.4030405@hesbynett.no>
References: <5397FBCE.3060009@bartk.us>	<53990D44.300@fnarfbargle.com> <20140612122814.2db74377@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140612122814.2db74377@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Brad Campbell <lists2009@fnarfbargle.com>
Cc: Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/06/14 08:28, Roman Mamedov wrote:
> On Thu, 12 Jun 2014 10:15:32 +0800
> Brad Campbell <lists2009@fnarfbargle.com> wrote:
> 
>> On 11/06/14 14:48, Bart Kus wrote:
>>> Hello,
>>>
>>> As far as I understand, md-raid relies on the underlying devices to
>>> inform it of IO errors before it'll seek redundant/parity data to
>>> fulfill the read request.  I have, however, seen certain hard drives
>>> report successful reads while returning garbage data.
>>
>> If you have drives that return garbage as valid data then you have far 
>> greater problems than what you are suggesting will fix. So much so I 
>> suggest you document these instances and start banging a drum announcing 
>> them in a name and shame campaign. That sort of behavior from storage 
>> devices is never ok, and the manufacturer needs to know that.
> 
> If your RAM can return garbage, that's not a justification for having ECC RAM.
> ECC RAM is a gimmick invented by weak conformist people. Instead, you should go
> and loudly scream at the manufacturer who sold you that RAM! Errors from RAM
> are never OK! RAM should always work perfectly! And if it doesn't, you have
> greater problems. We shall not tolerate this behavior! So go get a drum and
> start banging it as loudly as you can! Name and shame the manufacturer who
> sold you that RAM. Fight the power, brother!!!

There are several points here.

First, RAM is susceptible to single event upsets - typically a cosmic
ray that hits the RAM array and knocks a bit out.  As geometries get
smaller and ram gets denser, this gets more likely.  So ECC on ram makes
sense as an economically practical way to reduce the impact of
real-world errors that are unavoidable (i.e., it's not just bad design
or production of the chips).  What would make more sense, however, is to
avoid the extra ECC lines from the chips - the ECC mechanism should be
entirely within the RAM chips.  The extra parity lines between the
memory and the controller are a left-over from the old days in which
there was no logic on the memory modules.

Secondly, hard disks already have ECC, in several layers.  There is
/far/ more error detection and correction on the data read from the
platters than you could hope to do in software at the md layer.  There
is nothing that you can do on the md layer to detect bad reads that
could not be better handled on the controller on the disk itself.  So if
you are getting /undetected/ read errors from a disk (as distinct from
/unrecoverable/ read errors), then something has gone very bad.  It is
at least as likely to be a write error as a read error, and you will
have no idea how long it has been going on and how much of your data is
corrupt.  It is probably a systematic error (such as firmware bug) in
either the disk controller or the interface card.  Such faults are
fortunately very rare - and thus very rarely worth the cost of checking
for online.

And since an undetected read error is not just an odd occasional event,
but a catastrophic system failure, the correct response is not
"re-create the data from parities" - it is "full scale panic - assume
/all/ your data is bad, check from backups, call the hardware service
people, replace the entire disk system".


If you really are paranoid about the integrity of data in the face of
undetected read errors, then there are three ways to handle it.  One is
by doing a raid scrub (a good idea anyway, to maintain redundancy
despite occasional detected read errors) - this will detect such
problems without the online costs.  Another is to maintain and check
lists of checksums (md5, sha256, etc.) of files - this is often done as
a security measure to detect alteration of files during break-ins.
Finally, you can use a filesystem that does checksumming (it is vastly
easier and more efficient to do the checksumming at the filesystem level
than at the md raid level) - btrfs is the obvious choice.

> 
> You can probably tell just how sick I am of reasoning like yours. That's why
> we can't have nice things (md-side resiliency for the cases when you need/want
> it), and sadly Neil is of the same opinion as you.
> 

If you disagree so strongly, you are free to do something about it.  The
people (Neil and others) who do the work in creating and maintaining md
raid know a great deal about the realistic problems in storage systems,
and realistic solutions.  They understand when people want magic, and
they understand the costs (in development time and run time) of
implementing something that is at best a very partial fix to an almost
non-existent problem (since the most likely cause of undetected read
errors is things like controller failure, which have no possible
software fix).  Given their limited time and development resources, they
therefore concentrate on features of md raid that make a real difference
to many users.

However, this is all open source development.  If you can write code to
support new md modes that do on-line scrubbing and smart recovery, then
I'm sure many people would be interested.  If you can't write the code
yourself, but can raise the money to hire a qualified developer, then
I'm sure that would also be of interest.

The point is not that such on-line checking is not a "nice thing" to
have - /I/ don't think it would be worth the on-line cost, but some
people might and choice is always a good thing.  The point is that it is
very rarely a useful feature - and there are many other "nice things"
that have higher priority amongst the developers.

<http://neil.brown.name/blog/20100211050355>
<http://neil.brown.name/blog/20110227114201>




