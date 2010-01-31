From: Asdo <asdo@shiftmail.org>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sun, 31 Jan 2010 17:34:23 +0100
Message-ID: <4B65B10F.6060501@shiftmail.org>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
 <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk>
 <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
 <4B65AD05.5050000@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B65AD05.5050000@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> On 30/01/2010 21:33, Mikael Abrahamsson wrote:
> [...]
>> I think the 4k sector size on WD20EARS (for instance) is supposed to 
>> add more ECC information but I'm not sure how this will affect the 
>> 10^14 error rate.
>
> iirc part of the point of moving to 4K sectors is to improve the error 
> correction to something like 1 in 10^20 or 22 without losing storage 
> density, partly by using what was lost before in inter-sector gaps and 
> partly because you can do better with more bits of ECC over more data.
I remember the other way around: the purpose of 4k was to keep the same 
error rate while saving storage space
You have links?
I got my impression from here http://lwn.net/Articles/322777/ but it's 
not explicitly written
> Frankly I wish they'd sacrificed a little storage density and improved 
> the error rate a long time ago.
Me too

Anyway I think you'll never know how many ECC bits a brand uses. It's 
not declared. They just declare the estimated error rate which I think 
is the estimate of how likely is a surface defect and how likely is that 
to be fixable by the ECC algorithm. So the discussion has no real meaning...

There is another maybe more important factor: how likely is silent data 
corruption. IIRC reed-solomon algorithms can be tuned (at the same 
number of bits) for more correction and less detection of errors, or for 
more detection and less correction. If the detection is insufficient, 
you get garbage data when reading the sector, but the disk does not 
return a read error so the OS takes it as good data. Every 1 bit of 
error correction costs the same number of ECC bits as 2 bits of error 
detection. The disk makers never tell you how their algorithm is balanced.
