From: Dave Stevens <geek@uniserve.com>
Subject: Re: no good deed goes unpunished...
Date: Fri, 27 Mar 2015 19:14:46 -0700
Message-ID: <20150327191446.1139462n2xnea4d2@webmail.uniserve.com>
References: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com>
 <CAAMCDef5ejTu4aoYxMRxaRPvV9kKO4qwzbo9jAuPnFDYDoHo0A@mail.gmail.com>
 <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com>
 <551603A2.4080808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551603A2.4080808@turmel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Quoting Phil Turmel <philip@turmel.org>:

> Hi Dave,
>
> {Convention on kernel.org is reply-to-all, trim quotes, and avoid
> top-posting.  Please trim.}

ok, thanks

>
> On 03/27/2015 08:37 PM, Dave Stevens wrote:
>> # cat /proc/mdstat
>>
>> Personalities :
>>
>> md12 : inactive   sda2[0](S)
>>     732467520 blocks
>>
>> md10 : inactive sdc2[2](S) sdb2[1](S)
>>     1464935040 blocks
>
> If your livecd tried to be helpful by assembling arrays, but couldn't
> complete, you end up with partially-assembled inactive arrays like shown
> above.  The member devices shown are *busy*, under the expectation that
> the remaining device(s) will show up soon. :-)
>
> As Roger tried to suggest, you need to run:
>
> mdadm --stop /dev/md10
> mdadm --stop /dev/md12
>
> That'll release the member devices you need.  However, the device
> assembly pairs above look suspicious.  I suggest you show mdadm -E for
> those devices again to make sure you work with the correct two disks.
> (sda and sdc from the original report.)
>
> Then you can do:
>
> mdadm --assemble --force --verbose /dev/mdX /dev/sdY2 /dev/sdZ2
>
> with the correct substitutions for X, Y, and Z.
>
> If that doesn't work, show the output.
>
> Phil

will do, thanks

D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
"As long as politics is the shadow cast on society by big business,
the attenuation of the shadow will not change the substance."

-- John Dewey





