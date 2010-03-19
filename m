From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: RAID Class Drives`
Date: Fri, 19 Mar 2010 12:43:15 -0400
Message-ID: <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
	 <4BA258AD.5020605@gmx.net> <4BA33284.7000304@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA33284.7000304@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Joachim Otahal <Jou@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 19, 2010 at 4:15 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> Do you have a reference for this? Most drives' operating temperature =
range
> is specified up to 55=C2=B0C, sometimes higher for enterprise drives,=
 without any
> indication (apart from common sense perhaps) that running them this h=
ot
> reduces lifespan.

Google's study of >100,000 disks over 9 months or so
<http://labs.google.com/papers/disk_failures.html> suggests that
hotter drives don't fail much more often:

". . . failures do not increase when the average temperature
increases. In fact, there is a clear trend showing that lower
temperatures are associated with higher failure rates.  Only at very
high temperatures is there a slight reversal of this trend." (page 5
of PDF)

"We can conclude that at moderate temperature ranges it is likely that
there are other effects which affect failure rates much more strongly
than temperatures do." (page 6)

They were using SATA and PATA consumer drives, 5400 RPM to 7200 RPM,
80 to 400 GB, put into production in or after 2001 (from page 3).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
