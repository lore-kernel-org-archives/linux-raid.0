From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 15:20:15 +0100
Message-ID: <ac3eb2510810270720i39ffdd1td5336b2d63dbfafe@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
	 <20081027132453.GF17300@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081027132453.GF17300@skl-net.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 14:24, Andre Noll <maan@systemlinux.org> wrote:
> On 13:41, Kay Sievers wrote:
>> >  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
>> >    along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
>> >    These will be created by mdadm in accordance with the "--auto"
>> >    flag unless something in mdadm.conf says to leave it to udev.
>> >    In that case, mdadm will create a temporary node
>> >    (/dev/.mdadm.whatever) and remove it once udev has created the
>> >    real thing.
>>
>> Sounds fine, if mdadm needs a device node. It could also wait for udev
>> to have the node created, but having a temporary node sounds fine, as
>> long as it will not clash with anything udev is creating.
>
> IMHO we should try to avoid creating device nodes from mdadm whenever
> possible. OTOH it should be possible to assemble a raid array manually
> i.e. without udev, for example when used from a rescue system.

Sounds good, yes.

>> >    In particular, it will remove the device node as described in 1,
>> >    any partitions, and any symlinks in /dev or /dev/md which point to
>> >    any of those.  I need to be certain that this won't confuse udev.
>>
>> You must never touch anything that udev has created. It must be driven
>> by kernel "add/remove/change" events.
>
> I think it's no problem to let mdadm generate such events rather than
> messing with device nodes itself. BTW: What's the preferred way to
> wait for the generation of the device node after an appropriate event
> has been generated? Polling?

There are several ways, but none of them is really simple because of
the complete asynchronous behavior of udev.

A daemon could listen for  events from udev, in the way like when
"udevadm monitor" prints "UDEV[] add /.../block/md0, we can be sure
the node exists, and the event is fully handled. The event environment
also contains the device name and all the symlink names.

Or we need to loop until the event sequence number is handled (device
mapper is doing that), or loop until the device node/link is there.

>> Some systems do automount all devices. Most systems do only hotplug
>> devices which are not listed in /etc/fstab. Expect in the future that
>> there will always be auto-assembly and also auto-mounting to some
>> degree. All the newer storage buses, like iSCSI and such will always
>> need  auto-mounting on device discovery, and not work with any
>> bootup-script logic.

>> > I'm also wondering if I should include a udev 'rules' file for md in
>> > the mdadm distribution.  Obviously it would be no more than a
>> > recommendation, but it might give me a voice in guiding how udev
>> > interacted with mdadm.
>>
>> Definitely, it should carry a udev rules file which instructs udev to
>> create all intended symlinks and also supports the raid auto-assembly
>> setup. It should not mount anything by default though.
>
> How about distributing such a rules file together with udev? As far as
> I understand it, you (Kay) are currently trying to unify the different
> udev configurations that exist in the wild. If the udev source code
> contained a rules file for md, this would already help.
>
> Moreover, changes to udev that require modifications of the md rules
> file might happen more frequently than changes to md that require
> such modifications ;)

Works both ways. Doesn't really matter. We have many packages today
installing their own rules files, which is good if systems do not use
a specific piece of software, so that they don't needlessly match udev
rules with every event, for something that will never exist.

Kay
