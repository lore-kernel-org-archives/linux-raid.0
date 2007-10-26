From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Software RAID when it works and when it doesn't
Date: Fri, 26 Oct 2007 12:09:13 -0500
Message-ID: <1193418553.4771.13.camel@w100>
References: <14526.1192571833@mdt.ecitele.com>
	 <87bqaw5tqb.fsf@informatik.uni-tuebingen.de>
	 <1192777672.16416.495.camel@w100> <471E79A5.5020607@tmr.com>
	 <1193205003.23414.72.camel@w100> <471FA543.9090502@tmr.com>
	 <87fxzxzwga.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fxzxzwga.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-10-26 at 18:12 +0200, Goswin von Brederlow wrote:

> Depending on the hardware you can still access a different disk while
> another one is reseting. But since there is no timeout in md it won't
> try to use any other disk while one is stuck.
> 
> That is exactly what I miss.
> 
> MfG
>         Goswin
> -

That is exactly what I've been talking about. Can md implement
timeouts and not just leave it to the drivers?

I can't believe it but last night another array hit the dust when
1 of the 12 drives went bad. This year is just a nightmare for
me. It brought all the network down until I was able to mark it
failed and reboot to remove it from the array.

Alberto

