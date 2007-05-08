From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Speed variation depending on disk position
Date: Tue, 08 May 2007 09:34:12 -0400
Message-ID: <46407C54.7030306@tmr.com>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan> <20070505205456.GA17112@tuatara.stupidest.org> <463CF908.6000602@rabbit.us> <463E2EF0.6010408@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463E2EF0.6010408@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie wrote:
> Peter Rabbitson wrote:
>
>> design of modern drives? I have an array of 4 Maxtor sata drives, and
>> raw read performance at the end of the disk is 38mb/s compared to 62mb/s
>> at the beginning.
>
> At least one supplier of terabyte arrays mitigates this effect and 
> improves seek times, by using 750GB drives and only utilising the 
> first 500GB.
You can do some tuning using partitions this way, assuming you have data 
which are small, and/or accessed infrequently, and some other data where 
transfer rate is important. Same idea, but you get to use all of the 
drive capacity.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

