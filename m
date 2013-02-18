From: sk <sdk0084@yahoo.com>
Subject: Re: problems formatting raid5
Date: Mon, 18 Feb 2013 02:44:50 -0800 (PST)
Message-ID: <1361184290.49903.YahooMailNeo@web163001.mail.bf1.yahoo.com>
References: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com> <alpine.DEB.2.00.1302180915080.32644@uplift.swm.pp.se> <1361176372.31472.YahooMailNeo@web163005.mail.bf1.yahoo.com> <alpine.DEB.2.00.1302181045330.32644@uplift.swm.pp.se>
Reply-To: sk <sdk0084@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302181045330.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have tried xfs as well and it was ok. However, later it hangs several=
 times while transferring files and the only way to stop the transfer w=
as rebooting.


=A0Original Message -----

=46rom: Mikael Abrahamsson <swmike@swm.pp.se>
To: sk <sdk0084@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Sent: Monday, February 18, 2013 12:46 PM
Subject: Re: problems formatting raid5

On Mon, 18 Feb 2013, sk wrote:

> i wait about 10 hours
> and start after the resync process completed. it was not mount so i d=
on't think there were any activity.

Well, then output from iostat -x 5 during the creation would be of inte=
rest. Also, try other filesystems such as xfs and see if that behaves d=
ifferently.

-- Mikael Abrahamsson=A0 =A0 email: swmike@swm.pp.se

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
