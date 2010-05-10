From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Spare drive won't spin down
Date: Mon, 10 May 2010 12:59:33 -0400
Message-ID: <4BE83B75.8050709@tmr.com>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>	<20100507162034.1370d645@notabene.brown>	<717013.48748.qm@web31703.mail.mud.yahoo.com> <20100507194704.3ffcf17e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100507194704.3ffcf17e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Fri, 7 May 2010 00:40:40 -0700 (PDT)
> Joe Bryant <tenminjoe@yahoo.com> wrote:
>
>   
>>> I'll see about fixing that.
>>>
>>> Recreate the array with "--metadata 1.0" or "--metadata 1.2" and it should work better.
>>>       
>> That's great, thanks very much.
>>
>>     
>
> It turns out it is a bit more subtle than that, though that approach may work
> for you.
> If you make an odd number of changes to the metadata, it will switch from
> doing what you want, to not.
> e.g. if /dev/foo is your spare device, then
>
>   mdadm /dev/md0 -f /dev/foo
>   mdadm /dev/md0 -r /dev/foo
>   mdadm /dev/md0 -a /dev/foo
>
> will switch between working and not working.  v0.90 metadata starts out not
> working.  v1.x start out working.
>   

So we can assume that the little dance steps above will make 1.x 
misbehave in the same way?

Could you explain (point to an explanation) why this whole odd/even 
thing exists?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

