From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: checkarray script
Date: Thu, 2 Aug 2007 10:33:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708021033180.16248@p34.internal.lan>
References: <Pine.LNX.4.64.0708020832050.25624@yerot.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708020832050.25624@yerot.com>
Sender: linux-raid-owner@vger.kernel.org
To: ymerej@yerot.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

# dpkg -L mdadm|grep check
/etc/logcheck
/etc/logcheck/ignore.d.server
/etc/logcheck/ignore.d.server/mdadm
/etc/logcheck/violations.d
/etc/logcheck/violations.d/mdadm
/usr/share/mdadm/checkarray
/usr/share/doc/mdadm/README.checkarray


On Thu, 2 Aug 2007, ymerej@yerot.com wrote:

> Does anyone know where I can get this script?  I see posts about it on 
> google, but everyone speeks as if it is included in 2.5+ versions of mdadm. 
> I've downloaded all versions up to 2.6 from 
> http://www.cse.unsw.edu.au/~neilb/source/mdadm/
> but can't locate the checkarray script...
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
