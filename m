From: Brendan Conoboy <synk@swcp.com>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Wed, 19 Apr 2006 10:41:40 -0700
Message-ID: <44467654.2060903@swcp.com>
References: <200604191631.04305.Dexter.Filmore@gmx.de>	 <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com> <1145466223.8608.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1145466223.8608.84.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Shai <shaibn@gmail.com>, Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang wrote:
>> Why can't you just mark that drive as failed, remove it and hotadd a
>> new drive to replace the failed drive?
> 
> because background rebuild is slower than disk to disk copy, since his
> disk is still fully functional.

Wouldn't it be great if every disk in a RAID volume were in its own way 
a degraded RAID1 device without a mirror?  Then when any drive started 
generating recoverable errors and warnings a mirror could be allocated 
without any downtime.  You can certainly generate a layout like this 
manually, but it would be nice to have that sort of feature out of the 
box (and without the performance hit!).  This would help a great deal in 
a situation such as Dexter's.

-Brendan (synk@swcp.com)
