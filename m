From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape
Date: Fri, 16 Jun 2006 18:39:10 -0400
Message-ID: <4493330E.30501@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net> <17555.12441.42212.93049@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17555.12441.42212.93049@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tim T <irule@irule.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday June 16, irule@irule.net wrote:
>   
>> You have to grow the ext3 fs separately. ext2resize /dev/mdX. Keep in 
>> mind this can only be done off-line.
>>
>>     
>
> ext3 can be resized online. I think ext2resize in the latest release
> will "do the right thing" whether it is online or not.
>
> There is a limit to the amount of expansion that can be achieved
> on-line.  This limit is set when making the filesystem.  Depending on
> which version of ext2-utils you used to make the filesystem, it may or
> may not already be prepared for substantial expansion.
>
> So if you want to do it on-line, give it a try.... or ask on the
> ext3-users list for particular details on what versions you need and
> how to see if your fs can be expanded.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
Thanks for all the advice. One final question, what kernel and mdadm 
versions do I need?

Nigel
