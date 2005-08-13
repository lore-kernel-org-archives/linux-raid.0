From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH md 006 of 6] Add write-behind support for md/raid1
Date: Sat, 13 Aug 2005 08:00:32 +0300
Message-ID: <200508130800.32901.a1426z@gawab.com>
References: <20050811171720.10115.patches@notabene> <200508120922.52689.a1426z@gawab.com> <42FC92C6.7060604@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42FC92C6.7060604@steeleye.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: NeilBrown <neilb@cse.unsw.edu.au>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Al Boldi wrote:
> > NeilBrown wrote:
> >>If a device is flagged 'WriteMostly' and the array has a bitmap,
> >>and the bitmap superblock indicates that write_behind is allowed,
> >>then write_behind is enabled for WriteMostly devices.
> >
> > Nice, but why is it dependent on WriteMostly?
>
> WriteMostly is just a flag that tells us which devices will get the
> write-behinds, and which will not. You'll be able to mix any
> combination of WriteMostly devices and normal devices in a raid1.
>

Yes, but doesn't WriteMostly imply ReadDelay?
If so, doesn't that mean that WriteBehind is dependent on ReadDelay?

--
Al

