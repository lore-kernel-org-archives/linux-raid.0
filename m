From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 10:34:28 +0100
Message-ID: <4m4nb2-20f.ln1@news.it.uc3m.es>
References: <crmt7e$8d6$1@sea.gmane.org> <200501092226.25910.maarten@ultratux.net> <20050109222900.GA12793@janus> <200501100016.58847.maarten@ultratux.net> <20050110081526.GA15920@janus> <41E80188.60601@conterra.de> <41E86018.1070903@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> That all to say: yes indeed, this lack of "smart error handling" is
> a noticieable omission in linux software raid.  There are quite some
> (sometimes fatal to the data) failure scenarios that'd not had happened
> provided the smart error handling where in place.

I also agree that "redundancy per block" is probably a much better idea
than "redundancy per disk". Probably needs a "how hot are you?"
primitive, though!

The read patch I posted should get you over glitches from sporadic read
errors that would otherwise fault the disk, but one wants to add
accunting for such things and watch them.

Peter

