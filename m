From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: RAID tuning?
Date: Wed, 14 Jun 2006 17:35:56 +0200
Message-ID: <62b0912f0606140835t518f6590v7d4ef11039284d28@mail.gmail.com>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
	 <17550.2944.728044.154492@cse.unsw.edu.au>
	 <448E127F.5010708@comcast.net>
	 <Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>
	 <Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>
	 <Pine.LNX.4.56.0606131124160.27931@lion.drogon.net>
	 <448EFCA7.6050603@comcast.net>
	 <Pine.LNX.4.56.0606132229110.17860@lion.drogon.net>
	 <87zmgfn562.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zmgfn562.fsf@hades.wkstn.nix>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix wrote:
> Adam Talbot wrote:
> > Can any one give me more info on this error?
> > Pulled from /var/log/messages.
> > "raid6: read error corrected!!"
>
> The message is pretty easy to figure out and the code (in
> drivers/md/raid6main.c) is clear enough.

But the message could be clearer, for instance it would be a very good
service to the user if the message showed which block had been
corrected.

Also using two !! in place of one ! makes the message seem a little dumb :-).
