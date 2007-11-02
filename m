From: David Greaves <david@dgreaves.com>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 11:09:06 +0000
Message-ID: <472B0552.2010608@dgreaves.com>
References: <1193418753.4771.17.camel@w100>	 <1193425254.10336.290.camel@firewall.xsintricity.com>	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>	 <1193765984.10336.519.camel@firewall.xsintricity.com>	 <1193893689.3649.19.camel@w100>	 <1193944573.10336.684.camel@firewall.xsintricity.com> <1193992909.3649.75.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193992909.3649.75.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso wrote:
> On Thu, 2007-11-01 at 15:16 -0400, Doug Ledford wrote:
>> Not in the older kernel versions you were running, no.
> 
> These "old versions" (specially the RHEL) are supposed to be
> the official versions supported by Redhat and the hardware 
> vendors, as they were very specific as to what versions of 
> Linux were supported. Of all people, I would think you would
> appreciate that. Sorry if I sound frustrated and upset, but 
> it is clearly a result of what "supported and tested" really 
> means in this case. I don't want to go into a discussion of
> commercial distros, which are "supported" as this is nor the
> time nor the place but I don't want to open the door to the
> excuse of "its an old kernel", it wasn't when it got installed.

It may be worth noting that the context of this email is the upstream linux-raid
 list. In my time watching the list it is mainly focused on 'current' code and
development (but hugely supportive of older environments).
In general discussions in this context will have a certain mindset - and it's
not going to be the same as that which you'd find in an enterprise product
support list.

> Outside of the rejected suggestion, I just want to figure out 
> when software raid works and when it doesn't. With SATA, my 
> experience is that it doesn't.

SATA, or more precisely, error handling in SATA has recently been significantly
overhauled by Tejun Heo (IIRC). We're talking post 2.6.18 though (again IIRC) -
so as far as SATA EH goes, older kernels bear no relation to the new ones.

And the initial SATA EH code was, of course, beta :)

David
PS I can't really contribute to your list - I'm only using cheap desktop hardware.
