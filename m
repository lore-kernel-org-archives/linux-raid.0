From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sun, 31 Jan 2010 19:30:57 -0600
Message-ID: <4B662ED1.3060003@gmail.com>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B65AD05.5050000@anonymous.org.uk> <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Sun, 31 Jan 2010, John Robinson wrote:
> 
>> iirc part of the point of moving to 4K sectors is to improve the error 
>> correction to something like 1 in 10^20 or 22 without losing storage 
>> density, partly by using what was lost before in inter-sector gaps and 
>> partly because you can do better with more bits of ECC over more data.
>>
>> Frankly I wish they'd sacrificed a little storage density and improved 
>> the error rate a long time ago.
> 
> Looking at the data sheet for WD20EADS and WD20EARS they both have 10^15 
> "non-recoverable read errors per bits read", so at least in the data 
> sheet nothing has really changed in the error rate aspect.
> 

Based on my experience, I am not sure how sensible that parameter is 
without a time constraint added to it, unless the parameter applies to 
the underlying patter, and means it is still correctable and does not 
represent a error reported back by the disk to the user.

Bit errors seem more likely the longer a sector has set since being 
written.  I would be not expect to see errors if you read the entire 
disk, and then reread it 1x a day for a year, but if you read the disk 
once, let it sit spinning for a year without any reads and read it 
again, this will almost certainly get a read error.    When you keep 
rereading it, when the bits start to go bad the disk should move it 
long before data loss happens, but if you only read it 1x a year, it 
is likely that when you find the data bad there will be too many bad 
bits, beyond being able to correct it.




