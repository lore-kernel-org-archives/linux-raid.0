From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 14:42:35 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0608241438360.6721@lion.drogon.net>
References: <20060824090741.J30362@mail.kroptech.com>
 <1156425650.3007.140.camel@localhost.localdomain> <20060824093616.K30362@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060824093616.K30362@mail.kroptech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 24 Aug 2006, Adam Kropelin wrote:

> > Generally speaking the channels on onboard ATA are independant with any
> > vaguely modern card.
>
> Ahh, I did not know that. Does this apply to master/slave connections on
> the same PATA cable as well? I know zero about PATA, but I assumed from
> the terminology that master and slave needed to cooperate rather closely.

I don't know much about co-operation between master & slave, but I do know
that a failing PATA IDE drive can take out the other one on the same bus -
or in my case, render it unusable until I removed the dead drive,
whereupon (to my relief) it sprang back into life.

This was many many moons ago before I started to use s/w RAID, but it's
one thing that would kill a multi-disk array, so I've never done it since.

I guess the same could happen on SCSI, but I suspect the interface is a
little better designed...

Gordon
