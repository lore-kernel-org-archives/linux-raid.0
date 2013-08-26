From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Mon, 26 Aug 2013 09:44:26 +0200
Message-ID: <CAC9WiBjk70P_xTgH3_BFS8QREJnfY+-LAiR-2FnS3PaJKQ_1vw@mail.gmail.com>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
	<51EED0DA.3020901@arcor.de>
	<51EED102.4020503@arcor.de>
	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
	<51EEF3D3.7020305@arcor.de>
	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
	<51F1754B.5000905@arcor.de>
	<CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
	<51FAA5C3.8030109@arcor.de>
	<CAC9WiBhGyE=OJdSeL_OsPxtirhJ2=3WRsk=uBPiOTzMjBCf-dA@mail.gmail.com>
	<51FBF830.5060606@arcor.de>
	<CAC9WiBg8UT4iLsPCY8DgR9ysfj8OmJARnRfSuxtbUCx_+2eBDw@mail.gmail.com>
	<52190167.10107@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52190167.10107@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Martin,

On Sat, Aug 24, 2013 at 8:54 PM, Martin Wilck <mwilck@arcor.de> wrote:
> Hi Francis,
>
>> On Fri, Aug 2, 2013 at 8:19 PM, Martin Wilck <mwilck@arcor.de> wrote:
>>> On 08/02/2013 02:46 PM, Francis Moreau wrote:
>>>
>>>>>
>>>>> # mdadm -E /dev/sda | egrep "state"
>>>>>         state[0] : Optimal, Consistent
>>>>>    init state[0] : Fully Initialised
>>>
>>> This would correspond to "00 02", and it's what we should see after
>>> initialization. On my system the BIOS sets "00 01" (Optimal, consistent,
>>> Quick Init in progress) when it first creates an array, because the BIOS
>>> doesn't do a full initialization. But "not initialized" is weird. The
>>> mdadm DDF code won't set this by itself, AFAIK. Please make sure again
>>> that the "before" data matches what mdadm/mdmon wrote just after
>>> stopping during shutdown.
>>
>> I did it again and got the same result: both disks have:
>>
>> 00000860  00 00 ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
>>
>> and I checked again that "mdadm -E" reported an initialized state.
>>
>> Moreover this time I did a "sync" before dumping the ddf headers.
>>
>> So I'm quite lost, I can see only 2 cases:
>>
>>   - with my HW setup some metadata are not written to disks by the
>> kernel but stood somewhere in RAM (cache)
>>
>>   - the state is not stored at address 00000860 (very unlikely)
>>
>>   - the dumps are incorrect
>>
>> How can I debug this more ?
>>
>> Thanks for your help.
>
> have you got any further insight?

Unfortunately no progress on this issue, I'm really stuck. I'll try to
test a different distribution to see if the same issue persist. Maybe
CentOS ;)

> I have LSI DDF fake RAID with mdadm
> running on my system right now, and it seems to work nicely; no problems
> over reboots.
>
> You may want to retry with my latest patch set. In particular, "DDF:
> container_content_ddf: set safe_mode_delay > 0" might help.

Will give it a test.

Thanks.
-- 
Francis
