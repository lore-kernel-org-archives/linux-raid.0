From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: system startup hangs
Date: Wed, 7 Dec 2011 23:01:06 +0000
Message-ID: <CADNH=7EZo9j-raoWh9EkcuRw1sCC3YC672jpA6OTsVMgqjbCaw@mail.gmail.com>
References: <4EDFEACD.3010806@kinfolk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EDFEACD.3010806@kinfolk.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Richard B. Pyne" <rpyne@kinfolk.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 December 2011 22:38, Richard B. Pyne <rpyne@kinfolk.org> wrote:
> Please forgive me if I ask stupid questions, I am fairly new to linux=
 raid
> and most of the documentation I can find is severely outdated and/or =
written
> for someone who already understands linux raid.
>
> I have successfully built a set raid 6 array with 4 drives and have c=
opied
> my system partitions onto the raid drives. I then reboot with root=3D=
/dev/md0.
>
> Everything looks like it is working right up through:
>
> md/raid:md0 raid level 6 active with 4 out of 4 devices, algorithm 2
> md0: detected capacity change from 0 to 1000131788
> md: autorun DONE.
> md0: unknown partition table
> EXT3-fs (md0): error: couldn't mount because of unsupported optional
> features
> EXT2-fs (md0): error: couldn't mount because of unsupported optional
> features
> EXT4-fs (md0): mounted filesystem with ordered data mode. =C2=A0Opts:=
 (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
> freeing unused kernel memory: 472k freed
>
>
> at which point it just hangs. No more disk access, no more messages.
>
>
> The system has 5 WD Caviar Black 500GB drives. I did the linux instal=
l on
> the first drive and built the other 4 drives into the raid system, pl=
anning
> to move everything (except the /boot partition) on to the raid array =
and
> then repartition everything except the /boot partition on the first d=
rive
> and add it to the raid.
>
> I currently have md0 for / md1 for /home md2 for /usr md3 for /var an=
d md4
> on which I plan on running lvm to allocate to other system needs.
>
> Any advice, insights and/or direction will be greatly appreciated.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

So you created 1 RAID6 volume. That is now "1 RAID drive", i.e. md0.

Did you create partitions on md0? Or did you make it a physical volume
(PV) with LVM?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
