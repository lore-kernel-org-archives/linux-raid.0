From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 13:32:16 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4182A8D0.6050000@zytor.com>
References: <200410292028.i9TKS6N14580@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410292028.i9TKS6N14580@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Jim Paris' <jim@jtan.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Could you translate this into English?
> P' = P + D_n + D_n'
> Q' = Q + g^n * D_n + g^n * D_n'
> 
> I understand this much:
> P    =old parity
> D_n  =old data block(s)
> P'   =new parity
> D_n' =new data block(s)
> 
> But is "+" = xor?
> 
> I am lost on this one:
> Q' = Q + g^n * D_n + g^n * D_n'
> 
> With the parity (xor) it can be done by the bit, so an example is easy.
> Can Q be done by the bit, and if so, could you give an example?
> 
> If it takes more than 10 minutes, just tell me it is magic! :)

See my paper on the subject:

http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

> Also, on a related subject....
> I have a 14 disk RAID5 with 1 spare.
> Once RAID6 seems safe and stable I had hoped to convert to a 15 disk RAID6.
> Is 15 disks too much for RAID6?
> Any idea what a reasonable limit would be?
> 

The limit is 27 disks total, it's imposed by the md system rather than RAID-6; 
RAID-6's inherent limit is 254+2 (see, again, the paper.)

	-hpa
