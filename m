From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 5 Grow
Date: Mon, 25 Jun 2007 12:39:17 -0400
Message-ID: <467FEFB5.2010608@tmr.com>
References: <467C9E86.5070505@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467C9E86.5070505@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie wrote:
> I will soon be adding another same sized drive to an existing 3 drive 
> RAID 5 array.
>
> The machine is running Fedora Core 6 with kernel 2.6.20-1.2952.fc6 and 
> mdadm 2.5.4, both of which are the latest available Fedora packages.
>
> Is anyone aware of any obvious bugs in either of these that will 
> jeopardise this resize?
>
> I can compile and install later versions if required, but I'd rather 
> leave the system "standard" if I can.

I did a grow on RAID5 using an earlier FC6 setup, so I don't think you 
will have a problem.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

