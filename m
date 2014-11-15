From: Phil Turmel <philip@turmel.org>
Subject: Re: failed RAID 5 array
Date: Sat, 15 Nov 2014 10:03:19 -0500
Message-ID: <54676B37.3000707@turmel.org>
References: <1415807882.4241.36.camel@lappy.neofreak.org> <54653735.90007@turmel.org> <1415971164.4241.38.camel@lappy.neofreak.org> <546606D4.5070406@turmel.org> <1415974131.4241.41.camel@lappy.neofreak.org> <5466173F.2060007@turmel.org> <1415980414.4241.49.camel@lappy.neofreak.org> <54662804.7040005@turmel.org> <20141115064215.99B01382C37@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141115064215.99B01382C37@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: DeadManMoving <sequel@neofreak.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Wolfgang,

On 11/15/2014 01:42 AM, Wolfgang Denk wrote:
> Dear Phil,
> 
> In message <54662804.7040005@turmel.org> you wrote:
>>
>> Yes.  Braces are expanded as given.  Square brackets are expanded in the
>> order found in the filesystem, not the order given.
> 
> "in the order found in the filesystem" is not correct.  Pathname
> expansion using [ ... ] patterns generates a _sorted_ list. 

I stand corrected.

Thanks, and Regards,

Phil
