From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 00:35:20 +0100
Message-ID: <20110201233520.GB26817@www2.open-std.org>
References: <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com> <4D4883A3.6030605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4883A3.6030605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 01, 2011 at 04:05:23PM -0600, Stan Hoeppner wrote:
> Jon Nelson put forth on 2/1/2011 7:50 AM:
> 
> > The performance will not be the same because. Whenever possible, md
> > reads from the outermost portion of the disk -- theoretically the
> > fastest portion of the disk (by 2 or 3 times as much as the inner
> > tracks) -- and in this way raid10,f2 can actually be faster than
> > raid0.
> 
> Faster in what regard?  I assume you mean purely sequential read, and not random
> IOPS.  The access patterns of the vast majority of workloads are random, so I
> don't see much real world benefit, if what you say is correct.  This might
> benefit MythTV or similar niche streaming apps.

It is mostly interesting for workstations, where one user is the sole
user of the system

But it is also interesting for a server, where the client is interested
in the completion time for a single request. The faster processing of 
a sequential reads is significant, as far as I can tell.

Best regards
keld
