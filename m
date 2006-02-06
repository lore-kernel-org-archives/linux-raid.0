From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs running
Date: Mon, 06 Feb 2006 17:35:52 +1300
Message-ID: <43E6D228.2070804@sauce.co.nz>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com> <43E68D62.4080704@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E68D62.4080704@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Liontooth wrote:

> Temperature obviously matters -- a linear approximation might look like
> this,
> 
>      Lifetime = 60 - 12 [(t-40)/2.5]
> 
> where 60 is the average maximum lifetime, achieved at 40 degrees C and
> below, and lifetime decreases by a year for every 2.5 degree rise in
> temperature.  Does anyone have an actual formula?

This paper from Hitachi may be of some use for their drives:

http://www.hgst.com/hdd/technolo/drivetemp/drivetemp.htm

Regards,

Richard
