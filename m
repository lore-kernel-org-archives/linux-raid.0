From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 16:24:59 -0500
Message-ID: <1194038699.11827.42.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
	 <1193893689.3649.19.camel@w100>
	 <1193944573.10336.684.camel@firewall.xsintricity.com>
	 <1193992909.3649.75.camel@w100>
	 <1194018326.25553.28.camel@firewall.xsintricity.com>
	 <1194027687.11827.32.camel@w100>
	 <1194030932.25553.49.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194030932.25553.49.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-11-02 at 15:15 -0400, Doug Ledford wrote:
> It was tested, it simply obviously had a bug you hit.  Assuming that
> your particular failure situation is the only possible outcome for all
> the other people that used it would be an invalid assumption.  There are
> lots of code paths in an error handler routine, and lots of different
> hardware failure scenarios, and they each have their own independent
> outcome should they ever be experienced.

This is the kind of statement why I said you were belittling my 
experiences. 

And to think that since I've hit it in three different machines with
different hardware and different kernel versions that it won't affect
others is something else. I thought I was helping, but don't worry I
learned my lesson, it won't happen again. I asked people for their
experiences, clearly not everybody is as lucky as I am.

> Then you didn't pay attention to what I said before: RHEL3 was the first
> ever RHEL product that had support for SATA hardware.  The SATA drivers
> in RHEL3 *were* first gen.

Oh, I paid attention alright. It is my fault for assuming that things
not marked as experimental are not experimental.

Alberto

