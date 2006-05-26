From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 13:30:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605261327520.20378-100000@coffee.psychology.mcmaster.ca>
References: <1148663181.2836.11.camel@hendrix.hollabaugh.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1148663181.2836.11.camel@hendrix.hollabaugh.com>
Sender: linux-raid-owner@vger.kernel.org
To: Craig Hollabaugh <craig@hollabaugh.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>> I created my array in 1/2003, don't know versions of kernel or mdadm I
> was using then.

did you have /etc/*md* related config files?  some distros use
them to assemble during boot (not quite the same as 0xfd auto-assembly,
but still pretty "auto").

> In my situation over the past few days.
>   kernel 2.4.30 kicked non-fresh
>   kernel 2.6.11.8 kicked non-fresh
>   kernel 2.6.18.8 didn't mention anything, just skipped my 'linux'
> partitions
>
> These kernels auto-assemble prior to mounting /. So the kernel doesn't
> consult my
> /etc/mdadm/mdadm.conf file. Is this correct?

yes - the kernel traditionally doesn't, of its own accord, read files.
most stuff under /etc are inputs to user-level tools that run during 
boot to instruct the kernel how to configure things.  distros have,
in the past, had boot-time scripts that would run mdadm and thus 
read your mdadm.conf (or the raid config files that predate mdadm...)

so perhaps your observed change in behavior had to do with distro changes...

