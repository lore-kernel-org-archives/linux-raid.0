From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 18 Sep 2009 12:57:23 +0300
Message-ID: <70ed7c3e0909180257hf13ba48va808b942deaba177@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nfoe$n8p$3@ger.gmane.org> <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>
	<1253106813.17888.9.camel@localhost> <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
	<20090918082851.GD22909@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090918082851.GD22909@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the insight, Robin.

I already have used dd_rescue to find which sectors are bad, so I
guess I could either wait for Matthias to finish his modifications to
mdadm, or I can reconstruct the bad sectors manually (read same sector
from other disks, xor all, write to damaged disk's clone).

Weird thing though, is that when I re-read some of the bad sectors, I
didn't get I/O errors ... it's confusing!

Also, I'd rather avoid a fsck when I have bad sectors to not lose
files. I'll run fsck once I've fixed the bad sectors and resynced the
array.

On Fri, Sep 18, 2009 at 11:28 AM, Robin Hill <robin@robinhill.me.uk> wr=
ote:
> All the 'check' action does is validate that the checksum matches the
> data. =C2=A0By doing this, it will also be doing a full read check on=
 the
> array (though I'm not certain what action is taken on read failures).
> The 'repair' action will also rewrite any checksums which don't match
> the data.
>
> All of this requires a non-degraded array, so I suspect the 'check' a=
nd
> 'repair' actions will get ignored altogether on a degraded array (and
> certainly won't actually work). =C2=A0As the array is degraded, you _=
can't_
> have any RAID inconsistencies. =C2=A0You may have some filesystem
> inconsistencies (a fsck is definitely recommended) and/or data
> inconsistencies (unless you have checksums or backups to compare agai=
nst
> then you're stuck on finding these though).
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
