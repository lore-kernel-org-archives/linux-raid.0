From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sat, 09 Feb 2013 01:19:05 +1100
Message-ID: <51150959.8070501@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com> <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com> <51149A66.6000308@websitemanagers.com.au> <DFB376BB-32B9-48DE-A7E9-A1B8F97982EF@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DFB376BB-32B9-48DE-A7E9-A1B8F97982EF@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Dave Cundiff <syshackmin@gmail.com>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/13 18:35, Chris Murphy wrote:
>=20
> On Feb 7, 2013, at 11:25 PM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>>=20
>>=20
>> On the remote machine.... NFS mount loop to present the NFS file as
>> a block device Xen which passes through the block device to domU
>> (Windows) disk partition partition is formatted NTFS
>=20
> Assuming the domU gets it's own IP, Windows will mount NFS directly.
> You don't need to format it. On the storage server, storage is ext4
> or XFS and can be on LVM if you wish.

Are you suggesting that MS Windows 2003 Server (without any commercial
add-on software) will boot from NFS and run normally (no user noticable
changes) with it's C: actually a bunch of files on an NFS server?

I must admit, if that is possible, I'll be... better educated. I don't
think it is, hence I've gone with iSCSI which allows me to present a
block device to windows. I had considered configuring windows to
actually boot from iSCSI, which I think is mostly possible, but apart
from the added complexity, I've also heard it ends up with worse
performance as the emulated network card is less efficient than the
emulated disk + native network card. (Also the host gets extra CPU
allocation than the windows VM).

>> I'm not sure, but it was my understanding that using block devices
>> was the most efficient way to do this=85.
>=20
> Depends on the usage. Files being copied and/or moved on the same
> storage array sounds like a file sharing context to me, not a block
> device requirement. And user report of write failures over iSCSI
> bothers me also. NFS is going to be much more fault tolerant, and all
> of your domUs can share one pile of storage. But as you have it
> configured, you've effectively over provisioned if each domU gets its
> own LV, all the more reason I don't think you need to do more over
> provisioning. And for now I think NFS vs iSCSI can wait another day,
> and that your problem lies elsewhere on the network.
>=20
> Do you have internet network traffic going through this same switch?
> Or do you have the storage network isolated such that *only* iSCSI
> traffic is happening on a given wire?

There isn't any actual "internet traffic" as that all comes into a linu=
x
firewall with ip forwarding disabled (and no NAT), only squid proxy, an=
d
SMTP is available to forward traffic out. In any case, yes, there is a
single 1G ethernet in each physical box which shares all the SAN
traffic, as well as the user level traffic.

>> ie, if a user logs into terminal server 1, and copies a large file
>> from the desktop to another folder on the same c:, then this=20
>> terminal server will get busy, possibly using a full 1Gbps through
>> the VM, physical machine, switch, to the storage server. However,
>> the storage server has another 3Gbps to serve all the other
>> systems.
>=20
> I think you need to replicate the condition that causes the problem,
> on the storage server itself first, to isolate this from being a
> network problem. And I'd do rather intensive read tests first and
> then do predominately write tests to see if there's a distinct
> difference (above what's expected for the RAID 5 write hit). And then
> you can repeat these from your domUs.

OK, well, I've started running some performance tests on the storage
server, I'd like to find out if they are "expected results", and then
will move on to test over the network.

> I'm flummoxed off hand if an NTFS formatted iSCSI block device
> behaves exactly as an NTFS formatted LV; ergo, is it possible (and
> OK) to unmount the volumes on the domUs, and then mount the LV as
> NTFS on the storage server so that your storage server can run local
> tests, simultaneously to those LVs. Obviously you should not mount
> the LVs on the storage server while they are mounted over iSCSI or
> you'll totally corrupt the file system (and it will let you do this,
> a hazard of iSCSI).

Yes, I've no problem mounting an LV directly on the storage server, I'v=
e
done that before for testing/migration of physical machines. Of course,
as you mentioned, not while the VM is actually running!

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
