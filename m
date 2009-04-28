From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 10:19:12 +1200
Message-ID: <1240957153.18303.689.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-04-28 at 11:24 -0700, Dan Williams wrote:

> 
> ...or use a metadata format that your platform bios understands and
> provides an int 13h vector.  See the new external metadata formats
> supported by the mdadm devel-3.0 branch.

I don't think a metadata format is the right way either.  

What we need is a new version of the superblock with the first cylinder
(32kb on 512b sectors x64 sectors per cylinder) being set aside for the
bootloader, the superblock and w-i bitmap go in the second cylinder, and
the raid data area starting in the 3rd cylinder.  

It should be the bootloaders responsibility to install the bootloader
onto the disks 1st cylinder, but md/mdadm would have to replicate it on
resync or adding of a new disk.  However we could consider remapping the
bootloader 


-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

