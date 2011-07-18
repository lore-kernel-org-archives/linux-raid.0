From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 12:35:42 +0200
Message-ID: <j012fa$6k6$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E235984.2070704@5t9.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/07/2011 23:52, Lutz Vieweg wrote:
> David Brown wrote:
>> However, AFAIUI, you are wrong about TRIM being essential for the
>> continued high performance of SSDs. As long as your SSDs have some
>> over-provisioning (or you only partition something like 90% of the
>> drive), and it's got good garbage collection, then TRIM will have
>> minimal effect.
>
> I beg to differ.
>

Well, I don't have your experience here (I have a couple of 60G SSD's in 
RAID0, without TRIM, but that's hardly in the same class).  So I don't 
expect you to put much weight on my opinions.  But maybe it will give 
you reason for more testing.

> We are using SSDs in very much the way that Tom de Mulder intends,
> and from our extensive performance measurements over many months
> now I can say that (at least if you do have significant amounts
> of write operations) it _does_ make a lot of difference whether you
> periodically discard the unused sectors or not.
> (For us, the write performance measured to be about half as good
> when there are no free erase blocks available anymore.)
>

If there are no free erase blocks, then your SSD's don't have enough 
over-provisioning.  This is, after all, the whole point of having more 
physical flash than the logical disk size would suggest.  Depending on 
the quality of the SSD (more expensive ones have more 
over-provisioning), and the usage patterns (if you have lots of small 
random writes, you'll need more extra space), then you might have to 
"manually" over-provision the disk by only partitioning about 90% of the 
disk.  Of course, you must make sure that the remaining 10% is 
"discarded", or left untouched from new, and that you use the partition 
for your RAID and not the whole disk.

So now you have plenty of erase blocks at any time, and your write 
performance will be good.


TRIM, on the other hand, does not give you any extra free erase blocks. 
  If you think it does, you've misunderstood it.

TRIM exists to make garbage collection a little more efficient - when 
garbage collecting an erase block that contains TRIM'ed blocks, the 
TRIM'ed blocks don't need to be copied.  This saves a small amount of 
time in the copying, and allows slightly denser packing.  It may 
sometimes lead to saving whole erase blocks, but that's seldom the case 
in practice except when erasing large files.

If your disks are reasonably full, then TRIM will not help much because 
the garbage collection will be desperately trying to piece together 
small bits into complete erase blocks, and your performance will drop 
through the floor.  If you have plenty of overprovisioning, then the SSD 
still has lots of completely free erase blocks whenever it needs them.

If your filesystem re-uses (logical) blocks, then TRIM will not help. 
It is /always/ more efficient for the FS to simply write new data to the 
same block, rather than TRIM'ing it first.

TRIM is a very expensive command - it acts a bit like a write, but it is 
not a queued command.  Thus the block layer must wait for /all/ IO 
commands to have completed, then issue the TRIM, then wait for it to 
complete, and then carry on with new commands.  On some SSD's, it will 
(according to something I read) trigger garbage collection, which may 
slow down the SSD.  Even without that, the performance of most meta-data 
operations (such as delete) will drop considerably when they also need 
to do TRIM.

<http://people.redhat.com/jmoyer/discard/ext4_batched_discard/ext4_discard.html>

<http://lwn.net/Articles/347511/>

<http://www.realworldtech.com/beta/forums/index.cfm?action=detail&id=116034&threadid=115697&roomid=2>


On the other hand, your off-line batch TRIM during low use periods could 
well be a win.  The cost of these discards is not going to be an issue, 
and large batched discards are going to be far more useful to the SSD 
than small scattered ones.  I believe that there has been work on a 
similar system in XFS - I don't know what happened to that, or if there 
is any way to make it work in concert with md raid.


What will make a big difference to using SSD's in md raid is the 
sync/no-sync tracking.  This will avoid a lot of unnecessary writes, 
especially with a new array, and leave the SSD with more free blocks (at 
least until the disk is getting full of data).  It is also much higher 
up the things-to-do list, because it will be useful for all uses of md 
raid, and is a perquisite to general discard support.  (Strictly 
speaking it is not needed for SSD's that guarantee a zero return on 
TRIM'ed blocks - but only some SSD's give that guarantee.)


> Of course, you can only benefit from discards if your filesystem
> is not full (because then there is nothing to discard). But any
> kind of "garbage collection" by the SSD itself will not have the
> same effect, since it cannot know which blocks are in use by the
> filesystem.
>

Garbage collection will recycle blocks that have been overwritten.  The 
filesystem knows which logical blocks are in use, and which are free. 
Filesystems already heavily re-use blocks, in the aim of preferring 
faster outer tracks on HD's, and minimizing head movement.  So when a 
file is erased, there's a good chance that those same logical blocks 
will be re-used soon - TRIM is of no benefit in that case.

>> I think other SSD-optimisations, such as those in BTRFS, are much more
>> important.
>
> Actually, (apart from btrfs still being in development, not really
> ready for production use, yet), XFS (-o delaylog,barrier) performs
> better on our SSDs than btrfs - without any SSD-specific options.
>

btrfs is ready for some uses, but is not mature and real-world tested 
enough for serious systems (and its tools are still lacking somewhat). 
But more generally, different filesystems are faster and slower for 
different usage patterns.

One SSD optimisation that many filesystems could implement is to be less 
concerned about fragmentation.  Most modern filesystems go out of their 
way to try to reduce fragmentation, which is great for HD use.  But on 
SSD's, you should be happy to fragment files if it promotes re-use of 
erased blocks, as long as fragments aim to fill complete erase blocks 
(in size and alignment).


> What is really an important factor for SSD performance: The controller.
> The same SSDs perform with significantly lower latency for us when
> connected to SATA controller channels than when connected to SAS
> controllers (and they perform abysmal when used as hardware-RAID
> constituents, in comparison).

That is /very/ interesting to know, and is a data point I haven't read 
elsewhere (though I knew about poor performance of hardware RAID with 
SSD).  Thanks for sharing that.


>
> Regards,
>
> Lutz Vieweg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>


