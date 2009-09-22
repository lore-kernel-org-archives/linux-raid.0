From: Gabriele Trombetti <gabriele.trombetti@itb.cnr.it>
Subject: Re: md data-check causes soft lockup
Date: Tue, 22 Sep 2009 21:35:09 +0200
Message-ID: <4AB926ED.4010900@itb.cnr.it>
References: <4AB7C11E.60801@howardsilvan.com>
 <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com>
 <4AB8E2A6.2020800@howardsilvan.com>
 <70ed7c3e0909220748y2e151ebv7f232cf2b7c79617@mail.gmail.com>
 <4AB8E661.8080706@howardsilvan.com>
 <20090922151925.GA20382@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20090922151925.GA20382@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
> On Tue Sep 22, 2009 at 07:59:45AM -0700, Lee Howard wrote:
>
>   
>> Majed B. wrote:
>>     
>>> I must have missed that part. It may not work for your case, but worth trying.
>>>
>>> Perhaps Neil Brown, or someone involved could shed some light on this.
>>>
>>> If I remember correctly, those soft lockups were harmless anyway.
>>>   
>>>       
>> Not harmless for production use.  Yes, data is not harmed, and yes, the 
>> problem state does recover when the data-check finishes, but during the 
>> data-check the system is virtually unresponsive and all other use of the 
>> system is stalled.
>>
>>     
> Are you sure this is caused by these soft lockups, and that you're not
> just running with too high a /sys/block/mdX/md/sync_speed_max setting?
> I've had issues with this on some servers, where the I/O demand for the
> sync/check is causing the system to become totally unresponsive.
>   

That's correct for me in the sense that lowering sync_speed_max solves
the problem, see my post, however I'd call it a bug if a value of
sync_speed_max too high starves the system forever. The resync is
supposed to be less prioritarian than normal I/O disk operations, but it
doesn't happen this way. Also note that lowering the value of
stripe_cache_size also solves the problem: how would this fit into your
reasoning?

(BTW I have not checked the mentioned patch yet, I'm not sure I can do
that in a short time because our servers are into production now)

