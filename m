From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID and Fakeraid
Date: Fri, 3 Dec 2010 12:36:15 +1100
Message-ID: <20101203123615.6edce071@notabene.brown>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>
	<4CF55680.5010703@cfl.rr.com>
	<20101201092508.7023f974@notabene.brown>
	<4CF81A16.2010606@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF81A16.2010606@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 02 Dec 2010 17:13:42 -0500 Phillip Susi <psusi@cfl.rr.com> wrote:

> On 11/30/2010 5:25 PM, Neil Brown wrote:
> > My feeling is that grub just needs to be a bit more careful.
> > 
> > If the members of the md array are partitions, then installing itself in the
> > boot blocks of the devices holding those partitions always makes sense.
> >
> > If the members of the md array are whole devices, then installing grub in
> > those devices might make sense depending on specific details of the
> > metadata.  The default should be that it doesn't make sense, but specific
> > cases do.
> > e.g. if the metadata (/sys/block/mdX/md/metadata_version) is 0.90 or 1.0, and
> > the array is RAID1, then grub should install itself in the *array*, not in
> > the devices.
> 
> I don't think that is quite right.  For software raid, you can't
> actually install to the array per se, since the bios does not know about
> it; it only knows about the individual disks.  Therefore, grub needs to
> be installed to the individual disk(s), and preferably on each member of
> a raid 1 so you can still boot with a failed disk.  To do this, it needs
> the embed area to place the core image into, which doesn't exist if the
> array uses the whole disk instead of a partition in it.

If the array uses 0.90 or 1.0 metadata and comprises whole-disks (not
partitions), and if the array is RAID1, then each device (except for the very
end) contains exactly the same data as the whole array.
If you install grub to the array, then it will be installed onto all of the
(active) devices in the array.  And that is certainly the easiest way to
write to all device.

It won't write to 'spares', so if you want to be able to boot from spares as
well .... but I'm not sure that makes sense anyway.

> 
> In the case of fakeraid, the bios does know about it, so grub can and
> does install itself into the array, but since this won't work with true
> mdadm soft raid using the raw disks, grub needs to be able to tell the
> difference.  Only seeing the members of the array are raw disks instead
> of partitions is not enough information.

Completely agree.  As I said, there are only some cases where you can boot
from an array which uses whole-disks.
One case if in the bios understands the array, such as Intel bios's with IMSM
metadata, or possibly some bioses with DDF metadata.
Another case is RAID1 which starts at the beginning of the device, where the
bios doesn't need to know about the RAID.

NeilBrown
