From: Jim Santos <iluvgadgets@gmail.com>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 18:22:55 -0400
Message-ID: <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
	<519B9351.4050708@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519B9351.4050708@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for pointing out the initramfs problem.  I guess I should have
figured that out myself, since I've had to update initramfs in the
past, but it just totally slipped my mind.  And the strange device
numbering just threw me complete off track.

As far as how the devices got numbered that way in the first place, I
really don't know.  I assembled them and that is how it came out.
Since I was initially doing this to learn about SW RAID, I'm sure that
I made a rookie mistake or two along the way.

The reason that there are so many filesystems is that I wanted to try
to minimize any loss if one of them got corrupted.  Maybe it isn't the
best way to do it, but it made sense to me at the time.  I am more
than open to suggestions.

When I started doing this to better understand SW RAID, I wanted to
make things as simple as possible so I didn't use the LVM.  That and
it didn't seem like I would gain much by using it.  Al I need is
simple RAID1 devices I never planned on changing the layout other than
maybe increasing the size of the disks.  Maybe that flies in the face
of 'best practices', since you can be sure what your future needs
would be.  How would you suggest I set things up if I did use LVs?

/boot and / are on a separate disk on RAID1 devices with 1.x
superblocks.  At the moment, they are the only thing that aren't
giving me a problem :-)

Many thanks,

JIm




On Tue, May 21, 2013 at 11:31 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Jim,
>
> On 05/21/2013 08:51 AM, Jim Santos wrote:
>> Hi,
>> I recently upgraded my 2 disk RAID-1 array from 1.5TB to 2TB disks.
>> When I started I had 10 MD devices. Since the last partition was
>> small, I removed the filesystems and deleted the associated RAID
>> device. The I created two new devices and split the extra 500 GB
>> between them. Everything was good until I rebooted. Now two of the
>> raid devices are 'gone'.
>
> [snip /]
>
>> Notice the Preferred Minor numbers. It looks like the two new RAID
>> devices took over the devices with the highest minor numbers.
>
> Preferred minors are only used when assembling with kernel internal
> auto-assembly (deprecated), which only works on meta-data v0.90, and
> only if an initramfs is not present.  Boot-time assembly is otherwise
> governed by the copy of mdadm.conf in your initramfs.
>
> You appear to have failed to update your initramfs.  This is complicated
> by your failure to avoid mdadm's "fallback" minor numbers that are used
> when an array is assembled without an entry in mdadm.conf.
>
>> I don't know what I did to get into this situation, but could really
>> use some help getting out of it.
>
> mdadm is called by modern initramfs boot scripts to assemble raid
> devices as they are encountered.  If the given device is not a member of
> an array listed in mdadm.conf, mdadm picks the next unused minor number
> starting at 127 and counting down.  Mdadm must have found the members of
> your new arrays before it found members of the arrays your old
> mdadm.conf listed for md127 and md126.
>
> Any time you update your mdadm.conf in your root filesystem, you must
> remember to regenerate your initramfs so mdadm has the correct
> information at boot time (before root is mounted).
>
> To minimize future confusion, I recommend you renumber all of your
> arrays in mdadm.conf starting with minor number 1.  Then update your
> initramfs.  Then reboot.
>
> Your fstab uses uuids (wisely), so you don't need any particular minor
> numbers.  So you can and should avoid the minor numbers mdadm will use
> as defaults.
>
> HTH,
>
> Phil
