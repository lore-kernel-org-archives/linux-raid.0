From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 07:04:17 -0600
Message-ID: <5114F7D1.40809@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <511361B3.8060204@hardwarefreak.com> <5114A791.3060802@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5114A791.3060802@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/8/2013 1:21 AM, Adam Goryachev wrote:
> On 07/02/13 19:11, Stan Hoeppner wrote:
>> On 2/7/2013 12:48 AM, Adam Goryachev wrote:
>> Switching to noop may help a little, as may disablig NCQ, i.e. putting
>> the driver in native IDE mode, or setting queue depth to 1.
>>
> 
> I changed these two settings last night (noop and nr_request = 1) and
> today seemed to produce more complaints, and more errors logged about
> write failures, so I have restored nr_requests to 128 and the scheduler
> back to deadline.

/sys/block/sda/queue/nr_requests has nothing to do with the SATA queue
depth.  nr_requests controls the queue size of the scheduler (elevator).
 Decreasing that to a value of 1 will obviously have dire consequences,
dramatically decreasing SSD throughput.

I was referring to the NCQ queue depth on the C204 SATA controller.
This may or may not be manually configurable with that hardware/driver,
but fully autonegotiated between the chip and the SSDs.  Which is why I
mentioned switching to the native IDE mode, which disabled NCQ entirely.
 However, disabling NCQ, if it helps, is a very minor performance
optimization, and won't have significant impact on your problem.

Regardless, after reading your previous email, which I'll respond to
next, it seems pretty clear your overarching problem is a network
architecture oversight/flaw.

-- 
Stan

