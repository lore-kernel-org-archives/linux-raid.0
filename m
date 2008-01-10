From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Thu, 10 Jan 2008 15:28:30 -0500
Message-ID: <47867FEE.8070704@tmr.com>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>	<alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>	<Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>	<e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>	<alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org>	<e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com>	<alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org>	<1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>	<18309.25170.258730.225322@notabene.brown>	<e9c3a7c20801091907k732b0fcfw8b74502cca76f972@mail.gmail.com> <18309.38832.518580.235804@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18309.38832.518580.235804@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday January 9, dan.j.williams@intel.com wrote:
>   
>> On Jan 9, 2008 5:09 PM, Neil Brown <neilb@suse.de> wrote:
>>     
>>> On Wednesday January 9, dan.j.williams@intel.com wrote:
>>>
>>> Can you test it please?
>>>       
>> This passes my failure case.
>>     
>
> Thanks!
>
>   
>>> Does it seem reasonable?
>>>       
>> What do you think about limiting the number of stripes the submitting
>> thread handles to be equal to what it submitted?  If I'm a stripe that
>> only submits 1 stripe worth of work should I get stuck handling the
>> rest of the cache?
>>     
>
> Dunno....
> Someone has to do the work, and leaving it all to raid5d means that it
> all gets done on one CPU.
> I expect that most of the time the queue of ready stripes is empty so
> make_request will mostly only handle it's own stripes anyway.
> The times that it handles other thread's stripes will probably balance
> out with the times that other threads handle this threads stripes.
>
> So I'm incline to leave it as "do as much work as is available to be
> done" as that is simplest.  But I can probably be talked out of it
> with a convincing argument....
>   

How about "it will perform better (defined as faster) during conditions 
of unusual i/o activity?" Is that a convincing argument to use your 
solution as offered? How about "complexity and maintainability are a 
zero-sum problem?"

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


