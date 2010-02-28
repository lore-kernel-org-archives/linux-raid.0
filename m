From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Sun, 28 Feb 2010 13:52:07 +0100
Message-ID: <4B8A66F7.2090603@stud.tu-ilmenau.de>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at> <4B862F2C.5030302@texsoft.it> <4B86A943.3040804@anonymous.org.uk> <4B8A5887.4080102@stud.tu-ilmenau.de>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8A5887.4080102@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry @all, I had a few typos:

Stefan /*St0fF*/ H=FCbner schrieb:
> [...]
> BUT: if the drive takes let's say 2 min for internal error recovery t=
o
> succeed of fail (whichever, doesn't matter), then the SG EH layer of =
the

-> succeed OR fail

> kernel will drop the disk, not md.  This forces md to drop the disk,
> also.  The conclusion is: a technology is needed to prevent another
> kernel level from dropping the disk.  This technology exists, it's
> called SCT-ERC (Smart Control Transport - Error Recovery Control).  I=
t's
> the same as WD's TLER or Samsung's CCTL.  But it is non-volatile.  Af=
ter

-> But it is volatile.

> a power on reset the timeout-values are reset to factory defaults.  S=
o
> it needs to be set right before adding a disk to an array.
> (for more info: check www.t13.org, find the ATA8-ACS documents)
>> I do think we urgently need the hot reconstruction/recovery feature,=
 so
>> failing drives can be recovered to fresh drives with two sources of
>> data, i.e. both the failing drive and the remaining drives in the ar=
ray,
>> giving us two chances of recovering every sector.
>=20
> I do not think this is easily possible.  One would have to keep a map
> about the "in sync" sectors of an array member and the "failed" secto=
rs.
>  My guess is: this would need a partial redesign (again a new superbl=
ock
> type containing information about "failed segments" probably).
> Please correct me if I'm wrong and that is already included in 1.X (I=
'm
> mostly working on 0.90 Superblocks).
>> Cheers,
>>
>> John.
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Cheers,
> Stefan.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
