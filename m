From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 3 Nov 2008 11:33:36 +0100
Message-ID: <ac3eb2510811030233t55bd3655k2b71be68dda99735@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <1225387127.26510.155.camel@firewall.xsintricity.com>
	 <18698.54207.663716.200113@notabene.brown>
	 <20081103092920.GA8902@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081103092920.GA8902@boogie.lpds.sztaki.hu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Neil Brown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Nov 3, 2008 at 10:29, Gabor Gombas <gombasg@sztaki.hu> wrote:
> On Fri, Oct 31, 2008 at 08:45:35PM +1100, Neil Brown wrote:
>
>> I have considered dropping the "/dev/mdXX" names altogether, and I
>> think mdadm.2 sometimes does that.  But I've decided against it.
>> My reasons are:
>>
>>  1/ udev is going to create them anyway, so there is no point trying
>>     to hide them.
>>  2/ those names appear in /proc/mdstat and despite all the rhetoric
>>     about naming policy not belonging in the kernel, the kernel does
>>     set some naming policy, "mdX" etc are part of that, and we cannot
>>     avoid it.
>>     Joe Sysadmin will see a name in /proc/mdstat and might want to
>>     access that device.  Having it easily available in /dev is good.
>
> Network devices can be renamed and the new name appears under
> /proc/net/dev and in /sys. I think the best solution would be to enable
> such renaming for block devices too. I don't know how hard it would be
> to implement... Naming policy belongs to userspace, but it would be very
> nice to tell the kernel "I want to call this device FOO from now. Please
> use the string FOO whenever you refer to this device, and don't use any
> other names for it".

Network devices have only one entry point, if you insist you can think
of the index number as another value, but there is always only one
single name that matters. And we need to rename them because we have
no real concept  of symlinks for network interfaces.

That is not true at all for block devices, you can identify them in
many ways, by name, by physical location, by hardware ID from the
stuff behind the devices, by filesystem metadata, by properies of the
specific subsystem, ... Renaming block devices just does not make much
sense, because there is no primary name to use, it all depends on the
actual setup and personal preference.

Kay
