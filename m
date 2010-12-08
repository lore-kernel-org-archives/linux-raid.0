From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID and Fakeraid
Date: Thu, 9 Dec 2010 09:43:54 +1100
Message-ID: <20101209094354.4c6aaa93@notabene.brown>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>
	<4CF55680.5010703@cfl.rr.com>
	<20101201092508.7023f974@notabene.brown>
	<4CF81A16.2010606@cfl.rr.com>
	<20101203123615.6edce071@notabene.brown>
	<4CF860EB.7010005@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF860EB.7010005@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 02 Dec 2010 22:15:55 -0500 Phillip Susi <psusi@cfl.rr.com> wrote:

> On 12/02/2010 08:36 PM, Neil Brown wrote:
> > If the array uses 0.90 or 1.0 metadata and comprises whole-disks (not
> > partitions), and if the array is RAID1, then each device (except for the very
> > end) contains exactly the same data as the whole array.
> > If you install grub to the array, then it will be installed onto all of the
> > (active) devices in the array.  And that is certainly the easiest way to
> > write to all device.
> >
> > It won't write to 'spares', so if you want to be able to boot from spares as
> > well .... but I'm not sure that makes sense anyway.
> 
> Yes, for a raid1 with no spares, installing to the array is equivalent 
> to installing to each individual disk, but it helps avoid confusion to 
> ignore this fact and remain thinking in terms of the physical disks, at 
> least as they appear to the bios.
> 
> > Completely agree.  As I said, there are only some cases where you can boot
> > from an array which uses whole-disks.
> > One case if in the bios understands the array, such as Intel bios's with IMSM
> > metadata, or possibly some bioses with DDF metadata.
> > Another case is RAID1 which starts at the beginning of the device, where the
> > bios doesn't need to know about the RAID.
> 
> So how do we tell the difference?  Right now grub uses the rule of 
> dmraid = bios aware, so install to the raid device, and mdadm = software 
> raid, so install to the component devices individually.  You have noted 
> that in same cases both methods will produce the same results, but grub 
> needs to be certain that whichever method it chooses will work, whether 
> or not either one will.  To do this, it needs to install to the raid 
> device if and only if it is a bios recognized fakeraid.

Could you install to both??  Maybe not...

What exactly needs to be installed?  My understanding is that you need to
install a boot block which cal load a larger chunk from some fixed location,
and the larger chunk understands raid and filesystems and everything and can
figure out what to do.
Where do you install that larger chunk??

I'd be happy to get mdadm to provide useful information for grub if I knew
what information was needed, and knew that grub would use it.
It would probably be an extension to "mdadm --detail --export".
It could:
 - list devices on which it was safe to install a boot block, which might be
   the array, or might be components, or might be nothing
 - list and offset/size on each device where there is some spare space for
   the second stage (or is that 'stage1.5'??) could be stored safely.
 - report an offset for mapping from 'the array' to 'individual device' when
   that makes sense (i.e. raid1 and maybe linear).
 - anything else required.

I'd really rather if grub didn't assume that 'md' meant something specific,
but rather asked mdadm what it should do with a given 'md' device.

So if you (or someone) can tell me what grub needs and how it would use it,
and undertakes to teach grub to ask mdadm and make use of the answers, and to
continue the dialogue if it turns out that our first design approach doesn't
quite work right,  then I will very happily get the required functionality
into mdadm very promptly.

Thanks,
NeilBrown
