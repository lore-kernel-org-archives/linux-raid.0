From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 23:51:53 +0100
Message-ID: <ac3eb2510810271551q53c27fedi9d662a36bd281ed4@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
	 <18694.17044.342920.841232@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18694.17044.342920.841232@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: martin f krafft <madduck@debian.org>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 23:37, Neil Brown <neilb@suse.de> wrote:
> On Monday October 27, madduck@debian.org wrote:
>> also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:

>> I would really like to have a clear separation of competencies.
>> Ideally, mdadm never creates any devices but leaves it all to udev,
>> and all configuration about alternate names ("symlinks") is done in
>> the udev rules file.
>
> Yes, I am moving towards this.  And it seems to be an idea with
> resounding support judging by the follow-ups.  So I will probably go
> even further than I was planning.
>  - if mdadm detects that udev is active (how do I do that???)

Most tools just check if /dev/.udev/ exists.

>   mdadm
>   won't create anything in /dev, or remove anything from /dev, except
>   for temporary devices with names that start with '.'.

Fine.

>  - if mdadm does not detect udev, it will still create the device
>   and maybe some links.  And remove anything it might have created.

Sounds good.

>> I know mdadm needs the devices for the ioctls(). However, much of
>> what it does with ioctl should already be possible with /sys. Thus,
>> in my ideal world, I imagine mdadm to be a manipulator of /sys,
>> instructing the kernel to do stuff with components and arrays, and
>> have udev create and remove corresponding devices in response to
>> kernel events.
>
> Most things can now be done via sysfs, but not everything (bitmaps is
> the most obvious hole in the sysfs support).  And I still need to
> support older kernels that don't have as many sysfs attributes.
>
> However I do want to move towards using sysfs preferentially,
> particularly for "mdadm --monitor".  I would rather that daemon didn't
> ever open the device, as that can interfere with e.g. stopping the
> array.  The "mdadm -D" calls from udev also need to not open the device.

Sounds fine, but remember that udev will always look at every device's
content if not explicitly told no to do. It will look for filesystem
signatures and other metadata at the beginning and the end of the
device.

> One issue that looms in my mind as I consider this is the Usage of
> mdadm when e.g. creating an array
>
>   mdadm -C /dev/md5 -l5 -n3 /dev/sd[bcd]
>
> I need to give the name of an array device (/dev/md5) that may not
> exist but that mdadm doesn't now want to create.
>
> Once I have created the array I might want to look at the details with
>
>   mdadm --detail /dev/md5
>
> The important role that the string "/dev/md5" is serving here is
> providing a connection between the two command.  Whatever I created in
> the first is what I access in the second.

Can't you just use the major/minor is there is no other meaningful
name? The devnum can not change on any system, and is always valid as
long as the kernel device exists.

Kay
