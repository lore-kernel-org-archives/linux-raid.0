From: Steven Dake <sdake@mvista.com>
Subject: Re: cluster raid
Date: Wed, 30 Apr 2003 13:52:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB03795.7040108@mvista.com>
References: <D397A7FACCC45A44A0A207FD892961EA03B2DA3C@mail.intra.cet.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D397A7FACCC45A44A0A207FD892961EA03B2DA3C@mail.intra.cet.pt>
To: Miguel Biscaia <miguel-b-pias@ptinovacao.pt>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Miguel,

My company (MontaVista software) is funding me to work on a solution fo=
r=20
this for some time.  It requires node-node=20
communication/membership/locking/master failover and hence a cluster=20
manager.  I am nearing completion of the cluster manager currently, and=
=20
then will work on the cluster services required to support md.  I'll=20
post to this list once I have something working that I can open source.

You cannot currently have two devices open on multiple nodes.  It is=20
possible to use RAIDs in shared storage where each node only opens up=20
"its" assigned RAID devices.  This can be enforced by RAID locking (see=
=20
the list for a patch for this technique).  I have a patch which locks=20
based upon geographical address/slot#, fibrechannel WWN, scsi host # bu=
t=20
I have not had time to make this available and there wasn't a big=20
response when I posted the original patch.

Thanks
-steve

Miguel Biscaia wrote:

>Hello,
>At my company we are implementing a shared disk database arquitecture =
for
>telecom call processing, based on Linux. I would like to use MD device=
s,
>although I=B4m not aware if the MD devices can be configured and start=
ed in
>cluster environments. Is it possible? In which kernel version?
>
>Thanks in advance.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> =20
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
