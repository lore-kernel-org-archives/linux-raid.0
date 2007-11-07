From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: telling mdadm to use spare drive.
Date: Thu, 08 Nov 2007 08:13:19 +1300
Message-ID: <47320E4F.3070308@sauce.co.nz>
References: <20071104170502.6db7fcb1@absurd>	<87bqa6jtxc.fsf@informatik.uni-tuebingen.de> <20071107182602.61162e00@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071107182602.61162e00@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Goswin von Brederlow said:     (by the date of Wed, 07 Nov 2007 10:17:51 +0100)
> 
> 
>>Strange. That is exactly how I always do it and it always just worked.
>>mdadm should start syncing on any spare as soon as a disk fails or you
>>add the spare to a degraded array afaik. No special "start now"
>>interaction needed.
> 
> 
> Thanks for your confirmation. I cannot explain this behaviour - I
> just started using mdadm. If anybody here wants, I can remove the
> drive and add this again, to see if I can duplicate this "bug" (?).
> If so - then tell me what debug information you do need and I will
> give it to you.

What kernel and RAID level is this?

If it's RAID 1, I seem to recall there was a relatively recently fixed 
bug for this.

Regards,

Richard
