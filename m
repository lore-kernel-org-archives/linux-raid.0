From: Scott Long <scott_long@adaptec.com>
Subject: Proposed Enhancements to MD
Date: Mon, 12 Jan 2004 20:41:54 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40036902.8080403@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(I already posted this to LKML a few hours ago but forgot to post it
over here)

All,

Adaptec has been looking at the MD driver for a foundation for their
Open-Source software RAID stack.  This will help us provide full
and open support for current and future Adaptec RAID products (as
opposed to the limited support through closed drivers that we have now).

While MD is fairly functional and clean, there are a number of 
enhancements to it that we have been working on for a while and would
like to push out to the community for review and integration.  These
include:

- partition support for md devices:  MD does not support the concept of
   fdisk partitions; the only way to approximate this right now is by
   creating multiple arrays on the same media.  Fixing this is required
   for not only feature-completeness, but to allow our BIOS to recognise
   the partitions on an array and properly boot them as it would boot a
   normal disk.

- generic device arrival notification mechanism:  This is needed to
   support device hot-plug, and allow arrays to be automatically
   configured regardless of when the md module is loaded or initialized.
   RedHat EL3 has a scaled down version of this already, but it is
   specific to MD and only works if MD is statically compiled into the
   kernel.  A general mechanism will benefit MD as well as any other
   storage system that wants hot-arrival notices.

- RAID-0 fixes:  The MD RAID-0 personality is unable to perform I/O
   that spans a chunk boundary.  Modifications are needed so that it can
   take a request and break it up into 1 or more per-disk requests.

- Metadata abstraction:  We intend to support multiple on-disk metadata
   formats, along with the 'native MD' format.  To do this, specific
   knowledge of MD on-disk structures must be abstracted out of the core
   and personalities modules.

- DDF Metadata support: Future products will use the 'DDF' on-disk
   metadata scheme.  These products will be bootable by the BIOS, but
   must have DDF support in the OS.  This will plug into the abstraction
   mentioned above.

I'm going to push these changes out in phases in order to keep the risk
and churn to a minimum.  The attached patch is for the partition
support.  It was originally from Ingo Molnar, but has changed quite a
bit due to the radical changes in the disk/block layer in 2.6.  The 2.4
version works quite well, while the 2.6 version is fairly fresh.  One
problem that I have with it is that the created partitions show up in
/proc/partitions after running fdisk, but not after a reboot.

Scott



