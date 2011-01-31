From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: Software RAID and Fakeraid
Date: Mon, 31 Jan 2011 12:03:49 -0500
Message-ID: <20110131170349.GR343@caffeine.csclub.uwaterloo.ca>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>
	<4CF55680.5010703@cfl.rr.com>
	<20101201092508.7023f974@notabene.brown>
	<4CF81A16.2010606@cfl.rr.com>
	<20101203123615.6edce071@notabene.brown>
	<4CF860EB.7010005@cfl.rr.com>
	<20101209094354.4c6aaa93@notabene.brown>
	<4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
Content-Disposition: inline
In-Reply-To: <4D46E6D7.2000205@cfl.rr.com>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Sender: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, John Sheu <john.sheu@gmail.com>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 11:44:07AM -0500, Phillip Susi wrote:
> I know you went on vacation over the new year, but it has been about two
> months now so I figured I would try to revive this conversation.
> 
> Having collected my thoughts, this is what I propose:
> 
> I believe that right now, grub recognizes an md device that is built on
> partitions, and installs to the underlying disks.  When the device is
> built on the whole disks, it needs to divide into two categories:
> 
> 1)  Native md metadata.  Grub should ask mdadm for a suitable location
> to embed the core image on each component disk.  This can be satisfied
> with a 32kb area at the end ( or maybe the beginning ) of the disk that
> is not used by the array ( or the metadata ).  This will work for all
> native formats except for 1.1, for the obvious reason that it is using
> the boot block.
> 
> 2)  Other metadata formats.  Either assume or explicitly be told by
> mdadm that these formats are fakeraid and thus understood by the bios
> int 13.  Grub installs to the array as a whole, just like it does today
> when they are handled by dmraid.  If it is known that it is not bios
> supported, then error out.  In the future this could be supported by
> creating additional grub modules that understand those metadata formats.
> 
> One question that needs answered for method 1 is what should the
> partition table look like?  Should grub, or maybe mdadm, create a
> protective mbr when using the whole disk, similar to the one used with GPT?

I think in the case of BIOS raid, the bios will boot from the raid
device, so installing to the boot area of the raid device makes sense
(/dev/mapper/whatever or similar).

In the case of software md raid on partitions, the BIOS boots from the
boot area of the disks directly, so installing to all member disks makes
sense (/dev/sda, /dev/sdb, etc).

If you do software md raid on whole disks, I am not even sure if the
BIOS could boot from that, since there won't be a partition table, no
partition marked bootable (which some BIOSs requrie), sector 0 may not
even contain boot code.  Not sure there is anyway whole device software
raid makes sense for a bootable drive at all.  It makes sense for data
drives perhaps.  I just don't see this as a candidate for booting at all.

Now that's all assuming x86 BIOS based booting.  For other systems
supported by grub, things could be different perhaps.

-- 
Len Sorensen
