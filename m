From: Avi Kivity <avi@argo.co.il>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 20:23:01 +0300
Message-ID: <46741C75.3000003@argo.co.il>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>	<18034.3676.477575.490448@notabene.brown>	<467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18035.3009.568832.785308@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>>>   
>>>       
>> Some things are not achievable with block-level raid.  For example, with
>> redundancy integrated into the filesystem, you can have three copies for
>> metadata, two copies for small files, and parity blocks for large files,
>> effectively using different raid levels for different types of data on
>> the same filesystem.
>>     
>
> Absolutely.  And doing that is a very good idea quite independent of
> underlying RAID.  Even ext2 stores multiple copies of the superblock.
>
> Having the filesystem duplicate data, store checksums, and be able to
> find a different copy if the first one it chose was bad is very
> sensible and cannot be done by just putting the filesystem on RAID.
>   

It would need to know a lot about the RAID geometry in order not to put
the the copies on the same disks.

> Having the filesystem keep multiple copies of each data block so that
> when one drive dies, another block is used does not excite me quite so
> much.  If you are going to do that, then you want to be able to
> reconstruct the data that should be on a failed drive onto a new
> drive.
> For a RAID system, that reconstruction can go at the full speed of the
> drive subsystem - but needs to copy every block, whether used or not.
> For in-filesystem duplication, it is easy to imagine that being quite
> slow and complex.  It would depend a lot on how you arrange data,
> and maybe there is some clever approach to data layout that I haven't
> thought of.  But I think that sort of thing is much easier to do in a
> RAID layer below the filesystem.
>   

You'd need a reverse mapping of extents to files.  While maintaining
that is expensive, it brings a lot of benefits:

- rebuild a failed drive, without rebuilding free space
- evacuate a drive in anticipation of taking it offline
- efficient defragmentation

Reverse mapping storage could serve as free space store too.

> Combining these thoughts, it would make a lot of sense for the
> filesystem to be able to say to the block device "That blocks looks
> wrong - can you find me another copy to try?".  That is an example of
> the sort of closer integration between filesystem and RAID that would
> make sense.
>   

It's a step forward, but still quite limited compared to combining the
two layers together.  Sticking with the example above, you still can't
have a mix of parity-protected files and mirror-protected files; the
RAID decides that for you.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

