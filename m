From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: When read-only isn't read-only (was Re: [mdadm git pull] imsm
	fixes and general external metadata updates)
Date: Tue, 24 Feb 2009 18:45:52 -0500
Message-ID: <87f94c370902241545v5220403aue47371a7633abbfe@mail.gmail.com>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
	 <18822.13389.938876.964972@notabene.brown>
	 <1235404451.751.383.camel@firewall.xsintricity.com>
	 <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com>
	 <1235418832.751.385.camel@firewall.xsintricity.com>
	 <78a6226da1dee8c5b070b9ee30ee4705.squirrel@neil.brown.name>
	 <49A483BC.4090603@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49A483BC.4090603@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: NeilBrown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 24, 2009 at 6:33 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 23/02/2009 20:16, NeilBrown wrote:
>>
>> On Tue, February 24, 2009 6:53 am, Doug Ledford wrote:
>>>
>>> Is XFS the only one that does the journal recovery on initial mount
>>> read-only during the initfs step, or do other journaled fses do the=
 same
>>> thing? =A0I didn't think ext3 recovered the journal until you switc=
h to a
>>> read-write mount, but I guess I could be wrong.
>>
>> This from fs/ext3/super.c
>>
>> =A0 =A0 =A0 =A0if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMP=
AT_RECOVER)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sb->s_flags & MS_RDONLY) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "EXT=
3-fs: INFO: recovery "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0"required on readonly
>> filesystem.\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (really_read_only)=
 {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print=
k(KERN_ERR "EXT3-fs: write access "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0"unavailable, cannot proceed.\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retur=
n -EROFS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk (KERN_INFO "EX=
T3-fs: write access will "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0"be enabled during recovery.\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>>
>> suggests that, unfortunately, you are.
>
> Presumably it's not only me that thinks this is insane? If I want to =
mount a
> filesystem read-only, I expect it to be mounted read-only; perhaps I =
already
> know it's damaged, or know the journal's damaged...
>
> I guess I can see the journal recovery normally being the right thing=
, and
> it is the filesystem we asked to have read-only not the disc, but sti=
ll
> there surely has to be a way of saying mount without journal recovery=
, or
> mount without writing to disc, or both, and if there isn't who do I a=
sk to
> implement it? (I'm way too rusty as a coder to trust myself to get it=
 even
> half right.)
>
> I wonder: in the case of ext3 can I mount it as ext2 and thereby have=
 the
> journal ignored rather than recovered? And would this be sufficient f=
or the
> initrd context?
>
> Cheers,

I'm most familiar with xfs.  It has a norecovery flag you can use with =
mount.

I believe it was introduced many years ago because LVM snapshots at
the time were truly read-only and it was not possible to replay
portions of the journal in order to mount a filesystem.

I would assume all filesystems received similar enhancements?  Less
critical today because device mapper supports read/write snapshots.

Unfortunately, per the mount man page I only see that xfs has the
specific flag I'm talking about.

Greg
--=20
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
