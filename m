From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 09:03:26 +1100
Message-ID: <4AF891AE.8090300@eyal.emu.id.au>
References: <4AF4C247.6050303@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF4C247.6050303@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks everyone,

I wish to narrow down the issue to my question
	Are there situations known to cause this without an actual hardware failure?

Meaning, are there known *software* issues with this configuration
	2.6.30.5-43.fc11.x86_64, ext3, raid5, sata, Adaptec 1430SA
that can lead to a mismatch?

It is not root, not swap, has weekly smartd scans and weekly (different days) raid
'check's. Only report is a growing mismatch_cnt.

I noted the raid1 as mentioned in the thread.

cheers
	Eyal

Eyal Lebedinsky wrote:
> For years I found the mismatch_cnt rising regularly every few weeks and 
> could
> never relate it to any evens.
> 
> I since replaced the computer, installed fedora 11 (was very old debian)
> and only kept the array itself (ext3 on 5x1TB raid5). I had the raid
> 'repair'ed to get it to mismatch_cnt=0.
> 
> I thought that I saw the last of these. I had a good run for almost three
> months, then last week I saw the first mismatch_cnt=184. It was still so
> on this weekly 'check'.
> 
> I cannot see any bad event logged.
> 
> Are there situations known to cause this without an actual hardware 
> failure?
> I know that this came up in the past (often) but I see little recent
> discussion and wonder what the current status is.
> 
> For the last 6 weeks (my uptime) the machine runs
>     2.6.30.5-43.fc11.x86_64 #1 SMP
> 
> The raid holds data (no root or swap) used mostly as DVR (nothing heavy).
> smartd checks each week and so far no errors. The disks are modern 1yo
> "SAMSUNG HD103UJ".
> 
> TIA

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
