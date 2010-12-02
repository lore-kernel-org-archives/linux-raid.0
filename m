From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Thu, 02 Dec 2010 17:13:42 -0500
Message-ID: <4CF81A16.2010606@cfl.rr.com>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>	<4CF55680.5010703@cfl.rr.com> <20101201092508.7023f974@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101201092508.7023f974@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/30/2010 5:25 PM, Neil Brown wrote:
> My feeling is that grub just needs to be a bit more careful.
> 
> If the members of the md array are partitions, then installing itself in the
> boot blocks of the devices holding those partitions always makes sense.
>
> If the members of the md array are whole devices, then installing grub in
> those devices might make sense depending on specific details of the
> metadata.  The default should be that it doesn't make sense, but specific
> cases do.
> e.g. if the metadata (/sys/block/mdX/md/metadata_version) is 0.90 or 1.0, and
> the array is RAID1, then grub should install itself in the *array*, not in
> the devices.

I don't think that is quite right.  For software raid, you can't
actually install to the array per se, since the bios does not know about
it; it only knows about the individual disks.  Therefore, grub needs to
be installed to the individual disk(s), and preferably on each member of
a raid 1 so you can still boot with a failed disk.  To do this, it needs
the embed area to place the core image into, which doesn't exist if the
array uses the whole disk instead of a partition in it.

In the case of fakeraid, the bios does know about it, so grub can and
does install itself into the array, but since this won't work with true
mdadm soft raid using the raw disks, grub needs to be able to tell the
difference.  Only seeing the members of the array are raw disks instead
of partitions is not enough information.
