From: Harald Nikolisin <hochglanz@gmail.com>
Subject: Fwd: Re: Device utilization with RAID-1
Date: Thu, 18 Aug 2011 02:26:17 +0200
Message-ID: <4E4C5C29.6040303@googlemail.com>
Reply-To: hochglanz@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

I didn't want to complain in general about SW RAID-1 performance. I
simply think something is wrong with my setup and I have currently no
idea how to improve.

The basic questions (where I did not find an answer, neither in FAQ's
nor in forum discussions) are.
a) Is it normal that the hard drives show an permanent utilization
(around 20%) without any noticeable actions on the computer?
b) Should (as long as no resync happens) the state of mdadm active or clean?

cheers,
  harald

well, I have only 2 hard drives and no space for more..

Am 16.08.2011 03:29, schrieb Roberto Spadim:
> try raid10 far layout
> 
> 2011/8/15 Harald Nikolisin <hochglanz@gmail.com
> <mailto:hochglanz@gmail.com>>
> 
>     Since a long time I'm unhappy with the performance of my RAID-1 system.
>     Investigation with atop and iostat unveils that the disk utilization is
>     always on a certain level although nothing happens on the system. In the
>     case of reading or writing files the utilization boosts always to 100%
>     for a long time. Very ugly examples are "Firefox starting" or "zypper
>     updates".
>     That is snapshot of the output of iostat:
> 
> 
>     Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
>     avgrq-sz avgqu-sz   await  svctm  %util
>     sda               0,00     0,00    0,00    7,33     0,00    43,33
>     5,91     0,33   43,18  33,32  24,43
>     sdb               0,00     0,00    0,00    7,33     0,00    43,33
>     5,91     0,35   45,59  39,73  29,13
>     md0               0,00     0,00    0,00    0,67     0,00     5,33
>     8,00     0,00    0,00   0,00   0,00
>     md1               0,00     0,00    0,00    0,33     0,00     5,33
>     16,00     0,00    0,00   0,00   0,00
>     md2               0,00     0,00    0,00    0,33     0,00     1,00
>     3,00     0,00    0,00   0,00   0,00
>     md3               0,00     0,00    0,00    0,00     0,00     0,00
>     0,00     0,00    0,00   0,00   0,00
>     md4               0,00     0,00    0,00    0,00     0,00     0,00
>     0,00     0,00    0,00   0,00   0,00
>     md5               0,00     0,00    0,00    0,33     0,00     0,67
>     2,00     0,00    0,00   0,00   0,00
> 
>     I checked with mdadm if a resync happens or so, but this is not the
>     case. The state says "active" on all RAID devices - btw. what is the
>     difference to "clean" ?
> 
>     thanks for any hints,
>      harald
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> -- 
> Roberto Spadim
> Spadim Technology / SPAEmpresarial


