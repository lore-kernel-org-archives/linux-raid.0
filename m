From: Avi Kivity <avi@argo.co.il>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 14:10:35 +0300
Message-ID: <467273AB.9010202@argo.co.il>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18034.3676.477575.490448@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>   
>> while I consider zfs to be ~80% hype, one advantage it could have (but I 
>> don't know if it has) is that since the filesystem an raid are integrated 
>> into one layer they can optimize the case where files are being written 
>> onto unallocated space and instead of reading blocks from disk to 
>> calculate the parity they could just put zeros in the unallocated space, 
>> potentially speeding up the system by reducing the amount of disk I/O.
>>     
>
> Certainly.  But the raid doesn't need to be tightly integrated
> into the filesystem to achieve this.  The filesystem need only know
> the geometry of the RAID and when it comes to write, it tries to write
> full stripes at a time.  If that means writing some extra blocks full
> of zeros, it can try to do that.  This would require a little bit
> better communication between filesystem and raid, but not much.  If
> anyone has a filesystem that they want to be able to talk to raid
> better, they need only ask...
>   

Some things are not achievable with block-level raid.  For example, with
redundancy integrated into the filesystem, you can have three copies for
metadata, two copies for small files, and parity blocks for large files,
effectively using different raid levels for different types of data on
the same filesystem.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

