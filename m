From: Asdo <asdo@shiftmail.org>
Subject: Re: ANNOUNCE: mdadm 3.1.2 - A tool for managing Soft RAID under Linux
Date: Thu, 11 Mar 2010 12:25:22 +0100
Message-ID: <4B98D322.7010101@shiftmail.org>
References: <19351.10758.612499.310262@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <19351.10758.612499.310262@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> I am pleased to announce the availability of
>    mdadm version 3.1.2
>
> [CUT]
>
> Significant changes are:
>   - The default metadata has change again (sorry about that).
>     It is now v1.2 and will hopefully stay that way. 
> [CUT]
>   
I remember some discussion about alignment for 1.1 and 1.2: is it 
possible on 1.2 to guarantee alignment of RAID device on the physical 
devices?
4K alignment would be needed on SSDs and 2TB disks w/ 4k physical 512b 
logical emulation. Actually on SSDs the alignment could be even more 
than 4k, I am not sure.
Should we bypass the defaults and put 1.0 metadata on those?
What was the downside of 1.0 so that it was not made default?

Thanks for your great job
