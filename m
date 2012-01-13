From: David Brown <david@westcontrol.com>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Fri, 13 Jan 2012 18:48:44 +0100
Message-ID: <jepr0k$c6j$3@dough.gmane.org>
References: <1325762201-23949-1-git-send-email-Jes.Sorensen@redhat.com>	<1325762201-23949-2-git-send-email-Jes.Sorensen@redhat.com> <20120112104320.471910db@notabene.brown> <4F0E8873.8040900@hesbynett.no> <4F0EE3F3.9050906@ziu.info> <4F1021A3.6020203@westcontrol.com> <4F103DD5.4090402@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F103DD5.4090402@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/01/2012 15:21, Michal Soltys wrote:
> On 13.01.2012 13:20, David Brown wrote:
>>>
>>> OTOH: __attribute__((__may_alias__)) should(?) always give consistent
>>> (expected) results with type definitions that are used as aliases.
>>> Maybe it would be better to go by this route.
>>
>> I couldn't find that attribute in the gcc manual.
>
> http://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html#Type-Attributes
>
> Near the bottom of the page.

Thanks.  I was looking at variable attributes - most type attributes are 
also found there.



