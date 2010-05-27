From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please help.
Date: Thu, 27 May 2010 11:39:53 +0100
Message-ID: <4BFE4BF9.9060708@anonymous.org.uk>
References: <AANLkTimDAbGPqen2dW7wtpxMjSup0IK8kcdNEnskibw-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimDAbGPqen2dW7wtpxMjSup0IK8kcdNEnskibw-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Reniau <david.reniau@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/05/2010 02:03, David Reniau wrote:
> Dear Linux-RAID gurus,

That's very kind of you but I'm no guru, just a user like yourself, 
though perhaps with a little more experience and I've hung around here a 
while because I like to know what goes on inside the black box.

[...]
> Similarly, IF the default chunk size (64K) i've been using so far with
> mdadm happens to be different from the Thecus', would the above
> tune2fs -l /dev/md0 command deliver results identical to the above
> ones with the corrected Thecus chunk size applied via mdadm
> --assemble? Could this parameter modification be sufficient to get my
> RAID filesystem back and mountable?

I don't know if the tune2fs info will be identical but it would be 
similar. You'll need to --create the array again with the corrected 
chunk size, not just --assemble it, but yes this on its own might very 
well be enough to get your filesystem back.

Cheers,

John.

