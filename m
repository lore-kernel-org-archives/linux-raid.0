From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: MD bug or me being stupid?
Date: Sun, 15 May 2005 20:10:00 +0200
Message-ID: <62b0912f05051511107a0c4e0@mail.gmail.com>
References: <62b0912f0504220345349335f9@mail.gmail.com>
	 <62b0912f050512015585a6ba5@mail.gmail.com>
	 <17028.5921.815691.401690@cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17028.5921.815691.401690@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Molle Bestefich wrote:
> > Ping!...
> > Neil, just wondering, any comments regarding this particular endless loop in MD?
> > (Anything I can test or some such?)
> 
> Thanks for the ping, things sometimes get lost in the noise....

Thanks for taking a look at it!

> This sounds a bit like the problem that is addressed by
>   md-make-raid5-and-raid6-robust-against-failure-during-recovery.patch
> in the current -mm patches (look in the brokenout directory).
> 
> This would only happen if you have multiple failed devices.  So maybe
> while the rebuild was happening, another device failed (which seems to
> happen more and more as device sizes are increasing and reliability is
> going the other way).
> 
> Could this (another drive failure) be the case?

Sounds correct!
There was both a real disk failure and a cable failure involved (first
message in this thread has details).

Apologies for bringing up already fixed bugs.
