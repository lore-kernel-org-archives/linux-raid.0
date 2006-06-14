From: Adam Talbot <talbotx@comcast.net>
Subject: Re: Disks keep failing durning testing
Date: Wed, 14 Jun 2006 16:23:40 -0700
Message-ID: <44909A7C.7020006@comcast.net>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com> <17550.2944.728044.154492@cse.unsw.edu.au> <448E127F.5010708@comcast.net> <Pine.LNX.4.56.0606130906370.27931@lion.drogon.net> <Pine.LNX.4.64.0606130620410.8834@p34.internal.lan> <Pine.LNX.4.56.0606131124160.27931@lion.drogon.net> <448EFCA7.6050603@comcast.net> <Pine.LNX.4.56.0606132229110.17860@lion.drogon.net> <87zmgfn562.fsf@hades.wkstn.nix> <449073AD.3000809@comcast.net> <op.ta5n1jz0cigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.ta5n1jz0cigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: Nix <nix@esperi.org.uk>, Gordon Henderson <gordon@drogon.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wow... My greatest thanks... That is one heck of a bug. 
Any clue how to reset my SMART logs to 0 errors?
PFC wrote:
>
>> 6X MaxLine 300GB SATAII 7200RPM Hard drive.
>
>     Flip the jumper on the drive to set it to SATA1 (1.5 Gbps) instead
> of SATA2.
>     On my PC Maxtor drives kept failing until I did this, not a
> problem since.
>
>     Of course YMMV.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

