From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 13:57:35 +0000
Message-ID: <CADNH=7G7PoZxecGCbMuKohoov6TC-GyYgyCaryHaikp4oss3qw@mail.gmail.com>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 November 2011 13:53, Alex <mysqlstudent@gmail.com> wrote:
> Hi,
> I have a fedora15 system with two 80GB SATA disks using RAID1 and hav=
e
> the following messages in syslog:
>
> Nov =C2=A04 07:43:11 mail smartd[2001]: Device: /dev/sda [SAT], 2 Off=
line
> uncorrectable sectors
> Nov =C2=A04 08:13:11 mail smartd[2001]: Device: /dev/sda [SAT], 2 Cur=
rently
> unreadable (pending) sectors
>
> "smartctl --all /dev/sda" does show that errors did occur at some
> point in the past, but it doesn't seem to be affecting the RAID:
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sda2[0] sdb2[1]
> =C2=A0 =C2=A0 =C2=A074750908 blocks super 1.1 [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 1/1 pages [4KB], 65536KB chunk
>
> md0 : active raid1 sda1[0] sdb1[1]
> =C2=A0 =C2=A0 =C2=A0511988 blocks super 1.0 [2/2] [UU]
>
> unused devices: <none>
>
> Perhaps the bad sectors haven't been accessed, which is why the RAID
> still appears to be intact?
>
> Do I need to verify the RAID integrity in some way? Force a rebuild?
>
> I believe the boot sector is installed on sda, which is also the bad
> disk. If I remove the disk to replace it, I'm concerned the system
> will no longer boot.
>
> Can you point me to instructions on the best way to replace a disk?
>
> Thanks,
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi,

Basically, if uncorrectable sectors >0 or pending sectors >0 the drive
is failing. So replace ASAP :)

Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
