From: Nic Wolfe <nic@wolfeden.ca>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Wed, 19 Jun 2013 17:52:22 -0600
Message-ID: <CAGjXdAjhv7VdZ_9cL_UuhTUggR1q9fko4ok=eYC8WG3cjVM=Gw@mail.gmail.com>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
	<51B0C769.1070009@turmel.org>
	<CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com>
	<51B1D58A.3010309@turmel.org>
	<CAGjXdAjgRTho6r8EdM04wBNR90uvbt72cWmkNy9_AuEt-qi1hw@mail.gmail.com>
	<51C1FA44.1070306@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51C1FA44.1070306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 19, 2013 at 12:36 PM, Phil Turmel <philip@turmel.org> wrote:

> As noted above, you will not be able to use /dev/sdc with the raid card.
>  You could try leaving it out and taking a backup with the degraded
> array.  That is what I would recommend first.

OK, will do. Simply "mdadm --assemble /dev/md1 /dev/sdb /dev/sdd
/dev/sde /dev/sdf /dev/sdg"?

Thanks so much for all the help so far.

Nic
