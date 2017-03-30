From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 2/2] mdadm.c: fix compile error "switch condition has
 boolean value"
Date: Thu, 30 Mar 2017 11:53:54 -0400
Message-ID: <1f82bdbf-6b69-ce77-d989-6f375a9ff61b@gmail.com>
References: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
 <1490780434-8720-2-git-send-email-gi-oh.kim@profitbricks.com>
 <wrfjpoh0dqzz.fsf@gmail.com> <87lgrnu5k4.fsf@notabene.neil.brown.name>
 <20170330075209.GF17378@ws00837>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170330075209.GF17378@ws00837>
Sender: linux-kernel-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Wol <anthony@youngman.org.uk>
List-Id: linux-raid.ids

On 03/30/2017 03:52 AM, Gioh Kim wrote:
> On Thu, Mar 30, 2017 at 08:38:35AM +1100, NeilBrown wrote:
>> On Thu, Mar 30 2017, jes.sorensen@gmail.com wrote:
>>
>>> Gioh Kim <gi-oh.kim@profitbricks.com> writes:
>>>> Remove a boolean expression in switch condition
>>>> to prevent compile error of some compilers.
>>>
>>> Please be specific, which compile is unable to handle this?
>>>
>>>> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
>>>> ---
>>>>  mdadm.c | 6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mdadm.c b/mdadm.c
>>>> index 08ddcab..a98a051 100644
>>>> --- a/mdadm.c
>>>> +++ b/mdadm.c
>>>> @@ -1905,11 +1905,11 @@ static int misc_list(struct mddev_dev *devlist,
>>>>  			rv |= SetAction(dv->devname, c->action);
>>>>  			continue;
>>>>  		}
>>>> -		switch(dv->devname[0] == '/') {
>>>> -			case 0:
>>>> +		switch(dv->devname[0]) {
>>>> +			default:
>>>>  				mdfd = open_dev(dv->devname);
>>>>  				if (mdfd >= 0) break;
>>>> -			case 1:
>>>> +			case '/':
>>>>  				mdfd = open_mddev(dv->devname, 1);
>>>>  		}
>>>>  		if (mdfd>=0) {
>>>
>>> While I agree the original code is ugly, I am not convinced your
>>> replacement is a lot prettier.
>>>
>>
>> Maybe
>>
>> 		if (dv->devname[0] == '/' ||
>> 		    (mdfd = open_dev(dv->devname)) < 0)
>> 				mdfd = open_mddev(dv->devname, 1);
>>
>> ??
>> NeilBrown
>
> Yes, the initial version I thought was:
>
> if (dev->devname[0] != '/')
>     mdfd = open_dev(dv->devname);
> if (dev->devname[0] == '/' || mdfd < 0)
>     mdfd = open_mddev(dv->devname, 1);
>
> But I thought you have a reason to use switch-case expression,
> so I kept switch-case.
> If you agree, I'll send v2 patch using if-expression.
>

I like this solution better, I much favor code that is more explicit in 
what it does. Request less brain capacity for me to read :)

Cheers,
Jes
