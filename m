From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6
Date: Mon, 11 Nov 2002 15:05:21 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DD037B1.8050603@zytor.com>
References: <Pine.LNX.4.44.0211111740060.11681-100000@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:
> 	Hello Peter ,
> 
> On 11 Nov 2002, H. Peter Anvin wrote:
> 
>>Hi all,
>>I'm playing around with RAID-6 algorithms lately.  With RAID-6 I mean
>>a setup which needs N+2 disks for N disks worth of storage and can
>>handle any two disks failing -- this seems to be the contemporary
>>definition of RAID-6 (the originally proposed "two-dimensional parity"
>>which required N+2*sqrt(N) drives never took off for obvious reasons.)
> 
> 	Was there a discussion of the 'two-dimensional parity' on the
> 	list ?  I don't remember any (of course) .  But what other than
> 	98+2+10 ,  What was the main difficulty ?  I don't (personally)
> 	see any difficulty (other than managability/power/space) to the
> 	ammount of disks required .  Tia ,  JimL
>

No discussion of two-dimensional parity, but that was the originally
proposed RAID-6.  Noone ever productized a solution like that to the
best of my knowledge.  I don't know what you mean with "98+2+10", but
the basic problem is that with 2D parity, for N data drives you need
2*sqrt(N) redundancy drives, which for any moderate-sized RAID is a lot
(with 9 data drives you need 6 redundancy drives, so you have 67%
overhead.)  You also have the same kind of performance problems as
RAID-4 does, because the "rotating parity" trick of RAID-5 does not work
in two dimensions.  And for all of this, you're not *guaranteed* more
than dual failure recovery (although you might, probabilistically, luck
out and have more than that.)

P+Q redundancy, the current meaning of RAID-6, instead uses two
orthogonal redundancy functions so you only need two redundancy drives
regardless of how much data you have, and you can apply the RAID-5 trick
of rotating the parity around.  So from your 15 drives in the example
above, you get 13 drives worth of data instead of 9.

	-hpa



