From: linuxraid@valli.org
Subject: Re: 2010S issues (7902 issues HostRAID)
Date: Wed, 14 Jan 2004 21:54:32 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <27831.194.153.176.133.1074113672.squirrel@mail.valli.org>
References: <400518E8.1060409@xs4all.nl>
     <36903.194.153.178.110.1074084208.squirrel@mail.valli.org>
     <20040114140816.GB73059@xs4all.nl>
     <28320.194.153.176.133.1074104524.squirrel@mail.valli.org>
     <20040114183052.GA15023@xs4all.nl>
     <33838.194.153.176.133.1074105809.squirrel@mail.valli.org>
     <20040114193848.GA94311@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040114193848.GA94311@xs4all.nl>
To: Jasper Slits <slits@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi jasper,
> On Wed, 14 Jan 2004, linuxraid@valli.org wrote:
>
>> Hi jasper,
>> > On Wed, 14 Jan 2004, linuxraid@valli.org wrote:
>> >
>> >> Hi jasper,
>> >>
>> > there's an onboard Intel 100mbit NIC too. i can use the eepro i hope.
>>
>> This one works for sure with the LiveCD
>>
>
> ack
>
>> >> > ...
>> >> > i should add the 3 /dev/sda* filesystems there i presume.
>> >> yes! give a look at another /etc/fstab at a already installed
>> >> debian machine
>> >>
>> >
>> > ack, i only have a couple of IDE machines. I can just do 'mount' and
>> use
>> > that info to fill /etc/fstab.
>> >
>>
>> Looks like the following:
>> # /etc/fstab: static file system information.
>> #
>> # <file system> <mount point>   <type>          <options>
>> <dump>  <pass>
>> /dev/sda3       /               reiserfs        defaults
>> 0
>>      0
>> /dev/sda1       /boot           ext3            defaults
>> 0
>>      2
>> /dev/sda2       none            swap            sw
>> 0
>>      0
>> proc            /proc           proc            defaults
>> 0
>>      0
>>
>> /dev/fd0        /floppy         auto            user,noauto
>> 0
>>      0
>> /dev/cdrom      /cdrom          iso9660         ro,user,noauto
>> 0
>>      0
>>
>>
>
> hmmm, pretty straightforward ;) The whole sequence of commands  makes more
> sense now i
> see the /etc/fstab output :) thanx. I have read about the hotraid stuff
> at the linux.adaptec.com pages, is that a sort of software raid?
>

You mean the HostRAID stuff (not hotraid I think).
HostRaid is something like a build-in software raid (levels 0,1,10) in
the 7902 controller. (i think it's non-hotplug)
DO NOT WASTE YOUR TIME WITH THIS GARBAGE. I've already done it for you!
The aic79xx driver (of Justin T. Gibbs) in the kernel does not support
HostRAID.
I think there is currently no opensource HostRAID driver available
at all.

See also:
http://news.gw.com/freebsd.aic7xxx/797
http://mbserver.adaptec.com/view.php?bn=linux_scsi&key=1064363305&pattern=AIC-7902+hostraid
(It's a shame!)

> <cut>
>
>> Kind regards,
>> valli
>>
>

regards valli
