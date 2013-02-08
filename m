From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 17:15:18 +1100
Message-ID: <511497F6.4060108@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/13 10:48, Chris Murphy wrote:
>=20
> ***On Feb 7, 2013, at 6:08 AM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>> Basically, on occasion, when a user copies a large file from disk
>> to disk, or when a user is using Outlook (frequently data files are
>> over 2G), or just general workload, the system will "stall",
>> sometimes causing user level errors, which mostly affects Outlook.
>=20
> Does this concern anyone else? In particular the user doing "disk to
> disk" large file copies. What is this exactly? LV to LV with iSCSI
> over 1gigE? Why did you reject NFS for these physical Windows boxes
> and their VMs to access this storage, rather than what I assume is
> NTFS over iSCSI, because of this statement?

This isn't a common thing (well, it happens once a week when a user log=
s
in after hours to do some sort of backup/DB maintenance), but it is the
easiest way to reproduce the problem, and from the evidence, it seems t=
o
match.

ie, generally the problem is characterized as:
1) Large amount of read and write on one iSCSI device
2) User complain about write failures, slow response, etc even when 1
and 2 are on different VM's (which are on different physical machines).

>> Each LV is then exported via iSCSI
> That block device needs a file system for Windows to use it.
>=20
> It also seems to me one or more of these physical servers running
> VMs, with only 1gigE to the storage server, need either additional
> pipes LACP or bonded ethernet, or 10gigE. I can just imagine one
> person doing a large file copy disk to disk, which is a single pipe
> doing a pull push, double NTFS packet overhead, while all other
> activities get immensely hit with network latency as a result.

However, this should only cause issues for users on the server which is
doing this. ie, if a user logs into terminal server 1, and copies a
large file from the desktop to another folder on the same c:, then this
terminal server will get busy, possibly using a full 1Gbps through the
VM, physical machine, switch, to the storage server. However, the
storage server has another 3Gbps to serve all the other systems. Also,
100MB/s is not an unreasonable performance level for a single system
(ok, minus overhead, even 60MB/s would probably equal what they had
before with 10 year old SCSI disks).

> ###On Feb 7, 2013, at 4:07 AM, Dave Cundiff <syshackmin@gmail.com>
> wrote:
>=20
>> See page 17 for a block diagram of your motherboard=85 Your SSDs=20
>> alone could saturate that if you performed a local operation. Get
>> your NIC's going at 4Gig and all of it a sudden you'll really want
>> that SATA card in slot 4 or 5.
>=20
> Yeah I think it needs all the network performance and reduced latency
> as he can get. I'll be surprised if the SSD tuning alone makes much
> of a dent with this.

I still need to go in (tomorrow night) and pull apart the machine
physically to confirm which slot the network cards are in, but based on
the other comments, I don't think this is the limiting factor.... Slap
me if it is and I'll drive in tonight and check it sooner.

Thanks,
Adam

--=20
Adam Goryachev
Website Managers
www.websitemanagers.com.au
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
