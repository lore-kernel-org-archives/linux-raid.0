From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: linux disk access when idle
Date: Sat, 22 Aug 2009 16:04:44 -0500
Message-ID: <20090822210443.GA12033@sewage>
References: <20090820163522.GA29215@sewage> <4A8D99D9.2090806@sauce.co.nz> <20090821165935.GA18915@sewage> <4A8ED2FC.2070700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A8ED2FC.2070700@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 21, 2009 at 01:01:48PM -0400, Ric Wheeler wrote:
> On 08/21/2009 12:59 PM, Matt Garman wrote:
>>>> So what I'm trying to figure out is, what is causing the disk
>>>> access?  It could be any one of:
>>>>
>>>>      - Kernel
>>>>      - RAID subsystem (i.e. md)
>>>>      - XFS filesystem
>>>>      - NFS
>>>>      - Samba
>>>>      - ???
>>>>        
>>> Are you running smartd? It polls the drives every 30minutes.
>>    
> I think that you can use blktrace to see who is issuing the IO's
> that  spin up your drives....

For five hours today, I ran blktrace on md1 as well as the drives
that make up md1 (sd[a-d]).  I also enabled block dump via

    echo 1 > /proc/sys/vm/block_dump

Nothing.  Neither block_dump nor blktrace recorded anything on md1
or sd[abcd].  I caught one instance where the heads parked (I both
heard them park as well as saw the power meter show the 10 watt
drop).  They only stayed parked for about five minutes.  Yet neither
blktrace nor block_dump caught anything.

I'm going to try lm-profiler now (from the laptop-mode-tools
package), but I have low expectations.

I'm beginning to think that it's not even direct access to the
drives that cause the heads to unpark, e.g. perhaps even activity on
my system drive (a compact flash card connected to the PATA port)
prevents the data drives from parking their heads.

