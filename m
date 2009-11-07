From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: Raid Degradation best practices
Date: Sat, 07 Nov 2009 08:12:55 -0500
Message-ID: <4AF57257.7010207@gmail.com>
References: <4AF41AFB.3000302@gmail.com> <alpine.DEB.2.00.0911070650380.4559@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0911070650380.4559@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, nfbrown@novell.com
List-Id: linux-raid.ids

I am using RAID6, on 9 WD1001FALS drives.

The VERY important data is backed up to multiple external drives and
stored at a separate location.

I figured out my issue last night. I had an issue with the array where
it was doing the silly /dev/md_d0 thing, so when I stopped that and
started the new one I did '--assume-clean' then when I started copying
my information back to the array multiple devices dropped out. Their
SMART information passes just fine, so it must have been the array was
not clean.

This was my mistake, but in the future when I have a real drive failure
I was curious to see how you approach that issue.

Thanks,

Justin Piszcz wrote:
>
>
> On Fri, 6 Nov 2009, Andrew Dunn wrote:
>
>> This morning my array lost a drive, then another. This was not due to
>> drive failures of hardware issues.
>>
>> I did not have any data on the array so I wiped the drives and
>> re-created it. So far everything seems fine.
>>
>> I would like to know what some of your practices are for the scenario
>> where you loose a drive or more on a mission critical array. I chose the
>> newbish route because I didn't have enough time or expertise to diagnose
>> the problems further. Typically this means it will happen again, and I
>> will still be unprepared.
>>
>> Would appreciate your input, thanks.
>>
>> -- 
>> Andrew Dunn
>> http://agdunn.net
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> How did you lose the drives then?
>
> If it is a mission-critical array, what RAID type are you using?
>
> Are you backing up the data regularly, since it is mission-critical?
>
> Justin.
>

-- 
Andrew Dunn
http://agdunn.net

