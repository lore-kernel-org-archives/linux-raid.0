Received: from sonic308-3.consmr.mail.bf2.yahoo.com (sonic308-3.consmr.mail.bf2.yahoo.com [74.6.130.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DC816415
	for <linux-raid@vger.kernel.org>; Thu,  5 Dec 2024 01:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.130.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733360707; cv=none; b=Nywucb9hBCSgB+1Hju+D0ihDtH/vMZDIMi6kLN8VRtnmLM8L+jX80ZyK5brIWAA+wpcL0/74HSwfhxZL486FuzxtJ+unH911e176bXQufhjV5gXIJkmrb2UzSCtt7q1OjzYC6snqvm3wYtSVqmSgnHPJhCBsHvhJxaBuwyktoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733360707; c=relaxed/simple;
	bh=dbKXgj7lDbMmUkThYdnPuvEjX2ZAGkUwDjkvva4lBZk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=cJeRPZwegvo73uytbmo7nI9iHvl9mI87sdVXVoy4lFqor89PdU8HJFfVeza6bLQJwGOK9OO20/tlF3Lta6FUINnBscQkMuFx4EjvkpjWYZ1AnlQ7l2C/byZ9tBMgrK+/Ic1cVCuvFQoM51vLLreOwN9b3FIgowvaDMBNoEf9f6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=AXHcw/CF; arc=none smtp.client-ip=74.6.130.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="AXHcw/CF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733360704; bh=dbKXgj7lDbMmUkThYdnPuvEjX2ZAGkUwDjkvva4lBZk=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=AXHcw/CFmTELCtDrD7r0QHmjHXIsB+Rwm8OGf4N3DR453jU6spoJhcsUDPDfeaqLRUc/RIuMvXguikwP0a2s0cOlIIzvriVWNA0nsJGpEswIEsDwSnzddQdSyKMAalwAsZ6AehT1pdpNPugeThGJn26G6rsJxY+ardZy7/me0H9f4IFylwMS06kfUm2kIZX/u2hFZwaAlbejae2lK1+7+YirDTBS80sPDbI/nK87FiCpbn+Ee8b8c3rZv2bS8xvnFp4PT2TrevRP3GTJbA1YLSKCL+y5hTbytMlr1/PPKSQU9DaLW/8JsVDEOZ1kcNnf9+xlbCW1JUvAjFWXvmYBjQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733360704; bh=17/jucuAhNGENH9k1E6csXURf8b4C5xiC46WNOoOSy3=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=uh7MtQljCUXtiRx57Ayp73B1mEvqsRiCrvnf33T39LVYhPUGLaqof1ijGiUedMHhfeeK8EDLb3WVB5r/H+8mLJc9L0853pLtIzHtb2oRBj5gIgfa6abP4yILhc6ZNCNBajYGEl3CYFqCu3Z57TZj3czYXmBv3b+2VHlTkW1TFN0Ow+ldZ6zUg1DiisDpxIxYswovOB7osyaWAMjxOPjBswymlFMzsx52PoArSWo5efXc21JZkBFAKbcFtxviCYG3/TjDMWidLHRRKvomYEtmFBUn6CtZoTj95RekvTz6wgiXEEYgOA7Q//fHpWXzfX+AEPM+CDR/Ih9YzeJGk+vq0A==
X-YMail-OSG: ct0wC9oVM1nPkMW3uhtA5dHRydk0wofYZt35AMzYoAMswjIMLCfhWMq81Moq6Nt
 FPCa6tpM8qSG5tdIfVKYnrg2itzISEzTE7S6ZZ4lgqgn1ZDdIYefLyO6MjcrBVLYUXG_IIu5g6Zq
 xOkDepkcdr2RalU9UdM6KC.jUmiHyZ99oNEZhhZQAjTnaz7xST91yzBcQN_28gfX0JO_LKLvVtWc
 Wrsju4sjLrOitdqtnjGOi2tT8sWLf6rA0_3d3OarSqkjkf01CIAP.LaGs8tlrx7wpUHb74lilZ7_
 RAQUe73YaUVqZnzyGC4xPt6I_q_stO27NNaBPVDJvyk7HQoVXNgqMGRvdTSpkO1a.D9BV62SyYtL
 jHg7tVuskuHtc9NRXmDmc1pdpo41_0hNagDXTJ.s5DTNmLdmpwp_fvgTF_g_jpTB2404w2iXWf1U
 43M762UDSWVgz9ZeTo4Wixl_kHsqt55aWBrg7YtAfYFgi1FbHpz3LDeRqVwtnC7_b.KNz6KPUQ9V
 njUZFI2EYSyTnbfvHM5j8h8C4HINXzO_QPV.sbKo_ljsR_EHeoQg6lz_8RVPHvITxOngNKxc_8cg
 s.HMgjQsHyeM8HTFI0JumvYqKAVGWo_v2ZqMn0g8tvq5rpBQs7Ngt6jYKitFn0P7CKfEVn15yu_8
 i6mD_4eT6oMSmHdBDfs7Y1JWMak2EBh6iH5pFgRIF9FLH6EfLWLJN.qEOl3ZddXXbksAXmU_uXCi
 OsVq1f7le.Q1g1Fyxz2WQWP9Xidp2jdgKO.b2t_g0uU560GLyX2XI2ugbYfqgEVRBUiY_gFAfI5K
 BrgKphyS9ryDO3bvQFlGa.dHpeYaqPcezmv035oT5A3JSh0Si3ZpsPdNU5b0wSHtaaKjLR5d7Xt3
 c.H92hf3OS1ksRYl_SR6s9CuLmR7jBpGt45rPlK6YG0c2Owrv3.ZppXA2QQZDzhcj3AYNfxL16lS
 W67e66w6Tlv6f5V5.PqawkUjquzJ651rK0hAwlOSi6wYNGk4m9SjTbXX04RrTcqsI3aakLK7kXsM
 rAbmst7kIgSJQi4B9I.9Ff3ZW34clpY1mKY50NGgucYCWxJt5N2viy9ToxNN5QRlbjPZwW1Sguxh
 Glh2o.TZSCWhbgei0vzn14YvN5Utd1JCqFtgYWTki65ZIK5B3IwID73pEJrZXNynYJ9pRfYZ5ZNM
 0JPlv7.knCr42UbJlJpKkeukF_KBWpi7LcdPeHn44DK_HrStD9nY1QTyI8iTt7kdTTO6in53joou
 mCNrjOvknx_YDuDfuVLwj.I4eVqWF9WC0kXUzxQ1eOWs8G51C1iptuylONpRGesckn_yYaIagWyu
 yXiRJo1yN6KCWXaJs_UToaUMhyduS2mxRpAXzKoDk8gDYL0bxFa3tqIiAKSTrtKytQ_iZHVb3kT5
 mgIi71ZLcSNZtqyxk0BPF2CjVbno0FnWqU4gz4L0Qs9tDrAlK9DXJOu5aQC6_s2PZ20vg7IPZOdH
 uZ1d18gqkdmdPsCQTXQOv34HfcDDDtVLjpfkgf6egi6XiOFPd_B655jRwnnFsXPD7pihJ1AW1f1A
 tvjXC0uAgRDFKB3uGCO1q6OOfg0vZQMfdthSsT5.vlcrFthRuq92IZukKCOnJluF5Wv7WKAjQM9N
 RrmkxsuwsjqmesHwdX8KnjYZHyqSZweO7HlrEm4sojqR9hBTNQbJJK7778DKTCJA.3hDP1vGGm8_
 Ko1lm0bl3guOjCoeMELnAM1LDBsZFocPe39eASSVL6UEMKtRL0p.Ij8adHmtHpqDqfl72R3RGHHL
 sPMR1g.vGMxZAx1LA.MJy4fA9IPZp0gOQWCzx_cyNyUGpqeYXRdoiroQofq1W.L_rXRrPTB8yPUi
 UAigKlWjb4afeLyc4kbQqPV5ZLNzTZGJA3utIpYerwFVQ4fgDGLkFlTSyzEsD8kcj.Fuh_Ij9MJV
 1XMoNTHAYzPGEsF2Tew8dlsdLWkFFCFntlBdZuKJDbkqKnUnVTM9t_h.1F4D3FQrgvjLWf4uTrBg
 vAqlVxGCQ2WIgFvGK5byh5PnUcmFlBP7wE0vKxhja8Yxv.Mx4BN4eUtxIW1xarK7PTlGMP208hKo
 WQI4DCPd_82dQWsaD.bpSplxww9W6Uah6xdH93izBxCM9saQmrnDd7jvTZVq4odWrcJS2dQ4FdWc
 _IdeTJvrccoyOEFKl02RkpbmVWceh5I_KVOIrIq5S1V6MY90.nl7lcqbcs_rzqwNlCHfOq2C2mm_
 e51LMMWuJ_vO1bLBshqLolHXxGq7N56ats3CAPTDcuDWA6V0o9QZa7cu5kcdseSyFoXF7FMwYPpU
 EiSlNbSnH
X-Sonic-MF: <jbumslist@yahoo.com>
X-Sonic-ID: 11b4b405-26c0-4e87-b931-0574dc0a21ca
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Thu, 5 Dec 2024 01:05:04 +0000
Date: Thu, 5 Dec 2024 00:54:55 +0000 (UTC)
From: Jbum List <jbumslist@yahoo.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <1704682970.3404601.1733360095994@mail.yahoo.com>
In-Reply-To: <20241205052615.449ce9f3@nvm>
References: <1552948949.3399643.1733357342509.ref@mail.yahoo.com> <1552948949.3399643.1733357342509@mail.yahoo.com> <20241205052615.449ce9f3@nvm>
Subject: Re: Resuming mdadm reshape on a different system
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22941 YMailNovation

> On Wednesday, December 4, 2024 at 04:26:22 PM PST, Roman Mamedov <rm@roma=
nrm.net> wrote:
>
> On Thu, 5 Dec 2024 00:09:02 +0000 (UTC)
>
> Jbum List <jbumslist@yahoo.com> wrote:
>
>> My current situation:
>>
>> 1. Raspberry Pi 4 w/ 4 disk RAID 5 array
>> 2. PC for general development and test.
>>
>> I had a 5th disk I wanted to add to the array and in the interest of mak=
ing things go faster, I decided to temporarily hook up the raid array to my=
 PC.=C2=A0 I brought over the existing mdadm.conf settings from the Pi and =
the array was brought up successfully without any issue on my PC.
>>
>> I started the grow/reshape operation after adding the new disk and every=
thing is going well.=C2=A0 However, I noticed that the rebuild speed isn't =
that much better than what I'm used to see on the Pi.=C2=A0 So rather than =
wait for the operation to complete (in a few days), I wanted to move the ar=
ray over to the Pi and continue there.
>>
>> Can I pause/halt the reshape that's currently running on my PC and resum=
e on the Pi?=C2=A0 I know you can pause/halt and resume on the same system =
it was started on but wasn't sure if that's possible across systems when bo=
th have the same configuration settings for the raid array.
>
> Should be no problem. The reshape state is not saved in the OS, it's on t=
he
actual array drives.

Awesome.=C2=A0 That's music to my ears.=C2=A0 Thanks for the confirmation.

>
> Before moving it back, you could first try:
>
>=C2=A0 echo 1000000 > /sys/devices/virtual/block/mdX/md/sync_speed_min
>

I tried this but I didn't see any noticeable difference.=C2=A0 It could be =
due to other settings I had already tweaked (read ahead, stripe cache size,=
 etc.).

> and see if this makes it faster.
>
> I would also expect the PC to be faster, at least if you connect the driv=
es to
> its onboard fully independent SATA ports with enough PCIe bandwidth to th=
e
> controller, and not e.g. the same USB enclosure.

My "PC" is really a laptop so I'm using the same multi-bay drive enclosure.=
=C2=A0 I suspect the USB interface is what's mostly limiting the speed.=C2=
=A0 Appreciate the suggestion though.

Thanks, Roman.
