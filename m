From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid and power off savety
Date: Wed, 23 Mar 2005 21:26:16 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0503232114410.28150@lion.drogon.net>
References: <76592C4D3DA1AC4FB8424084D10D31A806115268@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <76592C4D3DA1AC4FB8424084D10D31A806115268@mchh2c4e.mchh.siemens.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Mar 2005, Schuett Thomas EXT wrote:

> Hello,
>
> I am sorry for having to ask a question you might rate very stupid,
> but I really want to know it:
>
> If you think through system crash scenarios, what types of chrashes
> are you are thinking of? Do you only consider harddisk faults, or
> do you consider power failures as well?

I consider power failures too. In theory, you really ought to have UPS
systems, *and* have them connected to the server(s) so they can monitor it
and graceful shutdown, but with the best will in the world this isn't
always possible.

Tonight, I've had a Linux based router power cycled 3 times in a
thunderstorm )-:

reboot   system boot  2.4.23           Wed Mar 23 20:23          (00:59)
reboot   system boot  2.4.23           Wed Mar 23 20:02          (01:20)
reboot   system boot  2.4.23           Wed Mar 23 19:57          (01:25)


It's located in a open-sided barn in a farm the middle of no-where (part
of a community WiFi broadband network) It has 2 x 80GB drives (it runs a
squid cache amongst other stuff) which are all RAID-1 partitions. (and
ext3)

I used to have a UPS on it, but that fried over a year ago in another
thunderstorm. Since then we've not had the money to buy a new one to
replace it, so we've just suffered the odd outage and hoped for the best.

> Or more extreme: Does RAID gives you savety on HD HW failures, but may
> make things worse for power failures (hard power switch off)?

So-far, I've not had a problem with a hard power off - on this or other
routers in this network, or on other servers I have with s/w RAID. I'm not
saying I'll never have a problem, but maybe so-far I've just been lucky.

Gordon
