From: Richard Hirst <rhirst@linuxcare.com>
Subject: Re: making new device names with mknod
Date: Tue, 10 Sep 2002 21:56:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020910205629.GJ21440@sleepie.demon.co.uk>
References: <3D7E6020.8030402@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D7E6020.8030402@ratnet.stw.uni-erlangen.de>
To: schmidt@naa.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 10, 2002 at 11:12:00PM +0200, Norman Schmidt wrote:
> Hi!
> 
> Can somebody tell me how to make new device names in /dev?
> I have installed two additional ide controllers and want to make md
> devices out of partitions on devices /dev/hde, /dev/hdg, /dev/hdi and
> /dev/hdk. In /dev, there are only devices up to hdh. In addition to
> that, I would need to make the /dev entries for the partitions.
> 
> Is it possible to use more than 16 md devices, how can I make /dev/md16
> and so on?
> 
> I am using Debian Woody, so no makedev, only mknod is available.

Should be there as /dev/MAKEDEV

cd /dev
./MAKEDEV hdi


> I hope, I am not too off-topic, thanks, Norman.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
