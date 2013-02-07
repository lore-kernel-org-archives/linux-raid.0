From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 16:48:11 -0700
Message-ID: <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


***On Feb 7, 2013, at 3:03 PM, Chris Murphy <lists@colorremedies.com> w=
rote:
>=20
> TRIM probably does reduce the need for the firmware to do its own sta=
tic wear leveling, but I don't know if it's that significant except for=
 large deletions.

In this case it helps via dynamic over provisioning. Less over provisio=
ning is needed if unused pages/blocks can be made available (erased).



***On Feb 7, 2013, at 6:08 AM, Adam Goryachev <mailinglists@websitemana=
gers.com.au> wrote:
>=20
> Though, like I said, would adding an extra SSD to the RAID5, and
> reducing the size of all partitions by 20%, and then doing TRIM on th=
at
> newly freed space, would that improve performance because of the extr=
a
> free space the SSD can "work with" ?


It might help eventually, but I don't think this is the magic bullet yo=
u're looking for. Have you looked at network congestion when this probl=
em is happening?

> Basically, on occasion, when a user copies a
> large file from disk to disk, or when a user is using Outlook
> (frequently data files are over 2G), or just general workload, the
> system will "stall", sometimes causing user level errors, which mostl=
y
> affects Outlook.

Does this concern anyone else? In particular the user doing "disk to di=
sk" large file copies. What is this exactly? LV to LV with iSCSI over 1=
gigE? Why did you reject NFS for these physical Windows boxes and their=
 VMs to access this storage, rather than what I assume is NTFS over iSC=
SI, because of this statement?

> Each LV is then exported via iSCSI


That block device needs a file system for Windows to use it.

It also seems to me one or more of these physical servers running VMs, =
with only 1gigE to the storage server, need either additional pipes LAC=
P or bonded ethernet, or 10gigE. I can just imagine one person doing a =
large file copy disk to disk, which is a single pipe doing a pull push,=
 double NTFS packet overhead, while all other activities get immensely =
hit with network latency as a result.


###On Feb 7, 2013, at 4:07 AM, Dave Cundiff <syshackmin@gmail.com> wrot=
e:

> See page 17 for a block diagram of your motherboard=85
> Your SSDs
> alone could saturate that if you performed a local operation. Get you=
r
> NIC's going at 4Gig and all of it a sudden you'll really want that
> SATA card in slot 4 or 5.

Yeah I think it needs all the network performance and reduced latency a=
s he can get. I'll be surprised if the SSD tuning alone makes much of a=
 dent with this.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
