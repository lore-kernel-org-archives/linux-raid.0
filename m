From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 20:38:26 +0200
Message-ID: <20060526183826.GE8203@percy.comedia.it>
References: <Pine.LNX.4.44.0605261231460.20378-100000@coffee.psychology.mcmaster.ca> <1148663181.2836.11.camel@hendrix.hollabaugh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1148663181.2836.11.camel@hendrix.hollabaugh.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 26, 2006 at 11:06:21AM -0600, Craig Hollabaugh wrote:
>On Fri, 2006-05-26 at 12:45 -0400, Mark Hahn wrote:
>> I think the current situation is good, since there is some danger of 
>> going too far.  for instance, testing each partition to see whether 
>> it contains a valid superblock would be pretty crazy, right?  requiring
>> either the "auto-assemble-me" partition type, or explicit partitions 
>> given in a config file is a happy medium...
>> 
>
>I created my array in 1/2003, don't know versions of kernel or mdadm I
>was using then.
>
>In my situation over the past few days.
>  kernel 2.4.30 kicked non-fresh
>  kernel 2.6.11.8 kicked non-fresh
>  kernel 2.6.18.8 didn't mention anything, just skipped my 'linux'
>partitions
>
>These kernels auto-assemble prior to mounting /. So the kernel doesn't
>consult my 
>/etc/mdadm/mdadm.conf file. Is this correct? 
i strongly believe it is not correct to let kernel auto-assemble devices
kernel auto-assembly should be disable and activation should be handled
by mdadm only!

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
