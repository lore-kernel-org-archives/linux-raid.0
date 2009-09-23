From: "Majed B." <majedb@gmail.com>
Subject: Re: md data-check causes soft lockup
Date: Wed, 23 Sep 2009 03:16:43 +0300
Message-ID: <70ed7c3e0909221716o3e6d841fj59c6b003374c7a94@mail.gmail.com>
References: <4AB7C11E.60801@howardsilvan.com> <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com>
	<4AB8E2A6.2020800@howardsilvan.com> <70ed7c3e0909220748y2e151ebv7f232cf2b7c79617@mail.gmail.com>
	<4AB8E661.8080706@howardsilvan.com> <20090922151925.GA20382@cthulhu.home.robinhill.me.uk>
	<4AB926ED.4010900@itb.cnr.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB926ED.4010900@itb.cnr.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gabriele Trombetti <gabriele.trombetti@itb.cnr.it>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Why would you lower the max value? You should keep the min value as
low as possible and md would drop to that automatically if there are
applications demanding access to the array.

On Tue, Sep 22, 2009 at 10:35 PM, Gabriele Trombetti
<gabriele.trombetti@itb.cnr.it> wrote:
> Robin Hill wrote:
>>
>> On Tue Sep 22, 2009 at 07:59:45AM -0700, Lee Howard wrote:
>>
>>
>>>
>>> Majed B. wrote:
>>>
>>>>
>>>> I must have missed that part. It may not work for your case, but w=
orth
>>>> trying.
>>>>
>>>> Perhaps Neil Brown, or someone involved could shed some light on t=
his.
>>>>
>>>> If I remember correctly, those soft lockups were harmless anyway.
>>>>
>>>
>>> Not harmless for production use. =C2=A0Yes, data is not harmed, and=
 yes, the
>>> problem state does recover when the data-check finishes, but during=
 the
>>> data-check the system is virtually unresponsive and all other use o=
f the
>>> system is stalled.
>>>
>>>
>>
>> Are you sure this is caused by these soft lockups, and that you're n=
ot
>> just running with too high a /sys/block/mdX/md/sync_speed_max settin=
g?
>> I've had issues with this on some servers, where the I/O demand for =
the
>> sync/check is causing the system to become totally unresponsive.
>>
>
> That's correct for me in the sense that lowering sync_speed_max solve=
s
> the problem, see my post, however I'd call it a bug if a value of
> sync_speed_max too high starves the system forever. The resync is
> supposed to be less prioritarian than normal I/O disk operations, but=
 it
> doesn't happen this way. Also note that lowering the value of
> stripe_cache_size also solves the problem: how would this fit into yo=
ur
> reasoning?
>
> (BTW I have not checked the mentioned patch yet, I'm not sure I can d=
o
> that in a short time because our servers are into production now)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
