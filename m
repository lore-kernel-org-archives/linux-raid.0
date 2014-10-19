From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Multiple drive failure after stupid mistake. Help needed
Date: Sun, 19 Oct 2014 19:06:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1410191905190.30853@uplift.swm.pp.se>
References: <54438839.9080309@stenborg.me> <alpine.DEB.2.02.1410191253010.30853@uplift.swm.pp.se> <5443B55C.7000208@stenborg.me>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5443B55C.7000208@stenborg.me>
Sender: linux-raid-owner@vger.kernel.org
To: Per-Ola Stenborg <per-ola@stenborg.me>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 19 Oct 2014, Per-Ola Stenborg wrote:

> I compiled the latest mdadm v3.3.2 - 21st August 2014
> running
> mdadm --assemble --force /dev/md0 /dev/sd[bcde]
> outputs
> mdadm: /dev/sdb is busy - skipping
> mdadm: /dev/sdc is busy - skipping
> mdadm: /dev/sdd is busy - skipping
> mdadm: /dev/sde is busy - skipping
>
> Strange. What does this mean? Is it flaged as in use in the kernel? The

Stop the array before you try to start it again.

Also consider upgrading to a newer kernel if there is a backports one 
(there should be for debian squeeze), a lot of things have happened since 
2.6.32.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
