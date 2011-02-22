From: NeilBrown <neilb@suse.de>
Subject: Re: SSD - TRIM command
Date: Tue, 22 Feb 2011 14:45:40 +1100
Message-ID: <20110222144540.7cd53e7d@notabene.brown>
References: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
	<4D62CF5F.6080007@cfl.rr.com>
	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
	<AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
	<AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>
	<AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
	<20110222003610.GB29101@bounceswoosh.org>
	<AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>
	<AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com>
	<AANLkTim_F1wqvLprPvytVAMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
	<alpine.DEB.1.10.1102220300400.11974@uplift.swm.pp.se>
	<FA27C2E0242645B795811DDF282BFA05@m5>
	<AANLkTi=910JELnSik=pGiN9Yz0YVUNLyWCmJSiFZotSM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=910JELnSik=pGiN9Yz0YVUNLyWCmJSiFZotSM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Guy Watkins <linux-raid@watkins-home.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Feb 2011 23:27:26 -0300 Roberto Spadim <roberto@spadim.com.br>
wrote:

> tape drive = harddisk with only one head, the head can't move, only
> the tape (disk/plate or any other name you want)
> 
> could we get back and answer the main question?
> --------------------------
> getting back to the first question, can MD support trim? yes/no/not
> now/some levels and layouts only?
> 

MD currently doesn't accept 'discard' requests.

RAID0 and LINEAR could be made to accept 'discard' if any
member device accepted 'discard'.  Patches welcome.

Other levels need md to know not to try to resync/recover regions that
have been discarded.  See "non-sync bitmap" section of the recent
md roadmap.

NeilBrown
