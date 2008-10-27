From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 09:37:08 +1100
Message-ID: <18694.17044.342920.841232@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<20081027082257.GB1801@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin f krafft on Monday October 27
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@debian.org>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Monday October 27, madduck@debian.org wrote:
> also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:
> > Greeting.
> >  This is a Request For Comments....
> 
> Good morning!
> 
> [...]
> > I'm also wondering if I should include a udev 'rules' file for md
> > in the mdadm distribution.  Obviously it would be no more than
> > a recommendation, but it might give me a voice in guiding how udev
> > interacted with mdadm.
> 
> I would really like to have a clear separation of competencies.
> Ideally, mdadm never creates any devices but leaves it all to udev,
> and all configuration about alternate names ("symlinks") is done in
> the udev rules file.

Yes, I am moving towards this.  And it seems to be an idea with
resounding support judging by the follow-ups.  So I will probably go
even further than I was planning.
 - if mdadm detects that udev is active (how do I do that???) mdadm
   won't create anything in /dev, or remove anything from /dev, except
   for temporary devices with names that start with '.'.

 - if mdadm does not detect udev, it will still create the device
   and maybe some links.  And remove anything it might have created.

> 
> I know mdadm needs the devices for the ioctls(). However, much of
> what it does with ioctl should already be possible with /sys. Thus,
> in my ideal world, I imagine mdadm to be a manipulator of /sys,
> instructing the kernel to do stuff with components and arrays, and
> have udev create and remove corresponding devices in response to
> kernel events.

Most things can now be done via sysfs, but not everything (bitmaps is
the most obvious hole in the sysfs support).  And I still need to
support older kernels that don't have as many sysfs attributes.

However I do want to move towards using sysfs preferentially,
particularly for "mdadm --monitor".  I would rather that daemon didn't
ever open the device, as that can interfere with e.g. stopping the
array.  The "mdadm -D" calls from udev also need to not open the device.

> 
> I realise this would require a revamp of mdadm, and might actually
> be better done in a new software designed to eventually replace
> mdadm. But is this a way forward with which you could befriend
> yourself?


One issue that looms in my mind as I consider this is the Usage of
mdadm when e.g. creating an array

   mdadm -C /dev/md5 -l5 -n3 /dev/sd[bcd]

I need to give the name of an array device (/dev/md5) that may not
exist but that mdadm doesn't now want to create.

Once I have created the array I might want to look at the details with

   mdadm --detail /dev/md5

The important role that the string "/dev/md5" is serving here is
providing a connection between the two command.  Whatever I created in
the first is what I access in the second.

I could have mdadm accept a simple name

   mdadm -C foo -l5 -n3 /dev/sd[bcd]

but we would need to be clear on the semantics of that name.
For a v1.x metadata array, or a member of a DDF set, I could store
the name in the metadata and it could be a persistent name.
For v0.90, only numbers can be persistent names.
For DDF containers and IMSM(*) there is no where to store a name.
I could store it in /var/run/mdadm/map so that the "mdadm --detail"
could find it.  But in that case it wouldn't be permanent.

I related question is the creation and naming of arrays with other
metadata formats.  e.g. DDF or imsm.
Currently I do e.g.
   mdadm -C /dev/ddf1 --metadata=ddf ......
having the string 'ddf' twice annoys me.
Maybe I could allow

   mdadm -C ddf1  -n5 /dev/sd[abcde]

and have mdadm recognise the metadata format name in "ddf1" and use
that metadata type.

The thing I want to get right now is to put strict limits on names
that are allowed to be given as the array device name in Assemble,
Build, Create.  I can then add new idea by allowing names to be given
that were illegal before.
So in the first instance, I'm think the array name can be:

  /dev/mdN
  /dev/md/N
  /dev/md_dN
  /dev/md/dN

  /dev/md/name-with-no-trailing-digit
           The metadata must store a name which matches the given name
  /dev/md/metadataname-with-trailing-digit-string
           The array must have the named metadata.

But I'm not completely sure of this.  And it might break existing
setups (but I've decided to live with that).

Thanks,
NeilBrown



* DDF = Disk Data Format.  An SNIA 'standard'
* IMSM = Intel Matrix Storage Manager
* SNIA = Storage Networking Industry Association.
