From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Tue, 30 Oct 2007 00:19:37 -0500
Message-ID: <1193721577.3876.12.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tzoc7soa.fsf@willow.rfc1149.net>
Sender: linux-raid-owner@vger.kernel.org
To: Samuel Tardieu <sam@rfc1149.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2007-10-27 at 12:33 +0200, Samuel Tardieu wrote:
> I agree with Doug: nothing prevents you from using md above very slow
> drivers (such as remote disks or even a filesystem implemented over a
> tape device to make it extreme). Only the low-level drivers know when
> it is appropriate to timeout or fail.
> 
>   Sam

The problem is when some of these drivers are just not smart
enough to keep themselves out of trouble. Unfortunately I've
been bitten by apparently too many of them.

I'll repeat my plea one more time. Is there a published list
of tested combinations that respond well to hardware failures
and fully signals the md code so that nothing hangs?

If not, I would like to see what people that have experienced
hardware failures and survived them are using so that such
a list can be compiled.

Alberto


