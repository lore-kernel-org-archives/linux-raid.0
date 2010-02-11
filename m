From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 11 Feb 2010 19:12:04 +0100
Message-ID: <20100211181204.GA2792@lazy.lzy>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
 <4B67451F.8040206@tmr.com>
 <20100202093738.44b4fece@notabene.brown>
 <4B684087.50001@tmr.com>
 <20100211161444.7a0ea7bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100211161444.7a0ea7bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

> > This whole discussion simply shows that for RAID-1 software RAID is less 
> > reliable than hardware RAID (no, I don't mean fake-RAID), because it 
> > doesn't pin the data buffer until all copies are written.
> > 
> 
> That doesn't make it less reliable.  It just makes it more confusing.

well, sorry to say, but it makes it useless.

The problem is: how can we be sure that the FS really
plays tricks only with blocks which will be unused?

In other words, either there should be an agreed and
confirmed interface between caller (FS) and called (MD),
handling the situation properly (i.e. the FS will not
do these pranks), or the called (MD) should be robust
agains all possible nasty things the caller (FS) can do.

Because what will happen if someone introduces a new
FS which works fine with all, but software RAID?

Similarly, I've some, identical, PCs, with RAID-10 f2.

Starting with Fedora 12, there is a weekly check of
the RAID array (with email notification, BTW without
mismatch count...).

On these PCs I get mismatches, sometimes.
Checking the mismatch count I found out that this is
changing, sometimes a bit more, sometimes a bit less (o zero).

Now, IMHO the check is completely useless and even annoying.

I've got mismatches, changing, but I do not know how
serious these are.

Not good... I could have lost data or not, and I do
not know...

> But for a more complete discussion on raid recovery and when it might be
> sensible to "vote" among the blocks, see
>    http://neil.brown.name/blog/20100211050355
> 

Nice, discussion.
Expecially the clarification about the unclean shutdown event.
This could be, in effect, a killer for the majority select
(or RAID-6 reconstrunction) decision.

I personally agree with the conclusion of your conclusion.
Anyway, I miss, or I did not get, one more point.

Specifically, the "smart recovery" should be composed by
two steps. One is detecting where the problems are.
This means not only the stripe, but, in case of RAID-6,
also the *potential* component (HDD) of the array.

Reason is that, as I already wrote some times ago,
there is a *huge* difference between having all the
mismatches *potentially* on one single component, or
spread around several.

The first case clearly gives more information and allows
a better judgment of the situation.

Thanks,

bye,

-- 

piergiorgio
