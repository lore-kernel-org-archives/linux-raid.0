From: Avi Kivity <avi@argo.co.il>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 20:20:50 +0300
Message-ID: <4672CA72.1010505@argo.co.il>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <Pine.LNX.4.64.0706151823360.32724@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706151823360.32724@fbirervta.pbzchgretzou.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On Jun 15 2007 14:10, Avi Kivity wrote:
>   
>> Some things are not achievable with block-level raid.  For example, with
>> redundancy integrated into the filesystem, you can have three copies for
>> metadata, two copies for small files, and parity blocks for large files,
>> effectively using different raid levels for different types of data on
>> the same filesystem.
>>     
>
> Sounds like you want RAIF, not RAID.
>
>   

If you mean taking a bunch of single-disk filesystems and layering
another filesystem on top, then no.  The underlying filesystems will
only serve as object allocators, and all the directory hierarchy,
journalling, and other capabilities will end up as overhead.  Fairly
significant overhead, too -- I've once worked on a similar environment. 
Performance sucked until the underlying filesystems were removed.

Abstraction layers are good for dividing large problems, but they have
their costs.  Consider NUMA for example: you can treat it as a large
blob of memory, but much performance can be gained of you don't. 
Similarly, with disks, you can put them in a big RAID and treat them as
a large disk, but if you don't, there are large rewards.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

