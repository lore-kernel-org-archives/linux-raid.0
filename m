From: Gerd Knops <gerti@bitart.com>
Subject: Re: Poor RAID5 performance on new SMP system
Date: Mon, 18 Oct 2004 00:37:21 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C8650B2A-20C7-11D9-AECB-00039359D1F2@bitart.com>
References: <20041018015803.M50347@liquid-nexus.net>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041018015803.M50347@liquid-nexus.net>
To: Marc <linux-raid@liquid-nexus.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Oct 17, 2004, at 21:11, Marc wrote:

> Hi,
> I recently upgraded my file server to a dual AMD 2800+ on a Tyan Tiger 
> MPX
> motherboard. The previous server was using a PIII 700 on an Intel 440BX
> motherboard. I basically just took the IDE drives and their controllers
> across to the new machine. The strange thing is that the RAID-5 
> performance
> is worse than before! Have a look at the stats below:
>

[..]

>          State : dirty, no-errors
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
>

Unless I am missing something, a disk is missing and the RAID runs in 
degraded (=slower) mode.

Gerd

