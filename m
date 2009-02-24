From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata
	updates
Date: Tue, 24 Feb 2009 08:57:33 +0100
Message-ID: <20090224075733.GE19209@maude.comedia.it>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com> <18822.13389.938876.964972@notabene.brown> <1235404451.751.383.camel@firewall.xsintricity.com> <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com> <1235418832.751.385.camel@firewall.xsintricity.com> <78a6226da1dee8c5b070b9ee30ee4705.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <78a6226da1dee8c5b070b9ee30ee4705.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 24, 2009 at 07:16:06AM +1100, NeilBrown wrote:
>On Tue, February 24, 2009 6:53 am, Doug Ledford wrote:
>> Is XFS the only one that does the journal recovery on initial mount
>> read-only during the initfs step, or do other journaled fses do the same
>> thing?  I didn't think ext3 recovered the journal until you switch to a
>> read-write mount, but I guess I could be wrong.
>
>This from fs/ext3/super.c
>
>	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER)) {
>		if (sb->s_flags & MS_RDONLY) {
>			printk(KERN_INFO "EXT3-fs: INFO: recovery "
>					"required on readonly filesystem.\n");
>			if (really_read_only) {
>				printk(KERN_ERR "EXT3-fs: write access "
>					"unavailable, cannot proceed.\n");
>				return -EROFS;
>			}
>			printk (KERN_INFO "EXT3-fs: write access will "
>					"be enabled during recovery.\n");
>		}
>	}
>
>suggests that, unfortunately, you are.
>
am i misreading or the above is just a check not to
incur in further problems later?

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
