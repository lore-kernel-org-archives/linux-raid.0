Received: from sonic302-3.consmr.mail.bf2.yahoo.com (sonic302-3.consmr.mail.bf2.yahoo.com [74.6.135.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2149128366
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 18:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.135.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706119587; cv=none; b=TXOcyMvwTzkYunnDEREF7DIlQlfj/s7isEInRmTgG8fx3DO3OEvPltKLiNmONUn5Nfd0V4zE9FYKaMxEC9/pci+0H7jY52Hm3oo5wvREPB3egO45ovGzsduMbohJNa0yiql68lQeKfHOo5hggcCHpCdRbLkfAckl1hkNJkwvc+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706119587; c=relaxed/simple;
	bh=mMFai6Y8PRkMAd7u6UoMxcnRcclX6E04T5WCPS61FNM=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=c3M93NlcUXzkzKi3WARDtrepGwuNK1zXu/fpmyO83vmO5ETlj6giLhrYN3rx0f07c+UxFr4ch2MWiQaMZFn+NQFGMZLxAK/eYhDLVYNlIWfshqkykSOyONHzmqCsrNH1x9CnytaBu1oAx0KgM7Ez70o9kOybz+/2fryFFl0U78g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=LRTv/ag6; arc=none smtp.client-ip=74.6.135.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="LRTv/ag6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706119583; bh=mMFai6Y8PRkMAd7u6UoMxcnRcclX6E04T5WCPS61FNM=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=LRTv/ag6AKTjbcfmcVHaHnmHSk720i7FoiHXsRbSNvFugvCXML7ZuIVJ2nRoFN3y0fPO4xLGnDprpw6PPyIGCQWT2N6mZcBG9rjyPWPMw228OyJJXOhjs93dElt3U5cHqgssOmX8OltNzbHWZN2mIYHahtKKwDCj7neHBcxIcXuwBdckIcoeAMAqeGTh/TF70F0BQRaw9mra3NA6Tgq18oXIb7sHoyiybq1+bbJG5UNEt8joywdGEtClpkwZvAlpsOll4iqCxg6S7j0p1Xn3cHLUnttVlzPSMJreZf9IGnG3ph1rnPs1DMtr9Y4xFB3qc95QOlifxCYK9UGa5s+2Xg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706119583; bh=ie6LPlcm1ZkJw0z56PlWqPv/H0yKWpBqHEtGc2gy53W=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=dz6Zx3OU2K65MQ4qtQMQVu0bbnXdXtCmYpo5Mq4Tq+mz3cBE/OK0roVoMg+iWJA9SLGzPv1CWHCkzY7WwZrF47aVL2eaKX9/S2Ugpsq0UhEyEgVYO2xYj5Sv7zL8c9rMUjHoIMZHoLIqjTxeEMwITRr68g9wGHWk8uoZp+7MyEfulvaf+mM3A+9QBYHu0YQTtfsDfzJVz/IhqjOXChJkNJSfzqKoOQfXZi0eUK9Y3aTWmwqNOd14+kwsGrMCTHgN3EO+6X2gbY1PIKlWjTXMg2rzjiTq4gQtAu5qVtFgOgZ6akJ89Sz4MXd7iRRK9STXeIF0mswWurI+hUIVXw42lg==
X-YMail-OSG: 7ECRqcsVM1mUpKNmLMn4YznNrEk5QOB3Udb3mV6Wz9agQvxbOVO_4g8oaxDwMNF
 beZC_ms1p9vt_GwzHzK5KYobuOwnKjGc3vDbnPbPAXjLVQbwGhUSIuH6cwqxtn5IdPBPE6y.qaDQ
 zpWn2uewchxGPHuKSceeYKF7XohFxjaxpY3BxJm8mjBrfM6dmgMVDUnysW93jkUMf2sas6KJwrgk
 WDDhjzmciODTWhF.zlZisQqrYimHaggh5eVfwQJjZ.Uqb9mKAVUyVsveDv4RnBw2ZbWEMMr5hhsu
 UotDKf7TDS3fDNTJv.xt4bFdQnQ4tk.ikrDfCE3ix1LSGAf3aR42ZyO5mVIPcb2hMrJ1t7lim9nO
 XkuICKsrcCcHp.8S0qhDfSks10sO81QXi1gySu8dPM9j2TwLmMU5ZU1NJawJR._wfcA2vYDESOCW
 eJgYZ9GM3TJv4jdoMXr5.i4SF6xUHGG.jYwveDasg7MKSUuBxa_lZz3VQUbJzbPxInd3idPcPwhi
 W1J58Zrh_jTpkqefVg7fq.DwyO8MrUrkUjiZmkdrGjpBzc8fFkLUYvoC6HpYcbHVKjmNb6xWV6LY
 demvCqTxcOnaWUrY9eLOsTrT4TSUK7jy0bJwrM_IOF9WWoRO6Odymt5CMBNaEwniy84iVQF6QHZI
 kWUeNwDcYj8UzJufpvrEdTkNX_7JHcpxsUwIg3To_1IngGiny2tupGvbvOt.s8PV8TD0IW0Ln3nx
 nKT6eNlR13vCGZDrOPI7RBNTNo1wrsfv7pOvfFoVmo7NbDXiAlJtrmQZfA.6xJ8bx.fkYtZI7me2
 c1XIRvQ.V6L9jZR_WlqDT5WWB.Phh4qcGdReZO_wPHepc_eSf1XO3W6DqO3CDDo_cnfqF7eIejJu
 x8a1fnmVOhix7gW7dRcvKRUhkQbAkBIwnCAUHisqd0qX7ipzXhLXLiA651dtsTFdlLXalrL2ToMF
 RXFrjSPMNJBErNVnwvOAsUeG.jCOkrzH4trgzCbxjpz_9Z9LzUE7o4IMTmYHH23LRVq1ssb7ij_X
 6Px_ER.9dIMbS1Jyzx2NcgWMhTw98qdPTpZ_djZdcnvVq5beNRj7VPH6ukNUk1DxmWc4bWQRRNWg
 VpDGcx.u655897zA4C9VhtDz8rKBH.L68ik74.mCRREGEKHLt_sZJZGr1BYLp1SMgZzyWjhrBoIe
 Q9nR_JzV6AFcYd695XcpcGh07iFFKo9lD73V3_OOGcGrc6i2K6c4fJ0QeN6ndnR62Xx9daXCPZfo
 wSAcrJFO3WTM2qbdgc9s.0KOXfZvUg2az65ys7xqroosmKyE_hhtZjbRIfyrJQQf3f.nJJRSZFV6
 5B5jZNn4uKSB.NrVgvF610ShxD0O.3GZ9I8kiGBsitFvLxVezS0JfwLOycwDRHC1OwAs1OOmZbdL
 2zHvmPH2rGigzgB5nOPR.OHiW6e0G49W0LDgRTk479y7TzM8hbj8Y5jmrPIA3rheVQaeqPaVRZY0
 4O_gfdeTNZShU30tLqo_yPgbZjuXZYInvdJiHuB9NN5_YGUNDWsYdwibSHMuBr4.RNkWQaWIm_tA
 G_gp9t6lSxGmXgaButltXw4ltLH2jJMjgRckdJo2.6X5vkraaDPHbFyhawYhfQeH9CSBenYxjHcZ
 alRCrRBJ_.iwbWF4ZJTOrlNao0AwriLXh8oU1ZyjJ4ixoiYtG4PV.vvCR2JHuCa.vHBzhpdX.so3
 E9XceZKE3E4J3DXPkpMqtQPHBf9H4bJDi4mS.L6AoTraSituFka9Ax_UfCGu7ASWNYsZrueI306f
 efDfNBw2BDYT0_XXhocUxI.bGxPz6_K_NH1RZo1WiukisiESXvMkpp07507cMvBZDtF3QZ4NT3FT
 WsNO0MBb0BkYv7Tpi4zCJ4wq3VGZ.FrJ3Iht.TkHVW3soJQRUfXS9oLTWvFSN1nGScCD5wzB8LQV
 DDxsw1OAVbQ3oVdgsMkttCrNrV23Mx2cvxeu_f.byxXDjb9ahmJNtgcX7eMWPQ9NJ2a_xirvoxA1
 zht9mY1feqWZNHLkSy3UBFuPbv3hbnG8ZYorhkCBwhk7dZxm9woDrY7NBQ1vFW60_K7lcK22MzP3
 9VfdUyx1MYSbBuG22Yo2siHSZHPktfvwm029_lRdfHBB_Ty6XMtU1TQ5UORt4oPH37l2A1ZHcPlk
 eCygzqTppCkvKSqEXaXNxQuSRo_i2iAfH4tqjAar_KRSqUiexlko3bsqP0ekt1JwUcNE_WjWdaQ-
 -
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 9d2959e6-01c6-4dac-a086-1d0955a46375
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Wed, 24 Jan 2024 18:06:23 +0000
Date: Wed, 24 Jan 2024 18:06:21 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <2058198167.201827.1706119581305@mail.yahoo.com>
In-Reply-To: <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22046 YMailNorrin

Other than sdc (as you noted), the other array drives come back like this:

root@jackie:/etc/mdadm# mdadm --examine /dev/sda
/dev/sda:
=C2=A0=C2=A0MBR Magic : aa55
Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)

root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
mdadm: No md superblock detected on /dev/sda1.


Trying your other suggestion:
root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1 /dev/=
sdf1 /dev/sdg1
mdadm: no recogniseable superblock on /dev/sdb1
mdadm: /dev/sdb1 has no superblock - assembly aborted

root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /dev/sd=
f /dev/sdg
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted


Basically I've tried everything here:=C2=A0 https://raid.wiki.kernel.org/in=
dex.php/Linux_Raid

The impression I'm getting here is that we aren't really sure what the issu=
e is.=C2=A0 I think tonight I'll play with some of the BIOS settings and se=
e if there's something in there.=C2=A0 If not I'll swap back to the old mot=
herboard and see what happens.

Thanks.
--RJ





On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@penguinpee=
.nl> wrote:=20





On 24-01-2024 13:17, RJ Marquette wrote:

> When I try the command you suggested below, I get:
> root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
> mdadm: no recogniseable superblock on /dev/sda1
> mdadm: /dev/sda1 has no superblock - assembly aborted


Try `mdadm --examine` on every partition / drive that is giving you=20
trouble. Maybe you are remembering things wrong and the raid device is=20
/dev/sda and not /dev/sda1.

You can also go through the entire list (/dev/sd*), you posted earlier.=20
There's no harm in running the command. It will look for the superblock=20
and tell you what has been found. This could provide the information you=20
need to assemble the array.

Alternatively, leave sda1 out of the assembly and see if mdadm will be=20
able to partially assemble the array.

-- Sandro
