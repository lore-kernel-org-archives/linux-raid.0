From: "NeilBrown" <neilb@suse.de>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata
     updates
Date: Tue, 24 Feb 2009 07:16:06 +1100 (EST)
Message-ID: <78a6226da1dee8c5b070b9ee30ee4705.squirrel@neil.brown.name>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
    <18822.13389.938876.964972@notabene.brown>
    <1235404451.751.383.camel@firewall.xsintricity.com>
    <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com>
    <1235418832.751.385.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1235418832.751.385.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, February 24, 2009 6:53 am, Doug Ledford wrote:
> Is XFS the only one that does the journal recovery on initial mount
> read-only during the initfs step, or do other journaled fses do the same
> thing?  I didn't think ext3 recovered the journal until you switch to a
> read-write mount, but I guess I could be wrong.

This from fs/ext3/super.c

	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER)) {
		if (sb->s_flags & MS_RDONLY) {
			printk(KERN_INFO "EXT3-fs: INFO: recovery "
					"required on readonly filesystem.\n");
			if (really_read_only) {
				printk(KERN_ERR "EXT3-fs: write access "
					"unavailable, cannot proceed.\n");
				return -EROFS;
			}
			printk (KERN_INFO "EXT3-fs: write access will "
					"be enabled during recovery.\n");
		}
	}

suggests that, unfortunately, you are.

NeilBrown



