From: Tyler <pml@dtbb.net>
Subject: Re: confused raid1
Date: Mon, 15 Aug 2005 11:56:21 -0700
Message-ID: <4300E555.5090804@dtbb.net>
References: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org> <4300BC7E.6030009@dtbb.net> <Pine.LNX.4.61.0508151202160.10349@soloth.lewis.org> <4300C5D6.3090706@dtbb.net> <Pine.LNX.4.61.0508151326210.10349@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508151326210.10349@soloth.lewis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, i guess you won't know if you don't try.

Do your other servers pronounce the same "error" in their logs upon 
bootup? regarding the module?

Tyler.

Jon Lewis wrote:

> On Mon, 15 Aug 2005, Tyler wrote:
>
>> Try this suggestion (regarding modules.conf).
>>
>> https://www.redhat.com/archives/fedora-list/2003-December/msg05205.html
>
>
> I don't see why that modules.conf addition would be necessary / make a 
> difference.  I have other servers with root-raid1 that haven't needed 
> that, and mkinitrd is smart enough (reads /etc/raidtab) to know that 
> raid1 is needed and loads the raid1 module in the initrd linuxrc script.
>
> ----------------------------------------------------------------------
>  Jon Lewis                   |  I route
>  Senior Network Engineer     |  therefore you are
>  Atlantic Net                | _________ 
> http://www.lewis.org/~jlewis/pgp for PGP public key_________
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.338 / Virus Database: 267.10.9/72 - Release Date: 8/14/2005

