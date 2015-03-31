From: Dave Stevens <geek@uniserve.com>
Subject: Re: no good deed goes unpunished...
Date: Tue, 31 Mar 2015 16:31:49 -0700
Message-ID: <20150331163149.17561l98u50rh1t1@webmail.uniserve.com>
References: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com>
 <CAAMCDef5ejTu4aoYxMRxaRPvV9kKO4qwzbo9jAuPnFDYDoHo0A@mail.gmail.com>
 <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com>
 <5515FC86.7030402@fnarfbargle.com>
 <20150331144155.14405dy3bqxotw9v@webmail.uniserve.com>
 <551B1717.2090809@turmel.org> <551B179A.6020008@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551B179A.6020008@turmel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Brad Campbell <brad@fnarfbargle.com>, Roger Heflin <rogerheflin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Quoting Phil Turmel <philip@turmel.org>:

snip!
> On 03/31/2015 05:52 PM, Phil Turmel wrote:
> If you did this with those three disks, you are likely to have random
>> data corruption from the older mirror.  If so, stop and re-assemble with
>> just the last good disks.
>
> Let me clarify: you only had *two* working disks for a month or so
> before the array finally died.  Only assemble those two.

yes that's clear. I've done that, found the LVM volgroup and can now  
see the Xen domains, working on getting data off.

many thanks!

D

>
> Phil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
"As long as politics is the shadow cast on society by big business,
the attenuation of the shadow will not change the substance."

-- John Dewey





