From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Last ditch plea on remote double raid5 disk failure
Date: Mon, 31 Dec 2007 17:19:31 +0300
Message-ID: <4778FA73.7010208@msgid.tls.msk.ru>
References: <8e0f3ba80712310239w3263b2b8hb62c0a6c79a84b77@mail.gmail.com> <18296.56100.769123.555100@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18296.56100.769123.555100@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Marc MERLIN <merlin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday December 31, merlin@gmail.com wrote:
>> I'm hoping that if I can get raid5 to continue despite the errors, I
>> can bring back up enough of the server to continue, a bit like the
>> remount-ro option in ext2/ext3.
>>
>> If not, oh well...
> 
> Sorry, but it is "oh well".

Speaking of all this bad block handling and dropping device in case
of errors.  Sure thing the situation here improved ALOT when rewriting
a block in case of read error has been introduced.  This was a very
big step into the right direction.  But this is still not sufficient,
I think.

What can be done currently, is to extend bitmap thing, to keep more
information.  Namely, if a block on one drive fails, and we failed
to rewrite it as well (or when there was no way to rewrite it because
the array was already running in degraded mode), don't drop the drive
still, but fail the original request, AND mark THIS PARTICULAR BLOCK
of THIS PARTICULAR DRIVE as "bad" in the bitmap.

In the other words, bitmap can be extended to cover individual drives
instead of the whole raid device.

It's more - if there's no bitmap for the array, I mean no persistent
bitmap, such a thing can still be done anyway, by keeping such a bitmap
in memory only, up until the raid array will be shut down (in which case
mark the whole drives with errors as "bad").  This way, it's possible
to recover alot more data without risking losing the whole array any
time.

It's even more - up until some real write will be performed over a "bad"
block, there's no need to record its badness - we can return the same
error again as it's expected the drive will return it on a next read
attempt.  It's only write - real write - which makes this particular
block to become "bad" as we wasn't able to write new data to it...

Hm.  Even in case of write failure, we can still keep the whole drive
without marking anything as "bad", again in a hope that the next of
those blocks will error out again.  This is an.. interesting question
really, whenever one can rely on drive to not return bad (read: random)
data in case it errored write operation.  I definitely know a case
when it's not true: we've a batch of seagate drives which seem to have
firmware bug in them, which errors out on write with "Defect list
manipulation error" sense code, but reads on this very sector returns
something still, especially after a fresh boot (after a power-off).

In any case, keeping this info in a bitmap should be sufficient to
stop kicking the whole drives out of an array, which currently is
a weakest point in linux software raid (IMHO).  As it has been pointed
out numerous times before, due to Murhpy's laws or other factors such
as a phase of the Moon (and partly this behaviour can be described by
the fact that after a drive failure, other drives receives more I/O
requests, esp. when reconstruction starts, and hence have much more
chances to error out on sectors which were not read before in a long
time), drives tend to fail several at once, and often it's trivial to
read the missing information from a drive which has just been kicked
off the array at the place where another drive developed a bad sector.

And another thought around all this.  Linux sw raid definitely need
a way to proactively replace a (probably failing) drive, without removing
it from the array first.  Something like,
  mdadm --add /dev/md0 /dev/sdNEW --inplace /dev/sdFAILING
so that sdNEW will be a mirror of sdFAILING, and once the "recovery"
procedure finishes (which may use data from other drives in case of
I/O error reading sdFAILING - unlike described scenario of making a
superblock-less mirror of sdNEW and sdFAILING),
  mdadm --remove /dev/md0 /dev/sdFAILING,
which does not involve any further reconstructions anymore.

/mjt
