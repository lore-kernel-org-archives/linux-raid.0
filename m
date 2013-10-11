From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 11:53:40 +0200
Message-ID: <CAPbD+RfCuYPYy3sx+USxTcN3iApfO9ibu+0aq=9B3gU_H3sZyw@mail.gmail.com>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
	<alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
	<CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
	<5257A333.2010809@websitemanagers.com.au>
	<5257C566.6040208@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5257C566.6040208@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46or a personnal use, the issue is often in the number of drive you ca=
n
have with your tower/motherboard, more than really the price of hard
drives themselves.

gUI

2013/10/11 David Brown <david.brown@hesbynett.no>:
> On 11/10/13 09:05, Adam Goryachev wrote:
>> On 11/10/13 17:52, Guillaume Betous wrote:
>>>> RAID6, preferrably with a spare.
>>> I'm not comfortable with RAID 6 setup. What is the minimal number o=
f
>>> hard drives for having a RAID 6 + spare ?
>>>
>>
>> Check wikipedia, but minimum of 4 drives for RAID6, consider 2 data
>> drives plus two redundant drives, allowing you to lose any two drive=
s
>> (slightly better than RAID10 on 4 drives).
>>
>> In direct answer, RAID6 + hot spare is a minimum of 5 drives.
>>
>
> That's just the /sensible/ answer.  The minimum is actually 4 drives =
-
> one data, two redundant, and one spare (though obviously there are
> better ways to use your drives).  And with mdadm, you can tell it tha=
t
> three of these drives are missing.  While such things might seem a bi=
t
> silly, it is sometimes convenient to get your raid up and running wit=
h
> the setup you want even if you haven't physically got the drives in
> place yet - you can add them in later.
>
>



--=20
Pour la sant=E9 de votre ordinateur, pr=E9f=E9rez les logiciels libres.
Lire son mail : http://www.mozilla-europe.org/fr/products/thunderbird/
Browser le web : http://www.mozilla-europe.org/fr/products/firefox/
Suite bureautique : http://www.libreoffice.org/download/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
