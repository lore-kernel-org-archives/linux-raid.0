From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: FailSpare event?
Date: Thu, 11 Jan 2007 16:40:18 -0800
Message-ID: <45A6D8F2.3030800@fatooh.org>
References: <eo6cn8$5se$1@sea.gmane.org> <17830.47341.560158.521091@notabene.brown> <20070111223628.GU32386@mikee.ath.cx> <17830.49475.108136.376489@notabene.brown> <20070111230636.GV32386@mikee.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070111230636.GV32386@mikee.ath.cx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike wrote:
> I found the smartctl command. I have a 'long' test running in the background.
> I checked this drive and the other drives. This drive has been used the least
> (confirms it is a spare?) and is the only one with 'Total uncorrected errors' > 0.
> 
> How to determine the error, correct the error, or clear the error?
> 
> Mike
> 

[cut]

> SMART Self-test log
> Num  Test              Status                 segment  LifeTime  LBA_first_err [SK ASC ASQ]
>      Description                              number   (hours)
> # 1  Background long   Completed, segment failed   -    3943                 - [-   -    -]
> 
> Long (extended) Self Test duration: 2726 seconds [45.4 minutes]

Am I mistaken, or does the above information not say that the long 
self-test actually failed? If a SMART test fails, that should be 
sufficient cause to RMA the drive if it's still under warranty.

It might not actually be that surprising to have a largely unused drive 
fail. I've had a couple drives fail due to what I presume is bearing 
wear: the drive gradually gets noisy (over many months) and eventually 
starts having intermittent errors that get more and more frequent. If 
your drive was spinning while it was a spare, then it would be just as 
likely to wear out a bad bearing as any of your other drives. Of course, 
it could be some other problem; that's just an example.

-Corey
