From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 11:10:15 -0500
Message-ID: <4D5E99E7.90909@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5BD678.2050200@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org>	<AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>	<4D5E7123.5020103@turmel.org> <AANLkTi=Yn4wWzRR2huY0asTHB8brcgF8PCkpvtrqmQBK@mail.gmail.com> <4D5E7556.803@turmel.org> <4D5E7E52.30509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5E7E52.30509@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/18/2011 09:12 AM, Simon McNair wrote:
> Phil,
> Tell me what you want me to do and I'm game for it.  When I bought it the reviews were not all that promising (http://www.google.co.uk/products/catalog?hl=&q=AOC-SASLP-MV8&cid=15596376504116122379&os=reviews) but I figure getting up and running is more important than sata speed at the moment.

I perused the cards reviewed here:

http://blog.zorinaq.com/?e=10

I was aiming for the ~$100 mark, for personal use.  I'd have chosen the one of LSI 1068E units, but the cheaper ones are reversed boards (parts on opposite side of normal).  The Marvell 6480 was apparently the next best deal.  I may have to rethink that.

In any case, some benchmarking options:

1) Spot check with "hdparm -t /dev/sd?".  Not considered very accurate.  It's read-only, though, so can run in parallel with other device activity (w/ corresponding reduced accuracy).

2) Run a packaged set of benchmarks:
	http://www.coker.com.au/bonnie++/
	http://www.iozone.org/
	http://dbench.samba.org/

3) Script a series of basic tests of various tasks:
	https://raid.wiki.kernel.org/index.php/Home_grown_testing_methods

Most of these tests require a writable filesystem on the target device to work in.

Phil
