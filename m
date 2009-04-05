From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: rebuilding raided root partition
Date: Sun, 05 Apr 2009 23:35:55 +0200
Message-ID: <87vdpibx6s.fsf@frosties.localdomain>
References: <49D81804.6070102@traversetechnologies.com>
	<871vs7h9pe.fsf@frosties.localdomain>
	<49D8B2B3.7050903@traversetechnologies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D8B2B3.7050903@traversetechnologies.com> (Miles Fidelman's
	message of "Sun, 05 Apr 2009 09:31:31 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@traversetechnologies.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Miles Fidelman <mfidelman@traversetechnologies.com> writes:

> Goswin von Brederlow wrote:
>> Ar you sure your / is actualy /dev/md2? Maybe you booted from
>> /dev/sda3 or /dev/sdc3? I recommend booting a rescue/life CD and
>> then look for a partition containing an active drive for md2 so you
>> can rebuild your raid.
>>
> pretty sure - there's a physical LVM volume defined on top of
> /dev/md2, and / is a LV defined on top of that - the machine comes up
> and runs

The lvm can just as easily run of sda3 or sdc3 if it does not check
for the raid signature (option in lvm.conf). Since it is a raid1 that
totaly works. Since you can boot your data seems to be still there,
somewhere. Just not in the raid.

>> Also did you know that you can run a raid1 with 3 active drives? That
>> way you are potected against 2 drive failures and don't need to wait
>> for the spare drive to resync before having fault tolerance if one
>> drive fails.
>>
>>
> Can you elaborate on how to do that, particularly how to add a new
> active volume to an existing array?  It seems like mdadm wants to add
> new disks as spares.

mdadm --add /dev/md2 /dev/new/disk
mdadm --grow -n 3 /dev/md2

MfG
        Goswin
