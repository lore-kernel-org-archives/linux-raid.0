From: Matthew Mitchell <matthew@geodev.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: Thu, 12 Jun 2003 09:45:37 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE89211.4030805@geodev.com>
References: <3EE74472.9010505@geodev.com>		 <1055350640.1929.28.camel@langvan.austin.ibm.com>		 <3EE76EDA.1060000@geodev.com>		 <1055359074.1929.70.camel@langvan.austin.ibm.com>		 <00c701c33050$00057360$7b07a8c0@pluto> <1055361035.1930.81.camel@langvan.austin.ibm.com> <3EE78D29.2EEFA36A@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE78D29.2EEFA36A@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Mike Tran <mhtran@us.ibm.com>, 3tcdgwg3 <3tcdgwg3@prodigy.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Mike Tran wrote:
> 
>>On Wed, 2003-06-11 at 14:31, 3tcdgwg3 wrote:
>>
>>>I am doing a sparc thingin. I have to build
>>>the disk images on a x86 system, and move the
>>>disk to my sparc, for debug/test.  Everhting works
>>>fine, except the MD's SB.  I tweaked a bit on MD
>>>driver, then everything is good.  I would think that
>>>MD should take care the SB format in next release.
>>>
>>
>>This work should start from the MD kernel driver.  That is the MD driver
>>has to write the SB in one known format and converts the SB to the
>>native cpu after reading it from disk.  Next, the MD tools (mdadm,
>>mdreconf, etc.) will need to follow.
>>
>>Neil B, Do you have this work item in mind?
> 
> 
> Neil's new version 1 superblock, which is present in the 2.5 kernel,
> addresses the byte ordering issues that are a problem in the current
> 0.90 superblock of the 2.4 md driver.
> The new superblock code stores all numeric values in little endian
> on-disk and converts them to CPU endianness before use.

Any possibility of a backport?  If it's not too hairy I don't mind 
attempting it myself, but I haven't even looked at md in 2.5.

-- 
Matthew Mitchell
Systems Programmer/Administrator            matthew@geodev.com
Geophysical Development Corporation         phone 713 782 1234
1 Riverway Suite 2100, Houston, TX  77056     fax 713 782 1829

