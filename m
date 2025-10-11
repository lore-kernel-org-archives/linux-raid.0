Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED26921770C
	for <linux-raid@vger.kernel.org>; Sat, 11 Oct 2025 19:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760210733; cv=none; b=Q9m9nJXPftWX2DpsDxCBtiud+XRMud9lI73k59QcBV56wZjS+SkgvPOPJYXGfD5SyjhRlVttgkPs9018ulG6mfovj9yI64xi+T9zdlgia1u5JepcFYVMAPVBKO+cMAl3cz5AuVUqGq8sw62Z+8jVMsyXufeCFTSmehgbwxroNhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760210733; c=relaxed/simple;
	bh=aVjNOn2H1kZXUTAstYUCYSoUWIhy4SzMk5xR+3PzQzg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=MChmsWgM98hEOX9KVyx9nYA9wyvW/wl5hkS1WLE8CJ6MmmRJ+yb0F+LZSad5AFXcypuiS5/aOO3r7Rv3pChKTy0hrbK4XQRPRjJtl6y/cfzMOiF6eDhkUpXuKOdUH7vbzShIFqA4TxMUZvSHuz82CNME9uSRPtk29HMS1Opm8RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=AVSpJMaT; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="AVSpJMaT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760210728; x=1760815528; i=devzero@web.de;
	bh=aVjNOn2H1kZXUTAstYUCYSoUWIhy4SzMk5xR+3PzQzg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AVSpJMaTfLzXelGc2itaPqfN7pq/pYk/RhTQz2mmE2Dvz1cBCfcaNgZn4/HA0URN
	 gB68lYaNRk132JWNbAKNSEfZ0ST9e3EllukM2RGFEmyNJF5b3ev8+RPb96J6AdY4f
	 5Pn/3PzvWN54lXrs/54YV/7FYAxQgPvnfeXdtdrkPSfTlzOh+nSYHKYSAXQxOv9mA
	 p1HpSAlcKK8IXukRX6bCnQO7iPisezMYW10mWMsUfjmP6UyzbWD2y5G8wmU97eBZ1
	 jVZ0ucvhQZGaNTaezNt3WgtH3/NJ0r5lZMFqPyhSsyHl3WeY2o3Nc0uzigseGcAv3
	 Wp/PqunGRIPY9pEp6g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.179.107] ([87.78.141.14]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MKM5t-1uok7k3ZvD-00SKyj; Sat, 11
 Oct 2025 21:25:27 +0200
Message-ID: <4f333665-9e4f-499c-9cda-fe87d221933a@web.de>
Date: Sat, 11 Oct 2025 21:25:27 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Roland <devzero@web.de>
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Hannes Reinecke <hare@suse.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
References: <5f25dea4-41f6-4bf2-aeed-deb9d8c76e29@web.de>
 <14d8314d-7c36-4f4d-bdef-b8ad0be37fa5@thelounge.net>
 <ca607ec6-708c-4340-b8b1-05576b92dd88@suse.de>
 <24498365-34bb-4296-a725-2bd80e226bdd@web.de>
 <d5227acf-73ff-4cfe-a699-061b75b2d0d3@suse.de>
In-Reply-To: <d5227acf-73ff-4cfe-a699-061b75b2d0d3@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3rYS1rP3umzWpVBryfK9vdcztkcquRXi8H+/ZkA00p7ujrQ6PvN
 km8f/sK+je+kq5ocz0XOWy5hXZFBsKKtV5yuZasP7RTKkgQmD5ZjIQnHWSoYZG7q2R+cIL8
 NQ+8FJja7YB09TT3sGBQxLWxmKexGawVASWXxUpKHasGgvhRMgiDO2Tz/10BeIiY/cq1xAd
 CCvAdkFZmpfpm6l/POl1w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kJimPVJ3i6w=;UWLSMhc4T7J+V8PUUBrMB8TKDTG
 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

hello,

some late reply for this...

 > Am 10.10.24 um 10:34 schrieb Hannes Reinecke:
 > Which I really would love
 > to see reproduced, especially with recent kernels, as there is a lot of
 > vagueness around it (add part of the disk on the raid as swap? How?
 > In the host? On the guest?).

here is a reproducer everybody should be able to follow/reproduce.

1. install proxmox pve9 on a system with two empty disks for mdraid.=20
build mdraid and format with ext4 .

2. add that ext4 mountpoint as a datastore type "dir" for file/vm=20
storage in proxmox.

3. install a debian13 in a normal/default (cache=3Dnone, i.e. O_DIRECT =3D=
=20
on)=C2=A0 linux VM. the virtual disk should be backed by that mdraid/ext4=
=20
datastore created above.

4. inside the vm as an ordinary user get break-raid-odirect.c from=20
https://forum.proxmox.com/threads/mdraid-o_direct.156036/post-713543=C2=A0=
,=20
compile that and let that run for a while. then terminate with ctrl-c.

5. on the pve host, check if your raid did not throw any error or has=20
mismatch_count >0 ( cat /sys/block/md127/md/mismatch_cnt ) in the meantime=
.

6. on the pve host start raid check with=C2=A0 "echo check >=20
/sys/block/md127/md/sync_action"

6. let that check run and wait until it finishes (/proc/mdstat)

7. check for inconsistencies=C2=A0 via "cat /sys/block/md127/md/mismatch_c=
nt"=20
again

i am getting:

cat /sys/block/md127/md/mismatch_cnt
1048832

so , we see that even with recent kernel (pve9 kernel is 6.14 based on=20
ubuntu kernel),=C2=A0 we can break mdraid from non-root user inside a qemu=
 VM=20
on top ext4 on top of mdraid.

roland




Am 10.10.24 um 10:34 schrieb Hannes Reinecke:
> On 10/10/24 09:29, Roland wrote:
>> thank you for clearing things up.
>>
>> =C2=A0>Which means that the test case is actually invalid; you either w=
ould
>> need drop O_DIRECT or modify the buffer
>> =C2=A0>after write() to arrive with a valid example.
>>
>> ok, but what about running virtual machines in O_DIRECT mode on top of
>> mdraid then ?
>>
>> https://forum.proxmox.com/threads/zfs-on-debian-or-mdadm-softraid-=20
>> stability-and-reliability-of-zfs.116871/post-505697
>>
>
> The example quoted is this:
> > Take a virtual machine, give it a disk - put the image on a software
> > raid and tell qemu to disable caching (iow. use O_DIRECT, because the
> > guest already does caching anyway).
> > Run linux in the VM, add part of the/a disk on the raid as swap, and
> > cause the guest to start swapping a lot.
>
> And then ending up with data corruption on MD. Which I really would love
> to see reproduced, especially with recent kernels, as there is a lot of
> vagueness around it (add part of the disk on the raid as swap? How?
> In the host? On the guest?).
>
> Hint: we (SUSE) have a bugzilla.suse.com. And if someone would be=20
> reproducing that with, say, OpenSUSE Tumbleweed and open a bugzilla
> someone on this list would be more than happy to have a look and do
> a proper debugging here. There are a lot of things which have changed
> since 2017 (Stable pages? Anyone?), so it might be that the cited issue
> simply is not reproducible anymore.
>
> Cheers,
>
> Hannes
