From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Converting a non-RAID RedHat System to run on Software RAID
Date: Wed, 10 Sep 2003 09:18:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030910131849.GA5267@ti19>
References: <E5DA6395B8F9614EB7A784D628184B200D9A56@hdsmsx402.hd.intel.com>
Reply-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E5DA6395B8F9614EB7A784D628184B200D9A56@hdsmsx402.hd.intel.com>
To: linux-raid@vger.kernel.org
Cc: Eric Wood <eric@interplas.com>, "Cress, Andrew R" <andrew.r.cress@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 09, 2003 at 02:37:18PM -0400, Cress, Andrew R wrote:
> The instructions are oriented to lilo, but the grub equivalent is
> scripted in files/mdevt script:
> http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/*checkout*/scsirastools/s
> csirastools/files/mdevt?rev=HEAD&content-type=text/plain

A word of caution:

One miserable consequence of using GRUB on RAID1 is inadvertent corruption
of (a small part of the) RAID-1 /boot partition.  Since grub (at least
in Red Hat Rawhide) doesn't grok MD, if one sets up a RAID-1 /boot
partitiion, say

   /dev/md1 ->  (/dev/sda1,dev/sdb1),

then modifications made at the grub prompt modify the filesystem and
desynchronizes the RAID1 set. [It seems that simply using 'e' to edit the
kernel args has this effect, though I haven't verified it myself.]  We see
this corruption in MD5 variation in our nightly integrity-verification
cron job.

Grub has a --read-only option when running the grub shell from Linux;
I haven't yet found the time to delve into the code to see whether it
is simple to do the same in the stage2 loader, or whether the read-only
behavior is purely a function of the device open() when running the grub
shell.

Trivial workaround is to resync the second drive in the rc scripts;
for the typical 50-100MB /boot partition, this takes only a few seconds.
 
Regards,

	Bill Rugolsky
