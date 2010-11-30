From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID and Fakeraid
Date: Wed, 1 Dec 2010 09:25:08 +1100
Message-ID: <20101201092508.7023f974@notabene.brown>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>
	<4CF55680.5010703@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF55680.5010703@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Nov 2010 14:54:40 -0500 Phillip Susi <psusi@cfl.rr.com> wrote:

> On 11/25/2010 5:26 AM, John Sheu wrote:
> > What's the preferred way to differentiate BIOS fakeraid from regular
> > software mdraid?
> 
> The only way I know of is detecting that it is a dmraid device as
> opposed to md, which is why grub does it that way.  This worked well in
> the past when each tool exclusively handled one type of raid.
> 
> > I ask this as I'm booting with GRUB2 off a system that has one of those
> > Intel fakeraid chipsets.  As of a few months ago, the mdadm package has
> > supported these fakeraid setups, so the RAID array comes up as a /dev/md###
> > device.  This is unfortunate, as GRUB2 assumes that any device of the type
> > /dev/md### must be a pure software RAID device, and in
> > util/grub-setup.c:939, tries to install itself to the RAID members
> > individually:
> 
> For grub to support fakeraids activated by the md driver, it needs some
> way to find out that it is actually a fake raid, and not a software
> raid.  Adding linux-raid to Cc list to see if they can suggest a way of
> doing that.

My feeling is that grub just needs to be a bit more careful.

If the members of the md array are partitions, then installing itself in the
boot blocks of the devices holding those partitions always makes sense.

If the members of the md array are whole devices, then installing grub in
those devices might make sense depending on specific details of the
metadata.  The default should be that it doesn't make sense, but specific
cases do.
e.g. if the metadata (/sys/block/mdX/md/metadata_version) is 0.90 or 1.0, and
the array is RAID1, then grub should install itself in the *array*, not in
the devices.
If the metadata is 1.1, then grub cannot install itself
If the metadata is 1.2, then grub can install itself at the start
If the metadata is external:imsm then (I think) grub should install itself in
the array ... though there are some complexities there.

I often wonder why people who add knowledge of md to grub etc don't at least
let me know what they are doing in case I can see something obviously wrong
with their approach..

NeilBrown
