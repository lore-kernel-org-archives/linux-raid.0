From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID6 Reshape Gone Awry
Date: Fri, 03 Aug 2012 13:25:34 -0500
Message-ID: <501C179E.7070709@hardwarefreak.com>
References: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com> <501BB374.9020607@hardwarefreak.com> <501BD420.10203@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501BD420.10203@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Flynn <flynn@kodachi.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/3/2012 8:37 AM, David Brown wrote:
> On 03/08/2012 13:18, Stan Hoeppner wrote:

>> The primary function of RAID is to protect your data in the event of a
>> _disk_ failure.  Creating multiple arrays from _partitions_ on the same
>> set of physical disks does nothing to protect one from disk failure.
>>
> 
> That's not how I understand the disk layout - if I'm right, it is still
> a monstrosity, but one that will offer protection on disk failure.

I didn't state this setup would not protect data from disk failure.  I
stated that a single array would have done that.  Making 9 more simply
causes all kinds of problems without any additional benefits.

-- 
Stan

