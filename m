From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 03:58:42 -0500
Message-ID: <200501030858.j038wo912210@www.watkins-home.com>
References: <2rana2-0if.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2rana2-0if.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Well, you can make somewhere. You only require an 8MB (one cylinder)
partition."

So, it is ok for your system to fail when this disk fails?
I don't want system failures when a disk fails, so mirror (or RAID5)
everything required to keep your system running.

"And there is a risk of silent corruption on all raid systems - that is
well known."
I question this....
I bet a non-mirror disk has similar risk as a RAID1.  But with a RAID1, you
know when a difference occurs, if you want.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Monday, January 03, 2005 3:03 AM
To: linux-raid@vger.kernel.org
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

Andy Smith <andy@strugglers.net> wrote:
> [-- text/plain, encoding quoted-printable, charset: us-ascii, 45 lines --]
> 
> On Sun, Jan 02, 2005 at 09:18:13PM +0100, Peter T. Breuer wrote:
> > Stephen Tweedie wrote:
> > > Umm, if soft raid is expected to have silent invisible corruptions in
> > > normal use,
> > 
> > It is, just as is all types of RAID.  This is a very strange thing for
> > Stephen to say - I cannot believe that he is as naive as he makes
> > himself out to be about RAID here and I don't know why he should say
> > that (presuming that he really knows better).
> > 
> > > then you shouldn't be using it, period.  That's got zero to
> > > do with journaling.
> > 
> > It implies that one should not be doing journalling on top of it.
> > 
> > (The logic for why RAID corrupts silently is that errors accumulate at
> > n times the normal rate per sector, but none of them are detected by
> > RAID (no crc), and when a disk drops out then you get a good chance of
> > picking up a corrupted copy instead of a good copy, because nobody
> > has checked the copy meanwhiles to see if it matches the original).
> 
> I have no idea which of you to believe now. :(

Both of us. We have not disagreed fundamentally. Read closely! Stephen
says "IF (my caps) soft raid is expected to have ...". Well, it is,
just like any RAID.

Similarly he didn't disagree that journal data is written twice, if you
read closely, he merely pointed out that the DEFAULT (my caps) setting
in ext3 is not to write data (as opposed to metadata) into the journal
at all.

So he avoided issues of substance there (and/but gave a strange spin to
them).

What he did claim that is factually interesting and new is that ext3
works if acks from the media are merely received after the fact. That's
a far weaker requirement than for reiserfs, for example. It seems to me
to imply that the implementation is single-threaded and highly
synchronous.

> I currently only have one system using software raid, and several of
> my employer's machines using hardware raid, all of which have
> various raid-1, -5 and -10 setups and all use only ext3.

All fine - as I said, the only thing I'd do is make sure that the
journal is not kept on the raid partition(s), and possibly turn off
data journalling in favour of metadata journalling only.

> Let's focus on the personal machine of mine for now since it uses
> Linux software RAID and therefore on-topic here.  It has /boot on a
> small RAID-1,

This is always a VERY bad idea. /boot and /root want to be on as simple
and uncomplicated a system as possible. Moreover, they never change, so
what is the point of having a real time mirror for them? It would be
sufficient to copy them every day (which is what I do) at file system
level to another partition, if you want a spare copy for emergencies.

> and the rest of the system is on RAID-5 with an
> additional RAID-0 just for temporary things.

That's fine.

> There is nowhere that is not software RAID to put the journals, so

Well, you can make somewhere. You only require an 8MB (one cylinder)
partition.

> would you be recommending that I turn off journalling and basically
> use it as ext2?

No, I'd be recommending that you make an 8MB partition for a journal.

This is also handy in case you "wear through" the disk under the
journal because of the high i/o there. Well, it's happened to me on two
disks, but doubtless people will cntest that! IF it happens, all you
have to do is use a cylinder somewhere else.

> What I do know is that none of what you say is in the software raid
> howto,

But nothing said is other than obvious, and is a matter of probabilities
and risk management, so I don't see why it should be in a howto!  That's
your business, not the howto's.

> and if you are right, it really should be.  Neither is it in

I don't think it should be. It should be somewhere in ext3 docs (there
was a time when ext3 wouldn't work on raid1 at all, butthat got fixed
somehow), but then documenting how your FS works on some particular
media is not really part of the documentation scope for the FS!

> any ext3 documentation and there is no warning on any distribution
> installer I have ever used (those that understand RAID and LVM and
> are happy to set that up at install time with ext3).  Also everyone
> that I have spoken to about this knows nothing about it, so what you

Everyone knows about it, because none of us is saying anything that is
not obvious. Yes, data is written through the journal twice. EVERYTHING
is written through the journal twice if the journal is on RAID1,
because everything on RAID1 is written twice. That is obvious, no?

And then you get i/o storms through the journal  in any case on
journalled raid, whenever you do data journalling. It is just doubled if
you do that on a raid system.

And there is a risk of silent corruption on all raid systems - that is
well known. DIfferent raid systems do different thigs to compensate,
such as periodically recalculating the parity on everything. But when
you have redundant data and a corruption occurs, which of the two
datasets do you believe? You have to choose one of them! You guess
wrong half the time, if you guess ("you" is a raid system). Hence
"silent corruption".

> are saying, if correct, would seem to have far-reaching
> implications.

I don't think so! Why? RAID protects you against certain sorts of risk.
It also exposes you to other sorts of risk. Where is the far-reaching
implication in that? It is for you to balance the risks and benefits.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

