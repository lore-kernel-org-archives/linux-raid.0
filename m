From: Gordon Henderson <gordon@drogon.net>
Subject: Re: ext3 ..
Date: Mon, 3 Jan 2005 20:05:02 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501031951470.16453@lion.drogon.net>
References: <200501031734.j03HYO914483@www.watkins-home.com>
 <Pine.LNX.4.56.0501031754180.16453@lion.drogon.net>
 <20050103203803.K27797@arsenium.medical-insight.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050103203803.K27797@arsenium.medical-insight.com>
Sender: linux-raid-owner@vger.kernel.org
To: Morten Sylvest Olsen <mso@medical-insight.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 3 Jan 2005, Morten Sylvest Olsen wrote:

> > So to the upper layers, ext3, userland, etc. that should look like a
> > catastrophic hardware failure -- anything trying to read/write to it
> > should (IMO) have simply returned with IO errors.
>
> That depends on the options when the filesystem was mounted. Or the
> options set in the superblock. The choices are continue, remount
> read-only or panic.

however - on the system in question:

  xena:/home/gordonh# dumpe2fs -h /dev/md5
  ...
  Errors behavior:          Continue
  ...

and there are no mount options to say otherwise.

There are lots of ext3 whinges in the log-file so I guess it just got
fed-up... And this really isn't a linux-raid issue, just something I
noticed recently to do with ext3...

I did try XFS a while back, but had more problems with it and no
satisfactory answers, so gave up on it... The trouble is, you get too used
to what works and tend to stick with it...

Ah well.

Gordon
