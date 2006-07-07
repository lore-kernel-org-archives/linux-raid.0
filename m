From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Fri, 7 Jul 2006 18:39:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607071838480.8499@p34.internal.lan>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
 <Pine.LNX.4.64.0607071037190.5153@p34.internal.lan> <17582.55703.209583.446356@cse.unsw.edu.au>
 <Pine.LNX.4.64.0607071814510.8499@p34.internal.lan> <17582.57549.204471.855655@cse.unsw.edu.au>
 <Pine.LNX.4.64.0607071832200.8499@p34.internal.lan> <17582.57931.816012.142421@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17582.57931.816012.142421@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 8 Jul 2006, Neil Brown wrote:

> On Friday July 7, jpiszcz@lucidpixels.com wrote:
>>
>> I guess one has to wait until the reshape is complete before growing the
>> filesystem..?
>
> Yes.  The extra space isn't available until the reshape has completed
> (if it was available earlier, the reshape wouldn't be necessary....)
>
> NeilBrown
>

Just wanted to confirm, thanks for all the help, I look forward to the new 
revision of mdadm :)  In the mean time, after I get another drive I will 
try your work around, but so far it looks good, thanks.!

Justin.

