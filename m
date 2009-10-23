From: Billy Crook <billycrook@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 16:44:14 -0500
Message-ID: <a43edf1b0910231444g4c02097dq36640a01689d95f1@mail.gmail.com>
References: <70ed7c3e0910221840o795a61b9u77774725386868e2@mail.gmail.com>
	<222314.82857.qm@web38801.mail.mud.yahoo.com> <a43edf1b0910231332t48bb8357ib2bd9351a913fe5d@mail.gmail.com>
	<bb145bd20910231346h44c26b49x38af357e15d97597@mail.gmail.com>
	<Pine.GSO.4.64.0910232250100.5182@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0910232250100.5182@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>, Mattias Wadenstein <maswan@acc.umu.se>
Cc: linux-raid@vger.kernel.org, adfas asd <chimera_god@yahoo.com>
List-Id: linux-raid.ids

On Fri, Oct 23, 2009 at 15:46, Christian Pernegger <pernegger@gmail.com> wrote:
> For lots of people the primary role of RAID is as a protection against
> data-loss nowadays.

Yeah.  Lots of people don't understand technology and have delusional
expectations of silver bullet happy pill solutions that make their
tummy feel good.  I am not one of them.  Sysadmins shouldn't have any
part in that either.

> Backups just aren't feasible/cost-effective
> anymore for the amounts of data involved.

Backups have never been more feasable, and it is only going to get
cheaper and easier.  Visit Newegg, microcenter, ebay.  Google "backup
service".

> Sticking your head in the
> sand and repeating that mantra doesn't change that and it isn't
> helping.

That's odd.  I've always thought that those who imagined a raid array
as its own backup to be the ones with their heads in the sand.  The
reason people keep saying raid!=backup is because of those people who
keep thinking raid=backup.  "Mantra" it all you want.  Raid isn't
backup.  Ignoring that fact doesn't change it, and isn't helping.

>> The easiest and cleanest solution is to dd the first and last 100mb or
>> so of the disks with /dev/zero.
>
> Great, that'll destroy all hope of getting the data back. You're
> really something ...

You took that out of context and you know it.  Come back when you've
read the rest of the paragraph.  The filesystem is already gone.  It
was gone when the machine became unresponsive.  Get a greif counselor,
and some backup drives.

> How about don't panic, post any and all error messages you're getting
> (dmesg) and wait?

Time is money.  It would be quicker to recreate the array and restore
from a backup than to wait on a mailing list.  He might also want to
consider badblocks-ing the disks again a few times, and running the
smart tests on them.  I have a little script that makes that somewhat
easier.  See: http://kclug.org/wiki/index.php/Hard_Drive_Hell


On Fri, Oct 23, 2009 at 15:57, Mattias Wadenstein <maswan@acc.umu.se> wrote:
> Well, claiming that RAID will protect your data under all circumstances
> isn't helping either.

Amen.

> Backups will actually protect against such things as
> rm -rf:ing the wrong directory or mkfs:ing the wrong device, etc.

And filesystem corruption, which it sounds like this is.  Even fsck is
not guaranteed to recover files.  It will fix the filesystem, even if
that means truncating the / directory.

Here's a new offsite backup service with unlimited transfer and
unlimited storage, for just $5 a month. That could very realistically
be cheaper than your cost in power, hvac, and failed drives if you use
the service enough. http://www.backblaze.com/

see also: rsync, rsnapshot, rdiff-backup
