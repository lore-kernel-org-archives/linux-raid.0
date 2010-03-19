From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: RAID Class Drives`
Date: Fri, 19 Mar 2010 17:53:25 +0100 (MET)
Message-ID: <Pine.GSO.4.64.1003191747300.15546@montezuma.acc.umu.se>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
 <4BA258AD.5020605@gmx.net> <4BA33284.7000304@anonymous.org.uk>
 <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Gregor <Simetrical+list@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Joachim Otahal <Jou@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Mar 2010, Aryeh Gregor wrote:

> On Fri, Mar 19, 2010 at 4:15 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> Do you have a reference for this? Most drives' operating temperature=
 range
>> is specified up to 55=B0C, sometimes higher for enterprise drives, w=
ithout any
>> indication (apart from common sense perhaps) that running them this =
hot
>> reduces lifespan.
>
> Google's study of >100,000 disks over 9 months or so
> <http://labs.google.com/papers/disk_failures.html> suggests that
> hotter drives don't fail much more often:
>
> ". . . failures do not increase when the average temperature
> increases. In fact, there is a clear trend showing that lower
> temperatures are associated with higher failure rates.  Only at very
> high temperatures is there a slight reversal of this trend." (page 5
> of PDF)

Do check out figure 5 though, I wouldn't run the drives hotter than=20
40-45=B0C based on that which does seem to indicate that hot drives don=
't=20
last as long. But then again, so would running them at <30=B0C...

/Mattias Wadenstein
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
