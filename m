From: Hannes Reinecke <hare@suse.de>
Subject: Re: URE, link resets, user hostile defaults
Date: Wed, 29 Jun 2016 08:01:56 +0200
Message-ID: <57736454.6050607@suse.de>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/28/2016 07:33 PM, Chris Murphy wrote:
> On Tue, Jun 28, 2016 at 12:33 AM, Hannes Reinecke <hare@suse.de> wrot=
e:
>> On 06/27/2016 06:42 PM, Chris Murphy wrote:
>>> Hi,
>>>
>>> Drives with SCT ERC not supported or unset, result in potentially l=
ong
>>> error recoveries for marginal or bad sectors: upwards of 180 second
>>> recovers are suggested.
>>>
>>> The kernel's SCSI command timer default of 30 seconds, i.e.
>>>
>>> cat /sys/block/<dev>/device/timeout
>>>
>>> conspires to  undermine the deep recovery of most drives now on the
>>> market. This by default misconfiguration results in problems list
>>> regulars are very well aware of. It affects all raid configurations=
,
>>> and even affects the non-RAID single drive use case. And it does so=
 in
>>> a way that doesn't happen on either Windows or macOS. Basically it =
is
>>> linux kernel induced data loss, the drive very possibly could prese=
nt
>>> the requested data upon deep recovery being permitted, but the
>>> kernel's command timer is reached before recovery completes, and
>>> obliterates any possibility of recovering that data. By default.
>>>
>>> This now seems to affect the majority of use cases. At one time 30
>>> seconds might have been sane for a world with drives that had less
>>> than 30 second recoveries for bad sectors. But that's no longer the
>>> case.
>>>
>> 'Majority of use cases'.
>> Hardly. I'm not aware of any issues here.
>=20
> This list is prolific with this now common misconfiguration. It
> manifests on average about weekly, as a message from libata that it's
> "hard resetting link". In every single case where the user is
> instructed to either set SCT ERC lower than 30 seconds if possible, o=
r
> increase the kernel SCSI command timer well above 30 seconds (180 is
> often recommended on this list), suddenly the user's problems start t=
o
> go away.
>=20
> Now the md driver gets an explicit read failure from the drive, after
> 30 seconds, instead of a link reset. And this includes the LBA for th=
e
> bad sector, which is apparently what md wants to write the fixup back
> to that drive.
>=20
> However the manifestation of the problem and the nature of this list
> self-selects the user reports. Of course people with failed mdadm
> based RAID come here. But this problem is also manifesting on Btrfs
> for the same reasons. It also manifests, more rarely, with users who
> have just a single drive if the drive does "deep recovery" reads on
> marginally bad sectors, but the kernel flips out at 30 seconds
> preventing that recovery. Of course not every drive model has such
> deep recoveries, but by now it's extremely common. I have yet to see =
a
> single consumer hard drive, ever, configured out of the box with SCT
> ERC enabled.
>=20
So we should rather implement SCT ERC support in libata, and set ERC to
the scsi command timeout, no?
Then the user could tweak the scsi command timeout however he likes it
to, and that timeout would be reflected into the ERC setting.

And then we could add an initialisation bit which reads the current ERC
values, increasing the SCSI command timeout as required.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
