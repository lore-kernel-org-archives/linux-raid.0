From: Doug Ledford <dledford@redhat.com>
Subject: Re: raid1-diseaster on reboot: old version overwrites new version
Date: Mon, 04 Apr 2005 15:39:18 -0400
Message-ID: <1112643558.29559.28.camel@compaq-rhel4.xsintricity.com>
References: <424EBDB7.2000106@goldfisch.at>  <424ED7FA.4050007@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424ED7FA.4050007@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2005-04-02 at 09:35 -0800, Tim Moore wrote:
> 
> peter pilsl wrote:
> > The only explantion to me is, that I had the wrong entry in my 
> > lilo.conf. I had root=/dev/hda6 there instead of root=/dev/md2
> > So maybe root was always mounted as /dev/hda6 and never as /dev/md2, 
> > which was started, but never had any data written to it. Is this a 
> > possible explanation?
> 
> No.  The lilo.conf entry just tells the kernel where root is located.

Yes, as Neil posted, this exactly explains the issue.  If /dev/hda6 is
part of a raid1 array, and you write to it instead of /dev/md2, then
those writes are never sent to /dev/hdc6 and the two devices get out of
sync.  Plus, standard initrd setups and the like are written to
accommodate users passing in arbitrary root= options on the kernel
command line to over ride the default root partition, and in those
situations the root partition must be taken from the command line and
not from fstab in order for this to work.  So, whether it's lilo or grub
or whatever, the root= line on your kernel command line is *the*
authority when it comes to what will be mounted as the root partition
you actually use.

> Can you publish your /etc/fstab and fdisk -l output?

Keep in mind the root partitions is already mounted in ro mode by the
time fstab is available and the rc.sysinit script merely remounts it rw.
Again, the command line is the authority.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


