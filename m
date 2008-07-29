From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: cosmetic bug in mdadm
Date: Mon, 28 Jul 2008 18:06:58 -0800 (AKDT)
Message-ID: <Pine.LNX.4.64.0807281805190.20007@filesrv1.baby-dragons.com>
References: <cccedfc60807281035n23a93665s412cab3b25464ef5@mail.gmail.com>
 <18574.28090.931731.900997@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18574.28090.931731.900997@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,  See below ...

On Tue, 29 Jul 2008, Neil Brown wrote:
> On Monday July 28, jnelson-linux-raid@jamponi.net wrote:
>> mdadm --grow --help shows
>>
>>   --raid-disks=  -n   : Change the number of active devices in an array.
>>                       : array.
>>
>> but the manpage uses:
>>
>>   --raid-devices
>>
>> The latter should be preferred?
>> Also, a --grow fails without a spare or --backup-file, however
>> --backup-file is only in the manpage, not in the --help. That's pretty
>> minor but useful.
>
> Fair comments.
> Does this address your observations suitably?
>
> Thanks.
> NeilBrown
>
>
>
> diff --git a/ReadMe.c b/ReadMe.c
> index 0a736ed..7a67158 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -518,9 +518,12 @@ char Help_grow[] =
> "  --size=        -z   : Change the active size of devices in an array.\n"
> "                      : This is useful if all devices have been replaced\n"
> "                      : with larger devices.\n"
> -"  --raid-disks=  -n   : Change the number of active devices in an array.\n"
> +"  --raid-devices= -n  : Change the number of active devices in an array.\n"
> "                      : array.\n"
 	To what command  ^^^^^^^^^^^ is this associated in the --help output ?

 	Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
