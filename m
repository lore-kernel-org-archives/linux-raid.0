From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: RAID50 boot problems
Date: Wed, 24 Apr 2013 23:44:20 +0100
Message-ID: <CANBHLUikjsxOvBLkgAk4UDzwa3UPZ=jmTGhDzuMW31HLPCCu8Q@mail.gmail.com>
References: <20944014.4.1366628571053.JavaMail.root@zimbra>
	<6909786.18.1366738459191.JavaMail.root@zimbra>
	<20130424165201.67cc9d1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130424165201.67cc9d1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

On 24 April 2013 07:52, NeilBrown <neilb@suse.de> wrote:
> On Tue, 23 Apr 2013 19:34:19 +0200 (CEST) Roy Sigurd Karlsbakk
> <roy@karlsbakk.net> wrote:
>
>> > > > Please see http://paste.ubuntu.com/5721934/ for the full list,
>> > > > taken
>> > > > with network console. This is with rootdelay=10
>> > >
>> > > The "bind" messages are in random order so presumably udev running
>> > > 'mdadm -I'
>> > > on each device as it appear to add it to an array.
>> > > However when the md0 and md1 devices appear, udev isn't being run on
>> > > that.
>> > > So it looks like your udev rules file is wrong.
>> > > Find out which file(s) in /{etc,lib,usr/lib}/udev/rules.d mention
>> > > mdadm and
>> > > post them.
>> >
>> > /lib/udev/rules.d/64-md-raid.rules is here
>> > http://paste.ubuntu.com/5592227/
>>
>> Bug tested positive also on Ubuntu Precise (12.04) and reported to https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1171945
>>
>> Vennlige hilsener / Best regards
>>
>>
>
> This will run "mdadm --incremental $tempnode" on any device for which
> ID_FS_TYPE is set to "linux_raid_member", which certainly seems reasonable.
>
> What does:
>    udevadm info --query=property --path=/dev/mdXXX | grep ID_FS_TYPE
>
> report for the raid5 arrays?
>
> Looking bug report I see that md0 and md1 have
>    ID_FS_TYPE=linux_raid_member
>
> So that should be working.
>
> The fact that rootdelay=10 makes a difference suggests that it is
> successfully assembling the raid0, but just taking a bit too long.
> Maybe the script in the initrd needs "udevadm settle" just before it attempts
> to mount.
>
> Can you look inside the initrd and see if "udevadm settle" is used anywhere?
>

Yes, we do call and wait for udevadm to settle a few times, but it is
still too short and may not be long enough to detect nested raid
volumes and mount them properly in the correct order and non-degraded.
I have a few thoughts on using a strategy similar to that in dracut /
fedora to pass ids of the md arrays to assemble for rootfs device, and
keep trying to assemble the rest of mdadm "on best effort" basis
during boot.
That way I am also hoping to finally get rid of the dreaded "boot
degraded" boot option / question / prompt.
This is still just design in progress and hasn't been implemented yet.
I will be contacting this mailing list once I have something ready to
improve raid assembly in ubuntu.

Regards,

Dmitrijs.
