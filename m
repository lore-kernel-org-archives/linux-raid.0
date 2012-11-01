From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Thu, 01 Nov 2012 17:41:28 +0100
Message-ID: <5092A638.8060307@hesbynett.no>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no> <50916132.3010405@curtronics.com> <50918432.906@hesbynett.no> <5091D63E.1080007@curtronics.com> <50922FA4.7070702@hesbynett.no> <20121101150144.6BA1D2005D0@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121101150144.6BA1D2005D0@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Curtis J Blank <curt@curtronics.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/11/12 16:01, Wolfgang Denk wrote:
> Dear David,
>
> In message <50922FA4.7070702@hesbynett.no> you wrote:
>>
>> If you make your big raid1 pair an LVM physical volume, you can split it
>> into logical volumes as and when you want, and re-size them whenever
>> necessary.  Note, however, that the unpartitioned space within the LVM
>> physical volume is still "used" as far as the SSD is concerned, since
>> the initial raid1 synchronisation has written to it.  So only space
>
> What if the creation of the array was done with "--assume-clean" ?
>

I think in that case you will avoid writing to the disks - but you will 
have trouble if you try to check or scrub the disk, or if it runs a 
resync due to an unclean shutdown.

I suppose new SSDs may consistently return all zeros or all ones when 
read - so if they are consistent then you should be fine to 
"--assume-clean" (for raid1).

However, I think that resyncs currently write data to the second drive 
without checking if it is out of sync, which would put you back where 
you started.  (I believe there are patches on their way to change that 
behaviour to save writes on SSDs - but re-writing everything on the 
second disk is the fastest resync method for normal hard disk setups.)


