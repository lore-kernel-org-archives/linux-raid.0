From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Typical RAID5 transfer speeds
Date: Sat, 19 Dec 2009 11:43:20 +0000
Message-ID: <4B2CBC58.5020902@anonymous.org.uk>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com> <200912190205.04407.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912190205.04407.bs_lists@aakef.fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/12/2009 01:05, Bernd Schubert wrote:
> On Saturday 19 December 2009, Matt Tehonica wrote:
>> I have a 4 disk RAID5 using a 2048K chunk size and using XFS
> 
> 4 disks is a bad idea. You should have 2^n data disks, but you have 2^1 + 1 = 
> 3 data disks. As parity information are calculated in the power of two and 
> blocks are written in the power of two

Sorry, but where did you get that from? p = d1 xor d2 xor d3 has nothing 
to do with powers of two, and I'm sure blocks are written whenever they 
need to be, not in powers of two.

> you probably have read operations, 
> when you only want to write.

That will depend on how much data you're trying to write. With 3 data 
discs and a 2M chunk size, writes in multiples of 6M won't need reads. 
Writing a 25M file would therefore write 4 stripes and need to read to 
do the last 1M. With 4 data discs, it'd be 8M multiples, and you'd write 
3 stripes and need a read to do the last 1M. No difference.

Cheers,

John.

