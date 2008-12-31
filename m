From: Mark Lord <liml@rtr.ca>
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native
  293046768
Date: Wed, 31 Dec 2008 11:33:23 -0500
Message-ID: <495B9ED3.8050008@rtr.ca>
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan> <495A5A9F.9020406@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <495A5A9F.9020406@shaw.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Robert Hancock wrote:
> Justin Piszcz wrote:
>> On one system, two Raptor 150s:
>>
>> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
..
> Presumably somebody or something set up a host protected area on one 
> drive and not the other.. I believe there are some utilities out there 
> that can be used to disable the HPA and allow the full capacity to be used.
..

"hdparm -N" can do this, temporarily or permanently.
Get the latest version from Sourceforge, and see the manpage for details.

-ml

