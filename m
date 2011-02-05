From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Re: Reshaping RAID-0?
Date: Fri, 4 Feb 2011 18:36:59 -0800
Message-ID: <AANLkTi=14A=eiLSUNQyNWYEZ7SK-c=cDfgh8U8N9bYzN@mail.gmail.com>
References: <AANLkTinWzDmEHYWoqFeEoXqQhutj=kG-tgJd7BqERgNF@mail.gmail.com>
	<4D4C9B8E.4090502@anonymous.org.uk>
	<20110205120118.18072fef@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110205120118.18072fef@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, John and Neil.  I have just a few more questions.

Any chance of this working on 2.6.32?  Specifically, Suse Linux
Enterprise Server 11 SP1?  :-)

I am interested in attempting this "by hand", so...

> =A0- convert the RAID0 to RAID4
> =A0- disable recovery from auto-starting
> =A0- add /dev/newdisc to the array as a spare (but recovery won't sta=
rt)
> =A0- request a size change to one extra disk
> =A0- start the reshape
> =A0- wait for the reshape to complete
> =A0- convert back to RAID0


=2E..could someone flesh out the mdadm and /sys invocations a little
bit?  Even vague pointers would be fine.

To make sure I understand the procedure correctly...  We convert from
RAID0 to (degraded) RAID4, disable recovery, add a new disk as a
spare.  That gives us a degraded RAID 4 with a spare.  So far I get
it.

But why are "request a size change to one extra disk" and "start the
reshape" separate steps?  I assume that "start the reshape" is to take
us to a (larger) degraded RAID 4, but what state are we in after the
"request a size change"?  (Put another way, what is the new disk being
used for, exactly, after the "size change" completes?  How does that
differ from after the "reshape" completes?)

Thanks again.

 - Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
