From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: md homehost (was: Bug#567468: (boot time consequences of) Linux
	mdadm superblock) question.
Date: Tue, 23 Feb 2010 20:12:14 -0800
Message-ID: <4877c76c1002232012j55e77adcs16d958fa6e922d71@mail.gmail.com>
References: <20100218044004.GC5136@lapse.rw.madduck.net>
	 <20100218163448.0d3f3107@notabene.brown>
	 <20100219004237.GC25162@lapse.rw.madduck.net>
	 <20100219091619.GA2964@lazy.lzy>
	 <20100221174007.GB19058@lapse.rw.madduck.net>
	 <20100221201304.GB2570@lazy.lzy>
	 <20100222091632.GE2641@lapse.rw.madduck.net>
	 <20100223133028.279e0174@notabene.brown>
	 <20100223062700.GB19666@lapse.rw.madduck.net>
	 <20100224111006.7024c84e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224111006.7024c84e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: martin f krafft <madduck@madduck.net>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 23, 2010 at 4:10 PM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 23 Feb 2010 07:27:00 +0100
> martin f krafft <madduck@madduck.net> wrote:
>
>> also sprach Neil Brown <neilb@suse.de> [2010.02.23.0330 +0100]:
>> > The problem to protect against is any consequence of rearranging
>> > devices while the host is off, including attaching devices that
>> > previously were attached to a different computer.
>>
>> How often does this happen, and how grave/dangerous are the effects?
>
> a/ no idea.
> b/ it all depends...
> =A0It is the sort of thing that happens when something has just gone
> =A0drastically wrong and you need to stitch things back together agai=
n as
> =A0quickly as you can. =A0You aren't exactly panicing, but you are pr=
obably
> =A0hasty and don't want anything else to go wrong.
>
> =A0If the array from the 'other' machine with the same name has very =
different
> =A0content, then things could go wrong in various different ways if w=
e
> =A0depended on that name.
> =A0It is true that the admin would have to by physically present and =
could
> =A0presumably get a console and 'fix' things. =A0But it would be best=
 if they
> =A0didn't have too. =A0They may not even know clearly what to do to '=
fix' things
> =A0- because it always worked perfectly before, but this time when in=
 a
> =A0 =A0particular hurry, something strange goes wrongs. =A0I've been =
there, I
> =A0 =A0don't want to inflict it on others.
>
>>
>> > But if '/' is mounted by a name in /dev/md/, I want to be sure
>> > mdadm puts the correct array at that name no matter what other
>> > arrays might be visible.
>>
>> Of course it would be nice if this happened, but wouldn't it be
>> acceptable to assume that if someone swaps drives between machines
>> that they ought to know how to deal with the consequences, or at
>> least be ready to tae additional steps to make sure the system still
>> boots as desired?
>
> No. =A0We cannot assume that an average sys-admin will have a deep kn=
owledge of
> md and mdadm. =A0Many do, many don't. =A0But in either case the behav=
iour must be
> predictable.
> After all, Debian is for "when you have better things to do than fixi=
ng
> systems"
>
>>
>> Even if the wrong array appeared as /dev/md0 and was mounted as root
>> device, is there any actual problem, other than inconvenience?
>> Remember that the person who has previously swapped the drives is
>> physically in front of (or behind ;)) the machine.
>>
>> I am unconvinced. I think we should definitely switch to using
>> filesystem-UUIDs over device names, and that is the only real
>> solution to the problem, no?
>>
>
> What exactly are you unconvinced of?
> I agree completely that mounting filesystems by UUID is the right way=
 to go.
> (I also happen to think that assembly md arrays by UUID is the right =
way to
> go too, but while people seem happy to put fs uuids in /etc/fstab, th=
ey seem
> less happy to put md uuids in /etc/mdadm.conf).
>
> As you say in another email:
>
>> The only issue homehost protects against, I think, is machines that
>> use /dev/md0 directly from grub.conf or fstab.
>
> That is exactly correct. =A0If no code or config file depends on a na=
me like
> /dev/mdX or /dev/md/foo, then you don't need to be concerned about th=
e whole
> homehost thing.
> You can either mount by fs-uuid, or mount e.g.
> =A0 /dev/disk/by-id/md-uuid-8fd0af3f:4fbb94ea:12cc2127:f9855db5
>
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Would a permissible behavior be to add a third case:
If an entry is not detected in the mdadm.conf file AND the homehost is
not found to match ask on the standard console what to do with
something like a 30 second timeout; as well as being noisy in the
kernel log so the admin knows why it was slow.

Really there should probably be two questions: 1) Do you want to run
this?  2) What name do you want? (with the defaults being yes, and the
currently chosen alternate name pattern).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
