Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E41C860E
	for <linux-raid@vger.kernel.org>; Mon, 13 Oct 2025 19:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760382412; cv=none; b=G2d++L+FTIQHowNn2CDLMu5EpXzrR0U2XEjCjMBnGgL8mRdxO8I4O/CNCCnymsNxptX+8NtISTa1g7yQzI4ppnjBHB2DScVS9watGE6DnsaSqjRi6nwJET1HJHhv/Jh+h2JPARGOjCptPrl/taqBTWK0w05OGK7E3bxXWtZFnow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760382412; c=relaxed/simple;
	bh=RuC8Lt38r7zFXbz6zqSjsgQbFhbm03KxrZDDRB/iLcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bdjudg/QD5KIYCh0X8kQQlyGCF9+9TLCF2CphuSiLC4e5wDZEKV39pL3Vac/wsTgn0gmecz0X4NmP60NDrmMRrZCiCQL1lUxlS9PDJXpvRKDE8S42ELowMnDZ/5C2dSA24AZlJMAdI8TtSxPhirvV/5FF1WNHSWrApXVfE6rJD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=BA0sxwXU; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="BA0sxwXU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760382405; x=1760987205; i=devzero@web.de;
	bh=RuC8Lt38r7zFXbz6zqSjsgQbFhbm03KxrZDDRB/iLcY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BA0sxwXUE62jMzloOMNGWb4SRuhxsdlHcZYLfqII+CBNpVk0vwrnR28EwVGHgMH+
	 MY7kxLscPG3BkVSB9275jMmYNi2WKUbROY7DFKvlMUk7oskFAQ1FYFUQy0IdkXHCG
	 QbgDNQvxRy4RbtGGe5pEjpUzEDfg8m4cJRyafbOl++oSYw1f+me/I17eC2ZgY0TXM
	 CmjByhyXp4upd/xor+WxKHe9hPL0/jkMoWFg1NYpeiskIAUK9lXND6eX5d1fJjZFX
	 kMeKGIEIdKOqO6UmrJDsOjwhbNm0EJXA65ODYsaFFfCSWH6g/MrndirGRyLR3a7gn
	 IFWUvn6Xee5vXtwRww==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.179.107] ([87.78.141.14]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N01Za-1uLWK31uSs-00xG5x; Mon, 13
 Oct 2025 21:06:45 +0200
Message-ID: <27deb80b-82da-42f6-92e8-498064007623@web.de>
Date: Mon, 13 Oct 2025 21:06:45 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Hannes Reinecke <hare@suse.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
References: <5f25dea4-41f6-4bf2-aeed-deb9d8c76e29@web.de>
 <14d8314d-7c36-4f4d-bdef-b8ad0be37fa5@thelounge.net>
 <ca607ec6-708c-4340-b8b1-05576b92dd88@suse.de>
 <24498365-34bb-4296-a725-2bd80e226bdd@web.de>
 <d5227acf-73ff-4cfe-a699-061b75b2d0d3@suse.de>
 <4f333665-9e4f-499c-9cda-fe87d221933a@web.de>
 <b5ab0f4b-b536-42d0-a442-66a8e2638494@suse.de>
From: Roland <devzero@web.de>
In-Reply-To: <b5ab0f4b-b536-42d0-a442-66a8e2638494@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LXEigs9YVEbj1MIKJOK0IuuDmXfUcc6D1iUGgaPXwsG+LI+aY42
 lvFtf8ucrRNwf0LhMQGsJQowL1Mgnh44hocVIM97uEn7JrwplEcuYuoVsn+M4ElCe4XXbfW
 NCwFrQtwC4KXPytGAjDK2UC25VzCBVzr+KuXxd0jhZ7hIfejRAc3tFEXN32X/S0756MBHKh
 DJQXgiYdberSiBT3G3dNg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bGLuUMew15k=;r8dg1H65yiSzPBqQrN9zcQxywqL
 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

hello,

>> 7. check for inconsistencies=C2=A0 via "cat=20
>> /sys/block/md127/md/mismatch_cnt" again
>>
>> i am getting:
>>
>> cat /sys/block/md127/md/mismatch_cnt
>> 1048832
>>
>> so , we see that even with recent kernel (pve9 kernel is 6.14 based=20
>> on ubuntu kernel),=C2=A0 we can break mdraid from non-root user inside =
a=20
>> qemu VM on top ext4 on top of mdraid.
>>
>
> And what would happen if you use 'xfs' instead of 'ext4'?
> ext4 has some nasty requirements regarding 'flush', and that might well
> explain the issue here.
>
> Cheers,
>
> Hannes=20


thanks for feedback and for this hint.

i tested with xfs today , and it seems to make no difference.

i can inject inconsistency into the raid with the mentioned tool via=20
debian-vm with xfs inside debian and hosted on xfs formatted md raid1 on=
=20
proxmox.

root@pve-hpmini-gen8:~# cat /sys/block/md126/md/mismatch_cnt
59648

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md126 : active raid1 sdb3[1] sda3[0]
 =C2=A0 =C2=A0 =C2=A0 48794624 blocks super 1.2 [2/2] [UU]
 =C2=A0 =C2=A0 =C2=A0 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D>..]=C2=A0 check =3D 90.5% (44183744/48794624)=20
finish=3D0.7min speed=3D107987K/sec
 =C2=A0 =C2=A0 =C2=A0 bitmap: 1/1 pages [4KB], 65536KB chunk

md127 : active raid1 sdb1[2] sda1[3]
 =C2=A0 =C2=A0 =C2=A0 48794624 blocks super 1.2 [2/2] [UU]
 =C2=A0 =C2=A0 =C2=A0 bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>


roland


Am 13.10.25 um 08:48 schrieb Hannes Reinecke:
> On 10/11/25 21:25, Roland wrote:
>> hello,
>>
>> some late reply for this...
>>
>> =C2=A0> Am 10.10.24 um 10:34 schrieb Hannes Reinecke:
>> =C2=A0> Which I really would love
>> =C2=A0> to see reproduced, especially with recent kernels, as there is =
a=20
>> lot of
>> =C2=A0> vagueness around it (add part of the disk on the raid as swap? =
How?
>> =C2=A0> In the host? On the guest?).
>>
>> here is a reproducer everybody should be able to follow/reproduce.
>>
>> 1. install proxmox pve9 on a system with two empty disks for mdraid.=20
>> build mdraid and format with ext4 .
>>
>> 2. add that ext4 mountpoint as a datastore type "dir" for file/vm=20
>> storage in proxmox.
>>
>> 3. install a debian13 in a normal/default (cache=3Dnone, i.e. O_DIRECT=
=20
>> =3D on)=C2=A0 linux VM. the virtual disk should be backed by that=20
>> mdraid/ext4 datastore created above.
>>
>> 4. inside the vm as an ordinary user get break-raid-odirect.c from=20
>> https://forum.proxmox.com/threads/mdraid-o_direct.156036/post-713543=C2=
=A0,=20
>> compile that and let that run for a while. then terminate with ctrl-c.
>>
>> 5. on the pve host, check if your raid did not throw any error or has=
=20
>> mismatch_count >0 ( cat /sys/block/md127/md/mismatch_cnt ) in the=20
>> meantime.
>>
>> 6. on the pve host start raid check with=C2=A0 "echo check > /sys/block=
/=20
>> md127/md/sync_action"
>>
>> 6. let that check run and wait until it finishes (/proc/mdstat)
>>
>> 7. check for inconsistencies=C2=A0 via "cat=20
>> /sys/block/md127/md/mismatch_cnt" again
>>
>> i am getting:
>>
>> cat /sys/block/md127/md/mismatch_cnt
>> 1048832
>>
>> so , we see that even with recent kernel (pve9 kernel is 6.14 based=20
>> on ubuntu kernel),=C2=A0 we can break mdraid from non-root user inside =
a=20
>> qemu VM on top ext4 on top of mdraid.
>>
>
> And what would happen if you use 'xfs' instead of 'ext4'?
> ext4 has some nasty requirements regarding 'flush', and that might well
> explain the issue here.
>
> Cheers,
>
> Hannes
