From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Auto Rebuild on hot-plug
Date: Fri, 02 Apr 2010 12:01:08 +0100
Message-ID: <4BB5CE74.4000900@anonymous.org.uk>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com> <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk> <4BB0F820.4030707@redhat.com> <4BB12B77.8030902@anonymous.org.uk> <4BB13942.3030400@redhat.com> <4BB1EA4F.5070803@anonymous.org.uk> <4BB21E97.1020406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB21E97.1020406@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On 30/03/2010 16:53, Doug Ledford wrote:
> On 03/30/2010 08:10 AM, John Robinson wrote:
[...]
>> I wouldn't want to take the server down to shuffle the drives or cables.
>> But my point really is that if I have decided that I would want all the
>> drives in my chassis to have identical partition tables and carry an
>> active mirror of an array - in my example /boot - I would like to be
>> able to configure the hotplug arrangement to make it so, rather than
>> leaving me to have to manually regenerate the partition table, install
>> grub, add the spare and perhaps even grow the array.
> 
> I can (sorta) understand this.  I personally never create any more /boot
> partitions than the number of drives I can loose from my / array + 1.
> So, if I have raid5 / array, I do 2 /boot partitions.  Anything more is
> a waste since if you loose both of those boot drives, you also have too
> few drives for the / array.

A very fair point. But it's not really all that wasteful - I've had to 
use the first 100MB from at least two drives, meaning that space would 
effectively go to waste on the others. And 100MB out of 1TB isn't an 
awfully big waste anyway.

[...]
>>  This might mean that I end up something like the following:
>> DOMAIN path=pci-0000:00:1f.2-scsi-[0-4]:0:0:0       action=include
>> DOMAIN path=pci-0000:00:1f.2-scsi-[0-4]:0:0:0-part1 action=grow
>> DOMAIN path=pci-0000:00:1f.2-scsi-[0-4]:0:0:0-part2 action=replace
>> DOMAIN path=pci-0000:00:1f.2-scsi-[0-4]:0:0:0-part3 action=include
> 
> This I'm not so sure about.  I can try to make this a reality, but the
> issue here is that when you are allowed to specify things on a partition
> by partition basis, it becomes very easy to create conflicting commands.
>  For example, lets say you have part1 action=grow, but for the bare disk
> you have action=incremental.  And let's assume you plug in a bare disk.
>  In order to honor the part1 action=grow, we would have to partition the
> disk, which is in conflict with the bare disk action of incremental
> since that implies we would only use preexisting md raid partitions.

Yes, but in that case I've given specific instructions about what to do 
with bare drives. It'd be a bad configuration, and you might warn about 
it, but you couldn't honour the grow. Bear in mind, the two domain lines 
here don't overlap. If they did you've more of a quandry, or at least 
you should shout louder about it. I don't think you should be writing 
partition tables unless I've told you to - which I would have done in 
the following more general case:
DOMAIN path=pci-0000:00:1f.2-scsi-[0-4]* action=replace

>  I
> could *easily* see the feature of allowing per partition actions causing
> the overall code complexity to double or more.

I'm not sure why, since you probably ought to be doing some fairly 
rigorous checking of the configuration anyway to make sure domains and 
actions don't overlap or conflict.

>  You know, I'd rather
> provide a simple grub script that automatically setup all raid1 members
> as boot devices any time it was ran than try to handle this
> automatically ;-)  Maybe I should add that to the mdadm package on
> x86/x86_64, something like mdadm-grub-install or similar.

That would be fine too, as long as there's some way of calling it from 
the hotplug environment.

> As pointed out above, some of these are conflicting commands in that
> they tell us to modify the disk in one place, and leave it alone in
> another.

If the paths overlapped I'd agree, but they didn't, and I made sure the 
whole-drive action was sufficient to make sure the partition actions 
could be carried out. I agree though that there's plenty of scope for 
people writing duff configurations like the one you suggested, but I 
think there'll be scope for that whatever you do - even if it's 
foolproof, it may not be damn-fool-proof.

>  The basic assumption you are making here is that we will
> always be able to duplicate the partition table because all drives in a
> domain will have the same partition table.  And that's not always the case.

It might be a reasonable restriction for a first implementation, though. 
If not, you're going to have to store copies of the partition tables, 
boot areas, etc somewhere else so that when the drives they were on are 
hot-swapped, you can write the correct stuff back.

[...]
>> Sorry if I'm being long-winded, but hopefully you can see how I'd like
>> to be able to configure things. In the first instance, though, just
>> getting as far as the replace option would be great.
> 
> I see where you are going, I'm a little worried about getting there ;-)

I don't blame you. Isn't it just typical of a user who doesn't 
understand the work involved to demand the sky and the stars? Anyway 
thank you very much for taking the time to consider my thoughts.

Cheers,

John.

