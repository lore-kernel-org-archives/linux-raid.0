From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Is the LSI SAS9211-8i still the go to HBA?
Date: Tue, 3 Oct 2017 10:06:11 +1100
Message-ID: <b421f5f2-16fe-1115-02cb-0575454eb2d7@eyal.emu.id.au>
References: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au>
 <edaf46e4-8f70-1471-3353-d67deeb4d03a@eyal.emu.id.au>
 <alpine.DEB.2.20.1710021533340.31961@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1710021533340.31961@uplift.swm.pp.se>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/10/17 00:41, Mikael Abrahamsson wrote:
> On Mon, 2 Oct 2017, Eyal Lebedinsky wrote:
> 
>> I will not use SSDs with the card, so handling 8 HDDs should not be a stretch for either one?
> 
> I know people who use 9211-8i with 36 drives via SAS expanders. With HDDs, this isn't typically a problem, it's mostly a bandwidth problem than IOPS problem.
> 
> If I were to deploy an 8 drive machine, 9211-8i or cards with similar LSI 2008 chips, would be my first choice (since it's cheap and is widely used).
> 
> There has been some firmware trouble with it. I believe P20 had trouble. P19 seems to work fine.
> 
> https://www.centos.org/forums/viewtopic.php?t=50032

Thanks Mikael,

Read it and did more searching. The latest I found is this (a year old):
   https://forums.servethehome.com/index.php?threads/tutorial-updating-ibm-m1015-lsi-9211-8i-firmware-on-uefi-systems.11462/
and it closes by saying:
   P20 Myth
     There are many revisions of the P20 firmware. The first few had lots of bugs
     so people suggest avoiding it. However, someone pointed out that all versions
     that are 20.00.04 and after are fine. I using the current latest version 20.00.07
     and have had no problems. Did a full scrub, bonnie benchmark, copied large files
     and played them back with no errors.

I was looking for a URL to download the necessary files but the official sites removed
them. The one linked from the above blog contains the files, is it reliable?
   https://www.mediafire.com/download/6mtie10d9ud6675/LSI-9211-8i.zip
It contains:
   $ strings -a 2118it.bin | head -n 1
   @(#)MPTFW-20.00.07.00-IT
   $ md5sum 2118it.bin
   8d8cd74b8080bbe100aedb8dff092301  2118it.bin

Is there a known good/safe site for these files?

Regards

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
