From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 28 Oct 2015 13:38:50 -0400
Message-ID: <5631082A.4060100@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
 <562D5F91.5040300@turmel.org> <5630F862.5040308@tantosonline.com>
 <5630FB05.5070902@turmel.org> <56310197.1010708@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56310197.1010708@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Tantos <andras@tantosonline.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/2015 01:10 PM, Andras Tantos wrote:
> Phil,
> 
>>> To be able to re-assemble the array, I *have* to specify metadata
>>> version 0.9:
>>>
>>> Is this a problem? Can I upgrade my array to 1.0 metadata? Should I?
>>
>> Hmm. Interesting.  Your version of mdadm is insisting on reserving much
>> more space between end of content and the v1.0 metadata than when using
>> v0.90 metadata.
>>
>> I'm curious how much.  Please show the output of "cat /proc/partitions".

Ok.  I think your version of mdadm is trying to put a bitmap on the v1.0
array, which can be suppressed with --bitmap=none.  Or just do the
--assemble --update.

Phil

