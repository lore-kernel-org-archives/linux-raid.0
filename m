From: mark delfman <markdelfman@googlemail.com>
Subject: Re: Write cache
Date: Fri, 3 Dec 2010 13:09:26 +0000
Message-ID: <AANLkTimqBJ91OxvDDMQKKqhjrg1sriQYNk_WkJ1Gjfyy@mail.gmail.com>
References: <AANLkTim+dHWMeZkdFuRiimmNdkZ04j9tO3DCyOPAdxJK@mail.gmail.com>
	<20101203122739.32af28a1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101203122739.32af28a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

Actually I made a silly presumption simply because MD is so fast
compared to most of the hardware raids I am testing =96 so I simple
presumed it was using write cache without really investigating it well
enough

Thank you for the feedback!



On Fri, Dec 3, 2010 at 1:27 AM, Neil Brown <neilb@suse.de> wrote:
> On Thu, 2 Dec 2010 15:58:51 +0000 mark delfman <markdelfman@googlemai=
l.com>
> wrote:
>
>> Hi
>>
>> Is there any way to use an MD RAID in write through mode? =A0I
>> appreciate that there is a performance impact but this is important
>> from a security prospective....
>
> MD RAID does work in write-through mode. =A0I have occasionally thoug=
ht about
> adding a write-back mode which would make sense now that we have a se=
nsible
> flushing infrastructure in Linux. =A0But I haven't implemented it.
>
>>
>> The likelihood is that I would use RAID0 (I know this sounds like a
>> contradiction to the above, but the =91drives=92 are probably hardwa=
re
>> RAIDs). =A0But may use standard RAID6.
>
> RAID0 doesn't do any caching at all.
>
>>
>> I cannot see any way to disable write cache in MD, but I am hopefull=
y
>> I am simply missing something obvious.
>
> Why do you think these is a write-behind cache in MD ??
>
> NeilBrown
>
>
>
>>
>> I appreciate any feedback....
>>
>> Thanks, Mark
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
