From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Fri, 8 Feb 2013 00:35:00 -0700
Message-ID: <DFB376BB-32B9-48DE-A7E9-A1B8F97982EF@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com> <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com> <51149A66.6000308@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51149A66.6000308@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Phil Turmel <philip@turmel.org>, Dave Cundiff <syshackmin@gmail.com>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 7, 2013, at 11:25 PM, Adam Goryachev <mailinglists@websitemanage=
rs.com.au> wrote:
>=20
>=20
> On the remote machine....
> NFS mount
> loop to present the NFS file as a block device
> Xen which passes through the block device to domU (Windows)
> disk partition
> partition is formatted NTFS

Assuming the domU gets it's own IP, Windows will mount NFS directly. Yo=
u don't need to format it. On the storage server, storage is ext4 or XF=
S and can be on LVM if you wish.

> I'm not sure, but it was my understanding that using block devices wa=
s
> the most efficient way to do this=85.

Depends on the usage. Files being copied and/or moved on the same stora=
ge array sounds like a file sharing context to me, not a block device r=
equirement. And user report of write failures over iSCSI bothers me als=
o. NFS is going to be much more fault tolerant, and all of your domUs c=
an share one pile of storage. But as you have it configured, you've eff=
ectively over provisioned if each domU gets its own LV, all the more re=
ason I don't think you need to do more over provisioning. And for now I=
 think NFS vs iSCSI can wait another day, and that your problem lies el=
sewhere on the network.

Do you have internet network traffic going through this same switch? Or=
 do you have the storage network isolated such that *only* iSCSI traffi=
c is happening on a given wire?

> ie, if a user logs into terminal server 1, and copies a
> large file from the desktop to another folder on the same c:, then th=
is
> terminal server will get busy, possibly using a full 1Gbps through th=
e
> VM, physical machine, switch, to the storage server. However, the
> storage server has another 3Gbps to serve all the other systems.

I think you need to replicate the condition that causes the problem, on=
 the storage server itself first, to isolate this from being a network =
problem. And I'd do rather intensive read tests first and then do predo=
minately write tests to see if there's a distinct difference (above wha=
t's expected for the RAID 5 write hit). And then you can repeat these f=
rom your domUs.

I'm flummoxed off hand if an NTFS formatted iSCSI block device behaves =
exactly as an NTFS formatted LV; ergo, is it possible (and OK) to unmou=
nt the volumes on the domUs, and then mount the LV as NTFS on the stora=
ge server so that your storage server can run local tests, simultaneous=
ly to those LVs. Obviously you should not mount the LVs on the storage =
server while they are mounted over iSCSI or you'll totally corrupt the =
file system (and it will let you do this, a hazard of iSCSI).


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
