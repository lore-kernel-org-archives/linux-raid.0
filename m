From: Charles Bertsch <cbertsch@cox.net>
Subject: Re: PROBLEM: write to jbod with 3TB and 160GB drives hits BUG/oops
Date: Tue, 28 Apr 2015 18:05:06 -0700
Message-ID: <55402E42.1090005@cox.net>
References: <55398462.1000202@cox.net> <KdvS1q00X1hjKLY01dvTMG> <553AA35A.5050300@cox.net> <LpCG1q00n1hjKLY01pCHNM>
Reply-To: bertschc@acm.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <LpCG1q00n1hjKLY01pCHNM>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

On 04/26/2015 06:11 PM, NeilBrown wrote:
...
> Thanks for the details.
> On the whole, I don't think it is likely that your problem is directly
> related to md - just a coincidence that it happened when you were using md
> things.  But one never knows until that actual cause is found.
>
>>
>>   > Is there any chance you could use "git bisect" to find out exactly which
>>   > commit introduced the problem?  That is the mostly likely path to a
>> solution.
>>   >
>>
>>....
> NeilBrown
>
Neil,
Thanks for your attention on this matter.  I will attempt to narrow down 
the release or commit which leads to the symptom.

Charles Bertsch
