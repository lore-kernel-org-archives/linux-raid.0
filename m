From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Hardware assisted parity computation - is it now worth it?
Date: Thu, 13 Jul 2006 11:13:07 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0607131109440.6667@lion.drogon.net>
References: <1152778739.26511.65.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1152778739.26511.65.camel@swtf.comptex.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Burn Alting <burn@goldweb.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Jul 2006, Burn Alting wrote:

> Last year, there were discussions on this list about the possible
> use of a 'co-processor' (Intel's IOP333) to compute raid 5/6's
> parity data.
>
> We are about to see low cost, multi core cpu chips with very
> high speed memory bandwidth. In light of this, is there any
> effective benefit to such devices as the IOP333?
>
> Or in other words, is a cheaper (power, heat, etc) cpu with
> higher memory access speeds, more cost effective than a
> bridge/bus device (ie hardware) solution (which typically
> has much lower memory access speeds)?

Something else to ponder: Is it worth it in terms of extra hardware
complexity, and additional software to drive it vs. the marginal increase
in speed it might give, when 99.9% of the time you are going to be
waiting on the external disk reading or writing the data compared to the
time it takes to generate the parity?

Personally, I'd opt for hardware simplicity over a marginal speed increase
anyday... However with todays energy prices on the increase, then it might
be something to consider, if it was going to give a significn power
savings, even so I'm not sure...

Gordon
