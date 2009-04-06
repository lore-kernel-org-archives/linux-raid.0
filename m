From: jim owens <jowens@hp.com>
Subject: Re: RAID halting
Date: Mon, 06 Apr 2009 16:35:08 -0400
Message-ID: <49DA677C.2080009@hp.com>
References: <20090405235540.KKYO1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405235540.KKYO1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:

> could tell without losing any additional files.  I'm not saying ext3 cause
> any of the problems, but it certainly allowed itself to be corrupted by
> hardware issues.

Some observations from a filesystem guy lurking on this list...

You won't find a filesystem that can't be corrupted by bad hardware.
Most devices lie these days and say the data is recorded when it
is not.  I have had drive firmware remap a bad sector but forget to
write the data to the spare sector. And the list goes on and on.

Most filesystems update some same set of common blocks to do a
create.  This is particularly true of journal filesystems like
reiserFS.  If the journal write stalls, everything else can hang
on a journaling fs.  And I've had drives that did their bad sector
remap by first running through multiple algorithms trying the
original sector before going to the spare on every access!

While I agree your symptoms sound more like a software problem, my
experience with enterprise raid arrays and drives says I would not
rule hardware out as the trigger for the problem.

That 20 minute hang sure sounds like an array ignoring the host.
With an enterprise array a 20 minute state like that is "normal"
and really makes us want to beat the storage guys severely.

As was pointed out, there is a block layer "plug" when a device
says "I'm busy".  That requires the FS to issue an "unplug", but
if a code path doesn't have it... hang until some other path is
taken that does do the unplug.

I suggest using blktrace to see what is happening between the
filesystem, block layer, and device.

As to your choice of ReiserFS.  I don't have personal experience
with it, but check Wikipedia.  What I do see is no developers
are actively working on it, which is not a good sign.  On the
other hand, ext3, JFS, and XFS all have active developers so
they are kept up to date with changes in the surrounding kernel.

But none of them will protect you from bad hardware.

jim
