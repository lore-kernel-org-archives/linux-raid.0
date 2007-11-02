From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 03:41:49 -0500
Message-ID: <1193992909.3649.75.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
	 <1193893689.3649.19.camel@w100>
	 <1193944573.10336.684.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193944573.10336.684.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2007-11-01 at 15:16 -0400, Doug Ledford wrote:
> I wasn't belittling them.  I was trying to isolate the likely culprit in
> the situations.  You seem to want the md stack to time things out.  As
> has already been commented by several people, myself included, that's a
> band-aid and not a fix in the right place.  The linux kernel community
> in general is pretty hard lined when it comes to fixing the bug in the
> wrong way.

It did sound as if I was complaining about nothing and that I shouldn't
bother the linux-raid people and instead just continuously update the
kernel and stop raising issues. If I misunderstood you I'm sorry, but
somehow I still think that belittling my problems was implied in your
responses.

> Not in the older kernel versions you were running, no.

These "old versions" (specially the RHEL) are supposed to be
the official versions supported by Redhat and the hardware 
vendors, as they were very specific as to what versions of 
Linux were supported. Of all people, I would think you would
appreciate that. Sorry if I sound frustrated and upset, but 
it is clearly a result of what "supported and tested" really 
means in this case. I don't want to go into a discussion of
commercial distros, which are "supported" as this is nor the
time nor the place but I don't want to open the door to the
excuse of "its an old kernel", it wasn't when it got installed.

> And I guarantee not a single one of those systems even knows what SATA
> is.  They all use tried and true SCSI/FC technology.

Sure, the tru64 units I talked about don't use SATA (although 
some did use PATA) I'll concede to that point.

> In any case, if Neil is so inclined to do so, he can add timeout code
> into the md stack, it's not my decision to make.

The timeout was nothing more than a suggestion based on what
I consider a reasonable expectation of usability. Neil said no
and I respect that. If I didn'tm I could always write my own as
per the open source model :-) But I am not inclined to do so.

Outside of the rejected suggestion, I just want to figure out 
when software raid works and when it doesn't. With SATA, my 
experience is that it doesn't. So far I've only received one 
response stating success (they were using the 3ware and Areca 
product lines).

Anyway, this thread just posed the question, and as Neil pointed
out, it isn't feasible/worth to implement timeouts within the md
code. I think most of the points/discussions raised beyond that
original question really belong to the thread "Software RAID when 
it works and when it doesn't" 

I do appreciate all comments and suggestions and I hope to keep
them coming. I would hope however to hear more about success
stories with specific hardware details. It would be helpfull
to have a list of tested configurations that are known to work.

Alberto

