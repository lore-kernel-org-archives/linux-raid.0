From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 5 Sep 2017 10:54:37 +0800
Message-ID: <14395d10-a370-8f0f-09e1-3abc6fe7ba77@suse.de>
References: <1502426543-15229-1-git-send-email-byungchul.park@lge.com>
 <20170818012426.GX20323@X58A-UD3R>
 <34c37201-1ec8-270e-91b0-a8d94b7a7d6e@coly.li>
 <20170905023731.GR3240@X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905023731.GR3240@X58A-UD3R>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Byungchul Park <byungchul.park@lge.com>, Coly Li <i@coly.li>
Cc: kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, nborisov@suse.com, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On 2017/9/5 上午10:37, Byungchul Park wrote:
> On Fri, Aug 18, 2017 at 02:04:20PM +0800, Coly Li wrote:
>> On 2017/8/18 上午9:24, Byungchul Park wrote:
>>> On Fri, Aug 11, 2017 at 01:42:23PM +0900, Byungchul Park wrote:
>>>> Although llist provides proper APIs, they are not used. Make them used.
>>>
>>> Any opinions about this?
>>>
>>
>> The patch is good. If Eric has no time, I will take care of it later.
> 
> I would be appriciated if you take this at this window :)

Sure, I am preparing a patch list to block maintainers which we are
missed in last merge window, your patch is in the list.

It will be in one or two days from my side.

Coly

>>>>
>>>> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
>>>> Acked-by: Coly Li <colyli@suse.de>
>>>> ---
>>>>  drivers/md/bcache/closure.c | 15 ++-------------
>>>>  1 file changed, 2 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
>>>> index 864e673..7d5286b 100644
>>>> --- a/drivers/md/bcache/closure.c
>>>> +++ b/drivers/md/bcache/closure.c
>>>> @@ -70,21 +70,10 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
>>>>  	list = llist_del_all(&wait_list->list);
>>>>  
>>>>  	/* We first reverse the list to preserve FIFO ordering and fairness */
>>>> -
>>>> -	while (list) {
>>>> -		struct llist_node *t = list;
>>>> -		list = llist_next(list);
>>>> -
>>>> -		t->next = reverse;
>>>> -		reverse = t;
>>>> -	}
>>>> +	reverse = llist_reverse_order(list);
>>>>  
>>>>  	/* Then do the wakeups */
>>>> -
>>>> -	while (reverse) {
>>>> -		cl = container_of(reverse, struct closure, list);
>>>> -		reverse = llist_next(reverse);
>>>> -
>>>> +	llist_for_each_entry(cl, reverse, list) {
>>>>  		closure_set_waiting(cl, 0);
>>>>  		closure_sub(cl, CLOSURE_WAITING + 1);
>>>>  	}
>>>> -- 
>>>> 1.9.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
