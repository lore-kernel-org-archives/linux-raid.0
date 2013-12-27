From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 18:32:48 +0100
Message-ID: <52BDB9C0.2020906@assyoma.it>
References: <52BD8EDD.10809@assyoma.it>	<52BD99BC.8000205@assyoma.it> <21181.46549.590241.76206@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21181.46549.590241.76206@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> <snip>
> Therefore the *probability* of loss of data because of 2 member
> devices failing is higher in layout 1) than layout 2), whether
> or not the drives are "adjacent".
>
>    Note that arguably layout 1) is not really RAID10, because an
>    important property of RAID10 is or should be that there are
>    only N/2 pairs out of N drives. Otherwise it is not quite
>    'RAID1' if a chunk position in a stripe can be replicated on 2
>    other devices, half the replicas on one and half on another.
>
> That the member devices are *adjacent* is irrelevant; what
> matters is the statistical chance, which is driven by the
> percent of cases where 2 failures result in data loss, which
> driven by the number of paired drives.

Very detailed answer, thank you Peter :)

Based on what keld told before, the current scheme if n.2 (wikipedia's 
one), right? It is possible, using mdadm, understand the physical layout 
(if n.1 or n.2) of a live RAID10 array?

As schema n.1 lead to increased probability of data loss, why offset 
layout use it instead of, say, some variance of schema n.2?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
