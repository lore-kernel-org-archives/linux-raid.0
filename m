From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: Array Power Management
Date: Mon, 7 Sep 2009 15:55:23 +0300
Message-ID: <20090907125522.GL1933@hamsu.tarvainen.info>
References: <292245.77763.qm@web55804.mail.re3.yahoo.com> <70ed7c3e0909070257y4bec456h6de9cc6d2981c8ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909070257y4bec456h6de9cc6d2981c8ce@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: jahammonds prost <gmitch64@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 07, 2009 at 12:57:33PM +0300, Majed B. (majedb@gmail.com) wrote:

> If you're going to spin down the disks, you'd need to unmount the
> array first to ensure your data is fine, and after a spin-up then you
> mount the array again.

You don't needo to unmount it: just leave it mounted, and it will
automatically spin up when accessed.
I've been doing just that with a backup (rsnapshot) server for
a some time, works just fine.

> I would suggest you buy a meter to measure how much power your storage
> is consuming before you decide on your next action.

In my case the total power consumption went down by over 50%
(the disks stay powered down by about 85% of the time).

> On Mon, Sep 7, 2009 at 6:48 AM, jahammonds prost<gmitch64@yahoo.com> wrote:
> > I've been becoming interested in the power consumption of the arrays I have on a couple of servers here that are basically used as media servers. Since they're not being used when I'm at work, I was looking at the possibility of spinning the disks down during certain times, and having them either spin up at a set time, or (ideally), when there is disk activity.
> >
> > I can do this on single drives using hdparm -S to set the spindown timeout, and the disks will spin up on activity as needed. Is there something similar I can do with an md array?

I simply do it with every individual disk of the array.

-- 
Tapani Tarvainen
