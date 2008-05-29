From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
Date: Thu, 29 May 2008 08:06:24 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805290805500.17643@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Thu, 29 May 2008, Holger Kiehl wrote:

> On Wed, 28 May 2008, Justin Piszcz wrote:
>
>> Hardware:
>> 
>> Results:
>> 
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>> 
> Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
> 86797? I would have thought that raid6 was always a bit slower in writting
> due to having to write double amount of parity data.
>
> Holger
>

I will re-run the RAID5 test and also run the test on a single disk and 
update the results later.

Justin.
