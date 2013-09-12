From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Thu, 12 Sep 2013 09:55:01 +0200
Message-ID: <52317355.6020201@profitbricks.com>
References: <52090E6D.10104@profitbricks.com> <20130813143115.55dd27d1@notabene.brown> <5209E37D.6050107@profitbricks.com> <20130814104410.10bb2259@notabene.brown> <520B3B39.4060703@profitbricks.com> <522EFDD1.3000708@profitbricks.com> <20130911095459.086d532d@notabene.brown> <52301E58.7010000@gmail.com> <20130912085933.54b5021b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130912085933.54b5021b@notabene.brown>
Sender: stable-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jack Wang <xjtuwjp@gmail.com>, linux-raid@vger.kernel.org, Sebastian Riemer <sebastian.riemer@profitbricks.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On 09/12/2013 12:59 AM, NeilBrown wrote:
> On Wed, 11 Sep 2013 09:40:08 +0200 Jack Wang <xjtuwjp@gmail.com> wrote:
> 
>> On 09/11/2013 01:54 AM, NeilBrown wrote:
>>> On Tue, 10 Sep 2013 13:09:05 +0200 Jack Wang <jinpu.wang@profitbricks.com>
>>> wrote:
>>>
>>>> snip
>>>>
>>>> Hi Neil,
>>>>
>>>> I notice you send out pull request for md update, which include fix for
>>>> this bug.
>>>>
>>>> I think we'd better include the fix to stable tree at least from 3.4
>>>> above, what do you think?
>>>
>>> I don't think it is a situation that is at all like to occur in normal usage,
>>> so it doesn't seem justified for -stable.
>>>
>>> Do you disagree?  Did you ever experience the deadlock in normal usage or
>>> only in artificial situations?
>>
>> Yes, we do see this BUG in our production environment, so I think it's
>> good to include it in stable tree.
>>
> 
> I was hoping you would explain how....
> 
> Maybe I'm misunderstanding, but as I see it the deadlock can only occur if
> you run "mdadm --stop" while some other process has the block device open
> and is writing to it.  That seems like a dumb thing to do and my suggest
> would be to not do it.
> Is there a good reason why you try to stop the array while it is being
> written to.
> Would it make sense for the process to open the block device with O_EXCL.
> This would encourage exclusive access, and would also prevent the deadlock
> from happening.
> 
> NeilBrown
> 
Thanks Neil for suggestion.
I will look into the code which is developed by other colleagues, and we
will fix that if it is.

Regards,
Jack
