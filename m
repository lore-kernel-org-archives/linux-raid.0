From: Federico Foschini <undicizeri@gmail.com>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sun, 9 Mar 2014 11:34:56 +0100
Message-ID: <CAFRU1Xui7cNnbOrqq8oFJAwU5UZ7vRuz3LHg160x9Auiz+jRfA@mail.gmail.com>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
 <531AF967.60500@grumpydevil.homelinux.org> <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com>
 <531B0229.7030800@grumpydevil.homelinux.org> <CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com>
 <531B1098.8080305@grumpydevil.homelinux.org> <531B6EA2.8080702@gmail.com>
 <CAFRU1Xs+hKhsJnRap2cARc=Z8W13sftna728WLJs3MGOM+VZag@mail.gmail.com>
 <531C1F3B.8050308@gmail.com> <CAFRU1Xsoxq679xd7vp60eKsOmM_QSdKLwE8BJ+TxAFoTQqJVYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFRU1Xsoxq679xd7vp60eKsOmM_QSdKLwE8BJ+TxAFoTQqJVYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I've consolidated the state of the system, these are the details:

http://pastebin.com/k7wGpw8F

Notice how /dev/md0 has the Name : petra:md1 and /dev/md1 doesn't have
any superblock. Also it appears there is an old mdadm superblock on
/dev/sda1 with my previous array configuration.

So now what I'm trying to achive is this configuration: removing the
hold partitions /dev/sda1 and /dev/sdb1 with the old superblock (by
the way how is it possible i'm using an array with /dev/sda and
/dev/sdb while these devices contains an old partition?) Configuring
correctly the raid 1 array with /dev/sdd and /dev/md0

2014-03-09 9:31 GMT+01:00 Federico Foschini <undicizeri@gmail.com>:
> Done and rebooted. I'm in the same condition as before. Also when I
> update the initrd a message said "/dev/md1 doesn't appear to be
> active"
>
> 2014-03-09 8:58 GMT+01:00 Can Jeuleers <can.jeuleers@gmail.com>:
>> On 03/08/2014 09:23 PM, Federico Foschini wrote:
>>> What is going on? Why /dev/md1 is now inactive and /dev/sdd is busy?
>>
>> I don't know Federico, but have you tried updating your initrd and
>> rebooting? So that the assembly that takes place at boot uses the same
>> configuration as it would post-boot?
>>
>
>
>
> --
> Federico Foschini.



-- 
Federico Foschini.
