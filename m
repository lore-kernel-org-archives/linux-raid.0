From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Tue, 13 Aug 2013 09:42:53 +0200
Message-ID: <5209E37D.6050107@profitbricks.com>
References: <52090E6D.10104@profitbricks.com> <20130813143115.55dd27d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130813143115.55dd27d1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jack Wang <xjtuwjp@gmail.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

On 08/13/2013 06:31 AM, NeilBrown wrote:
> On Mon, 12 Aug 2013 18:33:49 +0200 Jack Wang <jinpu.wang@profitbricks.com>
> wrote:
> 
>> Hi Neil,
>>
>>
>> We've found md hang in our test, it's easy to reproduce with script
>> attached.
>>
>> We've tried 3.4 stable kernel and latest mainline, it still exists.
>>
>> Looks like flush bdi_writeback_workfn race with md_stop, no idea how to
>> fix it, could you kindly give us suggestions?
>>
>> Best regards,
>> Jack
> 
> Thanks for the report.  I can see how that deadlock could happen.
> 
> Can you please try this patch and confirm that it fixes it.
> I'm not really happy with this approach but nothing better occurs to me yet.
> 
> NeilBrown
> 

Hi Neil,

Thanks for quick fix, I tested on 3.4 stable and mainline, it works now.
Could you give more description about the bug and fix.

Regards,
Jack

