From: linuxraid@valli.org
Subject: Re: 2010S issues (7902 issues)
Date: Wed, 14 Jan 2004 19:43:29 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <33838.194.153.176.133.1074105809.squirrel@mail.valli.org>
References: <400518E8.1060409@xs4all.nl>
     <36903.194.153.178.110.1074084208.squirrel@mail.valli.org>
     <20040114140816.GB73059@xs4all.nl>
     <28320.194.153.176.133.1074104524.squirrel@mail.valli.org>
     <20040114183052.GA15023@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040114183052.GA15023@xs4all.nl>
To: Jasper Slits <slits@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi jasper,
> On Wed, 14 Jan 2004, linuxraid@valli.org wrote:
>
>> Hi jasper,
>>
>> > ...
>> > i have to catch up reading about Gentoo's Live CD, afaik it works just
>> > like the Knoppix project.
>> >
>> > I presume i can take the:
>> > ftp://ftp.snt.utwente.nl/pub/os/linux/gentoo/releases/x86/1.4/livecd/pentium4/
>>
>> Gentoo is not only a LiveCD, it is also a full distro.
>> If you want to use gentoo, you have to compile everything by
>> yourself (emerge do it for you, it's something like apt-get)
>> There's a great installer doku:
>> http://www.gentoo.org/doc/en/gentoo-x86-install.xml
>>
>
> i already downloaded it and took a look at it. Looks just fine. The
> first screens look better than the avarage debian bootmenu :)
> i have to wait for a few days before i can start installing it, have
> some tests at school first. But i am confident the 2010S wont be a pain
> in the ass as i thought before.
>
> Not to spoil the fun, but can't i use a custom kernel (2.4.24 with 2010S
> support enabled) and make a native debian bootdisc out of it?

No idea, could be.

>
>> > ...
>> > let's hope it'll detect the 1Gbit broadcom controller ;)
>> No idea, but should work.
>>
>
> there's an onboard Intel 100mbit NIC too. i can use the eepro i hope.

This one works for sure with the LiveCD

>
>> > ...
>> > i should add the 3 /dev/sda* filesystems there i presume.
>> yes! give a look at another /etc/fstab at a already installed
>> debian machine
>>
>
> ack, i only have a couple of IDE machines. I can just do 'mount' and use
> that info to fill /etc/fstab.
>

Looks like the following:
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>          <options>              
<dump>  <pass>
/dev/sda3       /               reiserfs        defaults                0 
     0
/dev/sda1       /boot           ext3            defaults                0 
     2
/dev/sda2       none            swap            sw                      0 
     0
proc            /proc           proc            defaults                0 
     0

/dev/fd0        /floppy         auto            user,noauto             0 
     0
/dev/cdrom      /cdrom          iso9660         ro,user,noauto          0 
     0


>> > ...
>> >> - kernel configuration
>> >>   - DO NOT include 79xx support.
>> >>   - include Adaptec i20 RAID support (in scsi menu) i2o_dpt
>> >
>> > so the i20 detects both the 2010 and the 7902?
>>
>> No, the 2010s board detects 7902 and communicate with
>> this SCSI-controller; The kernel only communicate with
>> the Adaptec 2010s (It's a so called Zero Channel Raid
>> Controller, means it has not a SCSI-Controller onboard)
>>
>> Graphic: (<=> means comunicate)
>> Kernel <=> Adaptec 2010s <=> Adaptec 7902 <=> SCSI Harddrives
>>
>
> So you have to use the 7902 if you dont use the optional RAID
> controller. That makes sense.
> I am preparing stuff at my Athlon first and fiddle around with the
> LiveCD some more ;)
>
>

Kind regards,
valli

