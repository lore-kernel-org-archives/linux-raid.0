From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm --grow failed
Date: Sat, 17 Feb 2007 16:30:21 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702171630140.612@p34.internal.lan>
References: <20070217030514.M74974@liquid-nexus.net> <45D7490E.6080309@tmr.com>
 <Pine.LNX.4.64.0702171415500.29573@p34.internal.lan> <17879.28386.46081.159672@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17879.28386.46081.159672@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Marc Marais <marcm@liquid-nexus.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 18 Feb 2007, Neil Brown wrote:

> On Saturday February 17, jpiszcz@lucidpixels.com wrote:
>>
>> Is growing an array with > 1 disk at a time permissible?  I've grown a
>> raid 5 from 1.8tb to 3.3tb but always 1 disk at a time.
>
> Sure is.  >0 is the current requirement.
> You can grow a 2 drive raid5 directly to a 10drive if you like.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Wow! Thanks for the info, was not aware of this.
