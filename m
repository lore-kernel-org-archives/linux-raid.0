From: Phil Turmel <philip@turmel.org>
Subject: Re: Reassembling Raid5 in degraded state
Date: Tue, 14 Jan 2020 11:40:20 -0500
Message-ID: <a34d1a67-1d10-60fe-5922-42d27ce8dc6c@turmel.org>
References: <13b11d17-a23a-3063-70cb-de63d9fa7d09@inview.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13b11d17-a23a-3063-70cb-de63d9fa7d09@inview.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Christian Deufel <christian.deufel@inview.de>, linux-raid <linux-raid@vger.kernel.org>, Wols Lists <antlists@youngman.org.uk>
List-Id: linux-raid.ids

On 1/14/20 6:28 AM, Christian Deufel wrote:
> Hey Wol
> 
>  > My plan now would be to run mdadm --assemble --force /dev/md3 with 3
>  > disk, to get the Raid going in a degraded state.
> 
>  >Yup, this would almost certainly work. I would recommend overlays and
>  >running a fsck just to check it's all okay before actually doing it on
>  >the actual disks. The event counts say to me that you'll probably lose
>  >little to nothing.
> 
> So as I was trying to reassemble my Raid it crashed again. But this time 
> sdc vanished.

I've experienced the problem of various disks disappearing when you 
attempt to use them.  It has always been some kind of power supply 
problem in my cases.

Consider relocating these drives to another box to continue your 
recovery efforts.

Phil
