From: Asdo <asdo@shiftmail.org>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Fri, 06 Nov 2009 11:28:58 +0100
Message-ID: <4AF3FA6A.4020305@shiftmail.org>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>	<19177.14609.138378.581065@notabene.brown>	<4AE94D95.4060303@shiftmail.org>	<66781b10910310351x7bb721c4mfba765fe9789cd7b@mail.gmail.com>	<19183.47226.529417.743975@notabene.brown>	<66781b10911030411y5bb32610lec72966f7cc09df@mail.gmail.com>	<66781b10911040915t11a7f0c2td6a9ed5672935efb@mail.gmail.com>	<4AF1B924.1060605@shiftmail.org>	<66781b10911050904m407d14d6t7d3bec12578d6500@mail.gmail.com>	<4AF322F6.3020802@shiftmail.org> <19187.43892.446870.865231@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19187.43892.446870.865231@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>
Cc: mark delfman <markdelfman@googlemail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 5, asdo@shiftmail.org wrote:
>   
>> incentive for upgrading (Neil, btw, is there any chance those lockups 
>> fixes get backported to mainstream 2.6.31.x?).    
>
> That would be up to the XFS developers.  I suggest you consider asking
> them.
>   
Hi Neil, no sorry I meant the patches for md raid lockups like this one:
http://neil.brown.name/git?p=md;a=commitdiff;h=1d9d52416c0445019ccc1f0fddb9a227456eb61b
and those for raid 5,6 for which i don't know the link...
Hm actually I don't see them applied to even mainstream 2.6.32 yet :-(
http://git.kernel.org/?p=linux/kernel/git/djbw/md.git;a=blob_plain;f=drivers/md/raid1.c;hb=2fdc246aaf9a7fa088451ad2a72e9119b5f7f029
am I correct?
The bug can be serious imho depending on the hardware: when I saw it on 
my hardware all disk accesses were completely starved forever and it was 
even impossible to log-in until the resync finished. It can actually be 
worked around by reducing the maximum resync speed, but this is only if 
the user knows the trick...
Thank you
