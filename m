From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sun, 09 Mar 2014 12:30:55 +0100
Message-ID: <531C50EF.3080405@grumpydevil.homelinux.org>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com> <531AF967.60500@grumpydevil.homelinux.org> <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com> <531B0229.7030800@grumpydevil.homelinux.org> <CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com> <531B1098.8080305@grumpydevil.homelinux.org> <531B6EA2.8080702@gmail.com> <CAFRU1Xs+hKhsJnRap2cARc=Z8W13sftna728WLJs3MGOM+VZag@mail.gmail.com> <531C1F3B.8050308@gmail.com> <CAFRU1Xsoxq679xd7vp60eKsOmM_QSdKLwE8BJ+TxAFoTQqJVYQ@mail.gmail.com> <CAFRU1Xui7cNnbOrqq8oFJAwU5UZ7vRuz3LHg160x9Auiz+jRfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFRU1Xui7cNnbOrqq8oFJAwU5UZ7vRuz3LHg160x9Auiz+jRfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico Foschini <undicizeri@gmail.com>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09-03-14 11:34, Federico Foschini wrote:
> Hello,
> I've consolidated the state of the system, these are the details:
>
> http://pastebin.com/k7wGpw8F
>
> Notice how /dev/md0 has the Name : petra:md1 and /dev/md1 doesn't have
> any superblock. Also it appears there is an old mdadm superblock on
> /dev/sda1 with my previous array configuration.
>
> So now what I'm trying to achive is this configuration: removing the
> hold partitions /dev/sda1 and /dev/sdb1 with the old superblock (by
> the way how is it possible i'm using an array with /dev/sda and
> /dev/sdb while these devices contains an old partition?) Configuring
> correctly the raid 1 array with /dev/sdd and /dev/md0
>
Your old raid config used not the whole disk, but partitions on the 
disks. That means the location of the md superblock is different. Thus 
you can create the above situation.

Do you have data on the raid? If not, or if easily re-created, it might 
be best to ensure all old traces are gone before rebuilding.

There are several ways to wipe old superblocks, or a partition table you 
no longer want. For partition table, use you favourite partition program 
and let it create a new table. Write the table out without any partitions.

to wipe old mdadm superblocks,  mdadm /dev/sda1 --zero-superblock, and 
repeat for each partition where you have an old superblock

Cheers



