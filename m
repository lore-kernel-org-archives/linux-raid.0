From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Mon, 22 Feb 2010 14:30:44 +0100
Message-ID: <20100222133044.GA3507@lazy.lzy>
References: <20100218100547.7aecdc34@notabene.brown>
 <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown>
 <4B7F2013.4070905@shiftmail.org>
 <87k4u8zg3t.fsf@frosties.localdomain>
 <4B7FC3A7.10104@shiftmail.org>
 <87iq9qu9j5.fsf@frosties.localdomain>
 <8754A21825504719B463AD9809E54349@m5>
 <20100221194400.GA2570@lazy.lzy>
 <4B828029.3020604@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B828029.3020604@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Guy Watkins <linux-raid@watkins-home.com>, 'Goswin von Brederlow' <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Even "nothing"?
> Why?

for the following reasons:

1) the "check" command is useless if there are mismatches,
harmful or harmless they could be
2) the mirroring concept implies *identical* mirrors, not
identical only if the upper layer decides so
3) if a filesystem has a small bug, this will not be catched
later, that is, it could be the filesystem causes a *wrong*
mismatch (like there are correct ones)
4) in general, it is not safe to offer a mirroring which is
not always mirroring properly

> 
> Here we are talking about "nothing".
> 
> Or so it seems.

As I wrote, it does not matter, it is just not correct
to rely on the good will of other pieces of software to
guarantee the RAID-1 is working properly.
The RAID-1 should work properly because it does work
properly, not because the filesystem is kind enough to
allow it to work properly.

This could be a system design problem, not and MD one, of
course, so I'm stating the Neil or others should fix the
MD, what I'm writing is that it is astonishing to me
that things work this way (or "walk this way").

That's it, I'm just surprised to learn such situations
are present.

bye,

-- 

piergiorgio
