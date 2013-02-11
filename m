From: John Spencer <maillist-mdadm@barfooze.de>
Subject: Re: [PATCH] mdadm: fix portability issues encountered while building
 against musl libc
Date: Mon, 11 Feb 2013 20:34:59 +0100
Message-ID: <511947E3.9040400@barfooze.de>
References: <5116D8A7.6070409@barfooze.de> <20130210154548.0ad0c36d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130210154548.0ad0c36d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/10/2013 05:45 AM, NeilBrown wrote:
>
> Hi,
>   I've applied this one and the GCC #ifdef - thanks.

thanks!

>
>   I haven't applied the last one, but not because I don't appreciate being
>   called insane :-)

he he :)

>
>   I like having -Werror as it encourages people to report any warnings they
>   get, and it keeps me "honest".

well, i dont think anyone except of the author(s) wants that flag 
activated by default so that they can find warnings without looking to 
closely.

>   If it is a problem for you, you can easily
>     make CWFLAGS=

i know, but "broken-by-default" is not a very friendly setting.
there are quite a couple of warnings GCC emits that are simply bogus.
i'd rather if the one that actually wants this hardcore setting uses 
make CWFLAGS=-Werror (or make FATAL=1) instead of forcing his policy on 
all users.

>
>   or set the C Warning FLAGS to whatever you like - they are deliberately kept
>   separate from other CFLAGS.
>
> Thanks,
> NeilBrown


thanks,
--JS
