From: "NeilBrown" <neilb@suse.de>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 15:37:48 +1100
Message-ID: <5ff184eb945baf6f2ba6c009e0fde30d.squirrel@neil.brown.name>
References: <885316.78847.qm@web38805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <885316.78847.qm@web38805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, October 24, 2009 10:25 am, adfas asd wrote:
> --- On Fri, 10/23/09, NeilBrown <neilb@suse.de> wrote:
>> Clearly md0 is degraded - one device is missing.
>> You need to find out why.  Then if you trust the
>> missing device to
>> keep working, add it back in (mdadm --add ...)
>>
>> dmesg or /var/log/something might have hints as to what the
>> error
>> was that caused md to reject the device.
>
> Thanks Neil, this is the first constructive advice all day.
>
> Klipper isn't working for some reason, so I can't post the exact error,
> but dmesg and /var/log/messages say md0 has an unknown partition table
> (this time for ext2), just like with the prior problem on md2 (with jfs).

To see the cause of the error you would need to look further back
in the kernel logs for some messsage about md kicking the device from
the array.

Presumably you know which device is meant to be the other half of the
RAID1.  I suggest you try reading that whole device with
   dd if=/dev/whatever of=/dev/null bs=10M

and if that works, just add the device with
   mdadm /dev/md0 --add /dev/whatever

and see how it goes.

NeilBrown

