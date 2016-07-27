From: bobzer <bobzer@gmail.com>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Tue, 26 Jul 2016 22:16:47 -0400
Message-ID: <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
 <22423.44287.974770.114127@tree.ty.sabi.co.uk> <5797C5CE.6020300@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5797C5CE.6020300@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Peter Grandi <pg@lxra2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you very much for your help

I realized that there's much better idea than my first idea....

I can plug all my drives the sata plug are not a problem :-)
I use around 4.5TB on my current raid 5
I will continue to think on this problem and in the meanwhile try to
find another disk

i didn't think about :
> > In general an in-place migration is a very dangerous operation
> > because it stresses existing hardware a lot plus it uses code
> > that is rarely used and is quite complex. Given that your
> > situation is already compromised.
>
> But copying everything off will stress it just as much, surely? The
> alternatives imho are worse ...

at first i thought about using rsync to do my copy (anyway i don't have a GUI)
at second i thought that an in-place migration would be a nice and
safe operation
now i don't what to think ?
the 3  4TB disk are new but the 2  2TB are 4 year old and consumer
grade (the 4TB are seagate NAS HDD)
so i'm asking myself should I do a copy (with rsync or another tool)
or an in-place migration ? which one is the safest ?

thanks again
Cheers,
Math
