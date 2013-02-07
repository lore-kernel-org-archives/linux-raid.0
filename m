From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 02:24:24 -0600
Message-ID: <511364B8.5040900@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <51134F0F.607@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51134F0F.607@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/7/2013 12:51 AM, Adam Goryachev wrote:
> Sorry, graphs can be seen at:
> 
> http://203.98.89.64/graphs/

The graphs tell us nothing in isolation Adam.  What is needed is to know
what workloads are running when the device queues and response times
start piling up.  Whether rust or SSD, queues will increase, as well as
IO completion times, when sufficient IO is being performed.

-- 
Stan

