From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Sat, 16 Aug 2008 09:53:15 +1200
Message-ID: <48A5FACB.2090302@sauce.co.nz>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi> <alpine.DEB.1.10.0808151528090.25378@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0808151528090.25378@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jan Wagner <jwagner@kurp.hut.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:

> Because you are using port-multipliers, they do not allocate full 
> bandwidth to each HDD simultaneously.  You will get a maximum of 3gbps 
> per each port, but if you are reading from 12 ports into a single 3gbps 
> port?

Jan's setup is 3 drives on each port multiplier, which are each attached 
to a port on the controller, so should be just on the limit of the 3Gb/s 
link between controller and multiplier.

According to this, with the same controller and 12 portmultiplied 
Seagate drives on a Mac, in one single RAID 0, you should see just under 
700MB/s peak, so there may be room for improvement yet.

http://www.amug.org/amug-web/html/amug/reviews/articles/addonics/adsa3gpx8-4em/

Regards,

Richard
