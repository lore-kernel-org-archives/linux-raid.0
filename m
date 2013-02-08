From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 18:21:53 +1100
Message-ID: <5114A791.3060802@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <511361B3.8060204@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511361B3.8060204@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 19:11, Stan Hoeppner wrote:
> On 2/7/2013 12:48 AM, Adam Goryachev wrote:
> Switching to noop may help a little, as may disablig NCQ, i.e. putting
> the driver in native IDE mode, or setting queue depth to 1.
> 

I changed these two settings last night (noop and nr_request = 1) and
today seemed to produce more complaints, and more errors logged about
write failures, so I have restored nr_requests to 128 and the scheduler
back to deadline.

Regards,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
