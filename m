From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Sun, 1 Oct 2017 07:32:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se> <874ls0s7un.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874ls0s7un.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Sep 2017, NeilBrown wrote:

> Anyway, thanks for the example of a real problem related to this.  It 
> does make it easier to think about.

Btw, if someone does --zero-superblock or dd /dev/zero to to a component 
device that is active, what happens when mdadm --stop /dev/mdX is run? 
Does it write out the complete superblock again?

If not, would that be hard to do?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
