From: David Rees <drees76@gmail.com>
Subject: Re: RAID5 in strange state
Date: Wed, 8 Apr 2009 16:43:15 -0700
Message-ID: <72dbd3150904081643j378a7490j1ee1b7975f151a0@mail.gmail.com>
References: <49DD1730.4070108@gmx.net> <878wmag62s.fsf@frosties.localdomain>
	<49DD2302.3010206@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DD2302.3010206@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Frank Baumgart <frank.baumgart@gmx.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 8, 2009 at 3:19 PM, Frank Baumgart <frank.baumgart@gmx.net> wrote:
> Adding an internal bitmap to an existing array will not destroy any
> data, correct?

Yes, safe to do at any time (as long as it's not syncing, in which
case it simply won't work).

> Anyway I wonder why the array did not come up automatically as 2 out of
> the 3 devices were still working and in sync.

Good question!  Hard to answer - it sure looks like it should have
assembled the two good drives and had the third drive as stopped.

-Dave
