From: John Robinson <john.robinson@anonymous.org.uk>
Subject: When read-only isn't read-only (was Re: [mdadm git pull] imsm fixes
 and general external metadata updates)
Date: Tue, 24 Feb 2009 23:33:16 +0000
Message-ID: <49A483BC.4090603@anonymous.org.uk>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>    <18822.13389.938876.964972@notabene.brown>    <1235404451.751.383.camel@firewall.xsintricity.com>    <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com>    <1235418832.751.385.camel@firewall.xsintricity.com> <78a6226da1dee8c5b070b9ee30ee4705.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <78a6226da1dee8c5b070b9ee30ee4705.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/02/2009 20:16, NeilBrown wrote:
> On Tue, February 24, 2009 6:53 am, Doug Ledford wrote:
>> Is XFS the only one that does the journal recovery on initial mount
>> read-only during the initfs step, or do other journaled fses do the same
>> thing?  I didn't think ext3 recovered the journal until you switch to a
>> read-write mount, but I guess I could be wrong.
> 
> This from fs/ext3/super.c
> 
> 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER)) {
> 		if (sb->s_flags & MS_RDONLY) {
> 			printk(KERN_INFO "EXT3-fs: INFO: recovery "
> 					"required on readonly filesystem.\n");
> 			if (really_read_only) {
> 				printk(KERN_ERR "EXT3-fs: write access "
> 					"unavailable, cannot proceed.\n");
> 				return -EROFS;
> 			}
> 			printk (KERN_INFO "EXT3-fs: write access will "
> 					"be enabled during recovery.\n");
> 		}
> 	}
> 
> suggests that, unfortunately, you are.

Presumably it's not only me that thinks this is insane? If I want to 
mount a filesystem read-only, I expect it to be mounted read-only; 
perhaps I already know it's damaged, or know the journal's damaged...

I guess I can see the journal recovery normally being the right thing, 
and it is the filesystem we asked to have read-only not the disc, but 
still there surely has to be a way of saying mount without journal 
recovery, or mount without writing to disc, or both, and if there isn't 
who do I ask to implement it? (I'm way too rusty as a coder to trust 
myself to get it even half right.)

I wonder: in the case of ext3 can I mount it as ext2 and thereby have 
the journal ignored rather than recovered? And would this be sufficient 
for the initrd context?

Cheers,

John.

