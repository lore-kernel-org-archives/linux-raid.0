From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Why does md3 persist after deleting and recreating the partitions?
Date: Fri, 31 Dec 2010 00:12:52 +0000
Message-ID: <AANLkTikrCJMpvkzNQE-PC_r-Fk=zD+OSG=rnLAvqnR+O@mail.gmail.com>
References: <AANLkTik9quhP_h-vWji8nex8QT6X+_Ss2_KQiVSr5AK6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik9quhP_h-vWji8nex8QT6X+_Ss2_KQiVSr5AK6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 December 2010 00:10, Mark Knecht <markknecht@gmail.com> wrote:
> Hi,
> =C2=A0 What am I forgetting to do? I had a RAID1 using sd{a,b,c}3. I
> stopped md3, removed the md3 line in /etc/mdadm.conf, deleted the
> partitions using fdisk, and then created 5 new partitions using
> sd{a,b,c,d,e}3 to get ready to do a 5 disk RAID6. The new partitions
> are the same size as the old ones and located at the same sector
> addresses.
>
> =C2=A0 After rebooting, but before creating the new RAID6, I still se=
e md3:
>
> mark@c2stable ~ $ cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md6 : active raid1 sdb6[1] sdc6[2] sda6[0]
> =C2=A0 =C2=A0 =C2=A0247416933 blocks super 1.1 [3/3] [UUU]
>
> md3 : active raid1 sdc3[2] sdb3[1] sda3[0]
> =C2=A0 =C2=A0 =C2=A052436096 blocks [3/3] [UUU]
>
> md5 : active raid1 sdc5[2] sdb5[1] sda5[0]
> =C2=A0 =C2=A0 =C2=A052436032 blocks [3/3] [UUU]
>
> unused devices: <none>
> mark@c2stable ~ $
>
>
> =C2=A0 What am I doing wrong or forgetting? I would like md3 to be to=
tally
> gone before I create a new md3 in it's place.
>
> Thanks,
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Erase the superblocks? Recreating partitions doesn't (usually) affect
the data on the HDDs.

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
