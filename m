From: Beolach <beolach@gmail.com>
Subject: Re: data scrubbing
Date: Fri, 29 Jul 2011 14:48:44 -0600
Message-ID: <CADc_k_uV2eOpK+tNxpph3ky2J0OOf_LPF7cNK7f5fPAFpy4Dpw@mail.gmail.com>
References: <4E327445.9080404@oldum.net> <alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>
 <4E32B4D3.3030905@oldum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E32B4D3.3030905@oldum.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 29, 2011 at 07:25, Nikolay Kichukov <hijacker@oldum.net> wr=
ote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi,
>
> This is a good to know!
>
> Just performed a check on a raid1 and got:
>
> Jul 29 15:37:36 hanna64 mdadm[2277]: RebuildFinished event detected o=
n md device /dev/md1, component device =C2=A0mismatches
> found: 128
>
> So I presume those mismatches have now been rewritten to both disks s=
uccessfully. Am I wrong there?
>
> cat /sys/block/md1/md/mismatch_cnt
> 128
>
>

That depends on if you did a "check" or a "repair" - see the SCRUBBING
AND MISMATCHES section of the md(4) man page:
"If  check  was used, then no action is taken to handle the mismatch,
it is simply recorded.  If repair  was  used,  then  a  mismatch  will
 be repaired  in  the same way that resync repairs arrays."


Good luck,
Beolach
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
