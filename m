From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: RAID50 boot problems
Date: Fri, 26 Apr 2013 20:24:21 +0100
Message-ID: <CANBHLUiS1Z=GzJKzPS9vrokZ=Tu9T5FY-_a58uTzTswP+GdiXA@mail.gmail.com>
References: <20944014.4.1366628571053.JavaMail.root@zimbra>
	<6909786.18.1366738459191.JavaMail.root@zimbra>
	<20130424165201.67cc9d1e@notabene.brown>
	<CANBHLUikjsxOvBLkgAk4UDzwa3UPZ=jmTGhDzuMW31HLPCCu8Q@mail.gmail.com>
	<20130425094417.4882607e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130425094417.4882607e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

On 25 April 2013 00:44, NeilBrown <neilb@suse.de> wrote:
> On Wed, 24 Apr 2013 23:44:20 +0100 Dmitrijs Ledkovs <xnox@debian.org> wrote:
>
>> On 24 April 2013 07:52, NeilBrown <neilb@suse.de> wrote:
>> > On Tue, 23 Apr 2013 19:34:19 +0200 (CEST) Roy Sigurd Karlsbakk
>> > <roy@karlsbakk.net> wrote:
>> >
>> >> > > > Please see http://paste.ubuntu.com/5721934/ for the full list,
>> >> > > > taken
>> >> > > > with network console. This is with rootdelay=10
>> >> > >
>> >> > > The "bind" messages are in random order so presumably udev running
>> >> > > 'mdadm -I'
>> >> > > on each device as it appear to add it to an array.
>> >> > > However when the md0 and md1 devices appear, udev isn't being run on
>> >> > > that.
>> >> > > So it looks like your udev rules file is wrong.
>> >> > > Find out which file(s) in /{etc,lib,usr/lib}/udev/rules.d mention
>> >> > > mdadm and
>> >> > > post them.
>> >> >
>> >> > /lib/udev/rules.d/64-md-raid.rules is here
>> >> > http://paste.ubuntu.com/5592227/
>> >>
>> >> Bug tested positive also on Ubuntu Precise (12.04) and reported to https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1171945
>> >>
>> >> Vennlige hilsener / Best regards
>> >>
>> >>
>> >
>> > This will run "mdadm --incremental $tempnode" on any device for which
>> > ID_FS_TYPE is set to "linux_raid_member", which certainly seems reasonable.
>> >
>> > What does:
>> >    udevadm info --query=property --path=/dev/mdXXX | grep ID_FS_TYPE
>> >
>> > report for the raid5 arrays?
>> >
>> > Looking bug report I see that md0 and md1 have
>> >    ID_FS_TYPE=linux_raid_member
>> >
>> > So that should be working.
>> >
>> > The fact that rootdelay=10 makes a difference suggests that it is
>> > successfully assembling the raid0, but just taking a bit too long.
>> > Maybe the script in the initrd needs "udevadm settle" just before it attempts
>> > to mount.
>> >
>> > Can you look inside the initrd and see if "udevadm settle" is used anywhere?
>> >
>>
>> Yes, we do call and wait for udevadm to settle a few times, but it is
>> still too short and may not be long enough to detect nested raid
>> volumes and mount them properly in the correct order and non-degraded.
>> I have a few thoughts on using a strategy similar to that in dracut /
>> fedora to pass ids of the md arrays to assemble for rootfs device, and
>> keep trying to assemble the rest of mdadm "on best effort" basis
>> during boot.
>> That way I am also hoping to finally get rid of the dreaded "boot
>> degraded" boot option / question / prompt.
>> This is still just design in progress and hasn't been implemented yet.
>> I will be contacting this mailing list once I have something ready to
>> improve raid assembly in ubuntu.
>>
>
> My current thinking is that the initramfs should *only* assemble arrays needed
> to mount the root filesystems.  All other arrays should wait for root to be
> mounted so that real /etc/mdadm.conf (or /etc/mdadm/mdadm.conf) can be
> consulted.
> This can be achieved by putting
>   auto -all
> in mdadm.conf on the initramfs, then listing the arrays that are needed.
>

That's an easy way to do it. One property of Ubuntu's initramfs at the
moment is that they are more or less generic, one can reuse the same
one to boot similar machines.
I'm not sure if it was a requirement at any point, but many initramfs
& faster boot speed design choices led to that.
And ideally I'd like to keep that property. Hence I'd like to ideally
pass the arrays to be assembled as a kernel arg and not store it in
the initramfs.

> I'm not convinced that your boot-degraded option is a bad thing.  Certainly
> it should be optional so unattended boot is possible, and we should do our
> best to minimise the number of times that it is consulted.  But there are
> times when it is better to know that something is wrong, than to proceed and
> do the wrong thing.
>

Well, the default is to not boot-degraded and instead a configuration
question is asked upon installation if one would like to boot no
matter what.
(deb packages allow that via debconf, unlike usual rpm packages).

> A particularly bad case is a RAID1 pair where one device failed a few days
> ago.
> If after a reboot the good device is missing (cable problem?) and the bad
> device is visible, it could be best not to boot rather than to boot with an
> old root based on the old  'failed' device.
>

This is the ultimate reason for not booting degraded by default. But
unfortunately we still hit too many "false positive" degraded
scenarios as the moment, thus the opponents to the current strategy.

Regards,

Dmitrijs.
