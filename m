From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Wed, 11 Sep 2013 09:40:08 +0200
Message-ID: <52301E58.7010000@gmail.com>
References: <52090E6D.10104@profitbricks.com> <20130813143115.55dd27d1@notabene.brown> <5209E37D.6050107@profitbricks.com> <20130814104410.10bb2259@notabene.brown> <520B3B39.4060703@profitbricks.com> <522EFDD1.3000708@profitbricks.com> <20130911095459.086d532d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130911095459.086d532d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, linux-raid@vger.kernel.org, Sebastian Riemer <sebastian.riemer@profitbricks.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On 09/11/2013 01:54 AM, NeilBrown wrote:
> On Tue, 10 Sep 2013 13:09:05 +0200 Jack Wang <jinpu.wang@profitbricks.com>
> wrote:
> 
>> snip
>>
>> Hi Neil,
>>
>> I notice you send out pull request for md update, which include fix for
>> this bug.
>>
>> I think we'd better include the fix to stable tree at least from 3.4
>> above, what do you think?
> 
> I don't think it is a situation that is at all like to occur in normal usage,
> so it doesn't seem justified for -stable.
> 
> Do you disagree?  Did you ever experience the deadlock in normal usage or
> only in artificial situations?

Yes, we do see this BUG in our production environment, so I think it's
good to include it in stable tree.


> 
>>
>> md: avoid deadlock when dirty buffers during md_stop.
>>
>>> http://git.neil.brown.name/?p=md.git;a=commit;h=260fa034ef7a4ff8b73068b48ac497edd5217491
>>
>> BTW: It will be great if you could add my Reported-by and Tested-by:)
> 
> Sorry I forgot those.  To late to add them now.
> 
Fine, Thanks all the time:)

Regards,
Jack


> NeilBrown
> 
> 
> 
>>
>> Best regards,
>> Jack
>>
> 

