From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Fri, 23 Feb 2007 10:52:08 -0500
Message-ID: <45DF0DA8.9010305@tmr.com>
References: <20070220172544.15678.patches@notabene>	<1070220063516.16208@suse.de> <20070221144806.e6eed85c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070221144806.e6eed85c.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote:
> On Tue, 20 Feb 2007 17:35:16 +1100
> NeilBrown <neilb@suse.de> wrote:
>
>   
>> +		for (i = conf->raid_disks ; i-- ;  ) {
>>     
>
> That statement should be dragged out, shot, stomped on then ceremonially
> incinerated.
>
> What's wrong with doing
>
> 	for (i = 0; i < conf->raid_disks; i++) {
>
> in a manner which can be understood without alcoholic fortification?

I don't find either hard to read, but you suggestion isn't equivalent, 
since it increments rather than decrements the index.
I admit I probably would write it the same way Neil did...

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

