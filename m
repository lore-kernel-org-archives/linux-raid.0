From: Hai Wu <haiwu.us@gmail.com>
Subject: Re: mdadm rebuild
Date: Sun, 8 Dec 2013 17:03:22 -0600
Message-ID: <CA74C8FD-DBDC-428B-9645-E2DD2300EE9D@gmail.com>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com> <20131209085554.262006d5@notabene.brown> <CAJ1=nZfUBQ0_T1s3deG+HOU7BQeayibWcW8y5h5bEjFt2tvhnA@mail.gmail.com> <20131209095328.0d39e6ad@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209095328.0d39e6ad@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is something I am not aware of, thanks! 

In this case, do I have to worry about cases where the new drive might not be able to boot (this is raid1 with 2 drives, and both drives need to be able to boot up the server by themselves in case the other drive fails later)? I remember I had to do the following before for the new drive:

grub> root (hd0,0)

Is that still the case here if marking it as 'spare'?

On Dec 8, 2013, at 4:53 PM, NeilBrown <neilb@suse.de> wrote:

> On Sun, 8 Dec 2013 16:45:08 -0600 hai wu <haiwu.us@gmail.com> wrote:
> 
>> Thanks Neil. I am not sure if I understand mdadm 'spare' correctly. If
>> doing as you mentioned above, the new driver will show up in output of
>> "mdadm --detail /dev/md0" as 'spare' status, while I would like the new
>> drive to automatically show up as "acitve, sync", and it will automatically
>> be synced up with the one remaining good drive upon running the udev rule.
>> I don't see an option like "force-include" in this case. Please let me know
>> if I miss something.
> 
> Whenever md notices that an array has a spare device and a missing device it
> will start rebuilding the spare and will then make it an active device.
> 
> So if a new device is added to the system, you really do want to give it to
> md as a 'spare'.  md will do the rest - it always has done.
> 
> NeilBrown
> 
> 
>> 
>> 
>> On Sun, Dec 8, 2013 at 3:55 PM, NeilBrown <neilb@suse.de> wrote:
>> 
>>> On Sun, 8 Dec 2013 11:53:00 -0600 Hai Wu <haiwu.us@gmail.com> wrote:
>>> 
>>>> I am wondering whether it is possible for mdadm to auto-rebuild a failed
>>>> raid1 driver upon its replacement with a new drive? The following lines
>>>> from some RedHat website URL seems to indicate vaguely that it might be
>>> possible:
>>>> 
>>> 
>>> Yes and no.
>>> "yes" because it is certainly possible to arrange this,
>>> "no" because it isn't just mdadm which does it.
>>> 
>>> When a drive is plugged in, udev notices and can run various commands to do
>>> things with that device.  You need to get udev to run "mdadm -I $devname"
>>> when a new device is plugged in.
>>> The udev scripts which come with mdadm will only do that for new drives
>>> which
>>> appear to be part of an array already.  You presumably want it to do that
>>> for
>>> any new drive.  The change should be quite easy.
>>> 
>>> Secondly, you need to tell mdadm that it is OK to add a new device as a
>>> spare
>>> to an array.  To see how to do this you need to read the documentation for
>>> the "POLICY" command in mdadm.conf.5.
>>> 
>>> A line like:
>>>    POLICY action=force-spare
>>> tells mdadm that any device passed to "mdadm -I" can be added to any array
>>> as
>>> a spare.  You might not want that, but you can restrict it in various ways.
>>> 
>>>    POLICY path=pci-0000:00:1f.2-scsi* action=spare
>>> 
>>> says that any device attached to a particular controller can be added to
>>> any
>>> array as long as it is already a member of the array, or appears to be
>>> blank.
>>> 
>>> There are various other directives which should allow you to describe
>>> whatever you want.
>>> 
>>> NeilBrown
>>> 
>>> 
>>>> Previously, mdadm was not able to rebuild newly-connected drives
>>>> automatically. This update adds the array auto-rebuild feature and
>>> allows a
>>>> RAID stack to automatically rebuild newly-connected drives.
>>>> 
>>>> The goal is to get mdadm software raid1 to behave the same as hardware
>>>> raid1, when replacing failed hard drive. It should automatically detect
>>> new
>>>> drive and rebuild the new drive into part of raid1 ..--
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>>> 
> 

