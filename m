From: Andre Tomt <andre@tomt.net>
Subject: Re: mdadm creating raid5 with all spare disks
Date: Fri, 11 Dec 2009 10:08:44 +0100
Message-ID: <4B220C1C.1040902@tomt.net>
References: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com> <20091211071006.56270ebf@notabene.brown> <91296851101702456968380052308470713510-Webmail@me.com> <4B2196B0.2090604@sauce.co.nz> <6E2CD5BC-5F08-44A0-869C-1875DF5CCA9F@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6E2CD5BC-5F08-44A0-869C-1875DF5CCA9F@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: Richard Scobie <richard@sauce.co.nz>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11.12.2009 02:01, Matt Tehonica wrote:
> On Dec 10, 2009, at 7:47 PM, Richard Scobie <richard@sauce.co.nz> wro=
te:
<snip>
>> Looks like the drives are being dropped by the controller.
>>
>> I believe there was some recent discussion here about mv_sas, md and
>> failures under heavy I/O load.
>
> Thanks Richard! After some more review I found many people with this
> problem and appears the linux-scsi devs submitted patches mid last
> month. Building the latest kernel as we speak!

=46YI; The fixes has not made it to mainline yet so 2.6.32 and 2.6.33-g=
it=20
is still broken with this driver. Not sure if they've landed in some=20
scsi tree yet but manually applying patches 1-6 from the linux-scsi=20
mailing list worked for me, at least to the point that it is now usable=
=20
(patch 7 is for some libsas change not in 2.6.32).

On a related note, mptsas driver also seems to have issues with newer=20
HBA's. Non-RAID SAS HBA's doesn't seem to be in a very good shape in=20
Linux nowadays. Might give a mpt2sas driven controller a spin soon,=20
curious on how that pans out..

--=20
Andr=E9
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
