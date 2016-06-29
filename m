From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: URE, link resets, user hostile defaults
Date: Wed, 29 Jun 2016 13:48:04 +0300
Message-ID: <20160629104804.GS13212@reaktio.net>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <57736454.6050607@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57736454.6050607@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 29, 2016 at 08:01:56AM +0200, Hannes Reinecke wrote:
> On 06/28/2016 07:33 PM, Chris Murphy wrote:
> > On Tue, Jun 28, 2016 at 12:33 AM, Hannes Reinecke <hare@suse.de> wr=
ote:
> >> On 06/27/2016 06:42 PM, Chris Murphy wrote:
> >>> Hi,
> >>>
> >>> Drives with SCT ERC not supported or unset, result in potentially=
 long
> >>> error recoveries for marginal or bad sectors: upwards of 180 seco=
nd
> >>> recovers are suggested.
> >>>
> >>> The kernel's SCSI command timer default of 30 seconds, i.e.
> >>>
> >>> cat /sys/block/<dev>/device/timeout
> >>>
> >>> conspires to  undermine the deep recovery of most drives now on t=
he
> >>> market. This by default misconfiguration results in problems list
> >>> regulars are very well aware of. It affects all raid configuratio=
ns,
> >>> and even affects the non-RAID single drive use case. And it does =
so in
> >>> a way that doesn't happen on either Windows or macOS. Basically i=
t is
> >>> linux kernel induced data loss, the drive very possibly could pre=
sent
> >>> the requested data upon deep recovery being permitted, but the
> >>> kernel's command timer is reached before recovery completes, and
> >>> obliterates any possibility of recovering that data. By default.
> >>>
> >>> This now seems to affect the majority of use cases. At one time 3=
0
> >>> seconds might have been sane for a world with drives that had les=
s
> >>> than 30 second recoveries for bad sectors. But that's no longer t=
he
> >>> case.
> >>>
> >> 'Majority of use cases'.
> >> Hardly. I'm not aware of any issues here.
> >=20
> > This list is prolific with this now common misconfiguration. It
> > manifests on average about weekly, as a message from libata that it=
's
> > "hard resetting link". In every single case where the user is
> > instructed to either set SCT ERC lower than 30 seconds if possible,=
 or
> > increase the kernel SCSI command timer well above 30 seconds (180 i=
s
> > often recommended on this list), suddenly the user's problems start=
 to
> > go away.
> >=20
> > Now the md driver gets an explicit read failure from the drive, aft=
er
> > 30 seconds, instead of a link reset. And this includes the LBA for =
the
> > bad sector, which is apparently what md wants to write the fixup ba=
ck
> > to that drive.
> >=20
> > However the manifestation of the problem and the nature of this lis=
t
> > self-selects the user reports. Of course people with failed mdadm
> > based RAID come here. But this problem is also manifesting on Btrfs
> > for the same reasons. It also manifests, more rarely, with users wh=
o
> > have just a single drive if the drive does "deep recovery" reads on
> > marginally bad sectors, but the kernel flips out at 30 seconds
> > preventing that recovery. Of course not every drive model has such
> > deep recoveries, but by now it's extremely common. I have yet to se=
e a
> > single consumer hard drive, ever, configured out of the box with SC=
T
> > ERC enabled.
> >=20
> So we should rather implement SCT ERC support in libata, and set ERC =
to
> the scsi command timeout, no?
> Then the user could tweak the scsi command timeout however he likes i=
t
> to, and that timeout would be reflected into the ERC setting.
>=20
> And then we could add an initialisation bit which reads the current E=
RC
> values, increasing the SCSI command timeout as required.
>=20

But this still leaves the "consumer" (non-NAS, non-RAID) drives broken =
as a default,
until the user tweaks the SCSI command timeout for the disk to much big=
ger value (longer than the drive's internal timeout, whatever it is, 18=
0 seconds or so..) ?=20



-- Pasi


> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
