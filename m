From: Info@quantum-sci.net
Subject: Re: Help
Date: Sat, 22 Aug 2009 11:12:35 -0700
Message-ID: <200908221112.35952.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <200908220556.32856.Info@quantum-sci.net> <4A902134.2020009@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A902134.2020009@anonymous.org.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 22 August 2009 09:47:48 John Robinson wrote:
> You should have mkinitrd (that's what it is on Fedora/RHEL/CentOS) or 
> something similar with which you can build initramfs images for any kernel.

OK once I changed the version to 0.90 it stopped just at the kernel banner on boot and hung.  I was about to give up on RAID when your message came through, and I created the initrd.img file.  I always compile my own kernels and don't depend on an initrd, but it now seems to be necessary.  So in Debian:
# update-initramfs -o /boot/initrd.img-2.6.30-5
... reboot, and voila it did what it was supposed to, for a change.  I'm now resyncing my 2TB drives, which will take a good while.

 
> > What partition type should I use rather than raid autodetect?  Or should I revert to 0.90 metadata?
> 
> Probably type DA, Non-FS data, though type FD will be fine even if 
> they're not auto-detected.

It simply found 'bad magick' with FD, so that doesn't work with the newer versions.  I tried to use both newer versions, but it's not possible.  You sound not quite sure of the partition type, so I'll stick with FD and 0.90.  Thanks though John.

Goswin says, "For scanning your videos raid10 with far layout is probably best with
a large read ahead."  I have the RAID10 blocksize set to 1024 for the video partition, but any idea how to set readahead?




