From: "Martin Eriksson" <nitrax@giron.wox.org>
Subject: Re: Enable HTT with dual xeon fileserver ?
Date: Thu, 19 Sep 2002 01:43:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001a01c25f6d$270813f0$900d0d93@M02WS17219>
References: <Pine.LNX.4.44.0209182006030.6591-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: raid@ddx.a2000.nu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
From: <raid@ddx.a2000.nu>
To: "Martin Eriksson" <nitrax@giron.wox.org>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, September 18, 2002 8:08 PM
Subject: Re: Enable HTT with dual xeon fileserver ?


> On Wed, 18 Sep 2002, Martin Eriksson wrote:
> > ----- Original Message -----
> > From: <raid@ddx.a2000.nu>
> > To: <linux-raid@vger.kernel.org>
> > Sent: Monday, September 16, 2002 11:02 PM
> > Subject: Enable HTT with dual xeon fileserver ?
> >
> > > I'm building a Dual Xeon Fileserver
> > > i can enable HTT in the bios (so i have 4 logical processors)
> >
> > I'm very sceptical that a fileserver would gain any performance from HT.
> don't know, just wondering
> maybe samba/nfs can use htt/dual cpu ?


Yes, theoretically. Your "problem" is still that all your disk arrays and
especially network, are slower than *one* of your CPUs. Well that isn't
really a problem, you propably have a kick*ss server in any case.

> > In fact, I don't really realize why you even need two CPU's? If you are
> i also don't think i really need 2 cpu's
> but i bought the second one, because it was just a bit more (compared to
> the whole price of the machine)

Ok, that's reasonable.

/Martin

