From: Neil Brown <neilb@suse.de>
Subject: Re: read errors corrected
Date: Fri, 31 Dec 2010 13:08:07 +1100
Message-ID: <20101231130807.7567c09d@notabene.brown>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
	<20101230201501.2f39a85f@notabene.brown>
	<AANLkTik2+Gk1XveqD=crGMH5JshzJqQb_i77ZpOFUncB@mail.gmail.com>
	<AANLkTi=vBWKjQStwpWZ3b=YL93LTDBfGk7b5jKUHLcO7@mail.gmail.com>
	<20101231101243.666e0f9e@notabene.brown>
	<AANLkTimhWHfcnDH4Zy6=VGX17_JAH0ON3OMuPhA4oBjf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimhWHfcnDH4Zy6=VGX17_JAH0ON3OMuPhA4oBjf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James <jtp@nc.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 31 Dec 2010 01:48:07 +0000 James <jtp@nc.rr.com> wrote:

> Neil,
> 
> I'm runinng 2.6.35.
> 
> Although an expensive route, the only thing I can think to do to
> determine 100% whether the issue is software or hardware (and, if
> hardware, whether SATA controller or the drives) is to swap the drives
> out.
> 
> Ouch!
> 
> Any other ideas, however, would be appreciated before I drop a few
> hundred bucks. :)

Buy a PCIe SATA controller, plug it in and move some/all drives over to that?
Should be a lot less than $100.  Make sure it is a different chipset to what
you have on your motherboard.

NeilBrown
