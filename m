From: David Dillow <dave@thedillows.org>
Subject: Re: RAID extremely slow
Date: Thu, 26 Jul 2012 22:17:10 -0400
Message-ID: <1343355430.29938.6.camel@obelisk.thedillows.org>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
	 <5010A386.4080209@familyross.net>
	 <1343355303.29938.5.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343355303.29938.5.camel@obelisk.thedillows.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kevin Ross <kevin@familyross.net>
Cc: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2012-07-26 at 22:15 -0400, David Dillow wrote:
> If you can, upgrade to the latest 3.4 stable kernel (3.4.6 right now).
> As far as I can see, the latest 3.2 stable does not contain the delayed
> stripe fix.

And I was looking at the wrong version; 3.2.24 does indeed have the fix.
