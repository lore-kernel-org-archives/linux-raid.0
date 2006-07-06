From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Strange intermittant errors + RAID doesn't fail the disk.
Date: Thu, 6 Jul 2006 15:01:47 +0200
Message-ID: <bb145bd20607060601x33519be7tb4c4812ab54cc7c@mail.gmail.com>
References: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
	 <17573.52096.655463.808666@cse.unsw.edu.au>
	 <bb145bd20606302313x557f94d8xd69cce83731e2a4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20606302313x557f94d8xd69cce83731e2a4b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I suggest you find a SATA related mailing list to post this to (Look
> > in the MAINTAINERS file maybe) or post it to linux-kernel.

linux-ide couldn't help much, aside from recommending a bleeding-edge
patchset which should fix a lot of things SATA:
http://home-tj.org/files/libata-tj-stable/

What fixed the error, though, was exchanging one of the cables. (Just
my luck, it was new and supposedly quality, ... oh well)

I'm still interested in why the md code didn't fail the disk. While it
was 'up' any access to the array would hang for a long time,
ultimately fail and corrupt the fs to boot. When I failed the disk
manually everything was fine (if degraded) again.

Regards,

C.
