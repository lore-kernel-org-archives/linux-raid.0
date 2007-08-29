From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: bug in --manage mode
Date: Wed, 29 Aug 2007 09:39:05 -0400
Message-ID: <46D576F9.2090205@tmr.com>
References: <op.txcknfdohy6b49@exelap>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.txcknfdohy6b49@exelap>
Sender: linux-raid-owner@vger.kernel.org
To: exe@agava.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

exe@agava.com wrote:
> Hello, I hit a bug in mdadm.
>
> According to "--manage --help" this must work, but it doesn't:
>
> -bash-3.2# mdadm --manage -a /dev/md2 /dev/sda3
> mdadm: /dev/sda3 does not appear to be an md device

I think that the "-a" is being parsed as "--auto" rather than "--add" in 
this case. I rarely use --manage, so I want to go look at the 2.6.3 
code, this is just a speculation at this point, but it does fit the 
behavior. Don't know why the "/dev/md2" doesn't generate an error if 
it's being parsed as something else, though.
>
> But this works fine:
> -bash-3.2# mdadm --manage --add   /dev/md2 /dev/sda3
> mdadm: re-added /dev/sda3
>
>
> The version is:
> LFS:root@~:mdadm --version
> mdadm - v2.6.2 - 21st May 2007

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

