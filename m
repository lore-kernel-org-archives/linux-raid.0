Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60E27470
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 06:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741847970; cv=none; b=udhrahxrVRnru6X8eE/jM/zzbjDRvQMYwgISP4r+PMb0AYS/kdSDPcBzrbneZMo5L0NsQkPhlaLUMfm+YJbptC3J0PtUnANXVzINa+pSmblcWhszjJnkDn30MVycEn1g3nCqQxP22pOiFIbr2vLEvnW/j7WAQSl7LhEEZfnmUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741847970; c=relaxed/simple;
	bh=yPI5EYX8lL+hBJ0T4nyMFfmAKzlMO4FCfdTRsn64TN8=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArY2Wo7yIbilZPmaq5J3Usv2rMYPd+nMDbcZAoSPRB/Kd+EtPR8Tpdn1KIjMSp88cYxx25BF/t3z9cZS3qLTxlcac74035EyyM6dHcsPsubatLW/NCCZbv4j1+TPEJCnW+KGTNizzAUBAptNl7Pc8scdveDzABVDw+/BYZh+Euk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=BWd0Lp3t; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="BWd0Lp3t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1741847965; x=1742107165;
	bh=yPI5EYX8lL+hBJ0T4nyMFfmAKzlMO4FCfdTRsn64TN8=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=BWd0Lp3t/sQ39on+WVNVfWvwDdPfZoeGESHCFx7VNhE0eXd7mXBhQOVxKC2//94Ez
	 EKxctcx+59sNvDzH7zWN5lbiATP1A/5bYe6zFkyUsTQocXlOux5th2peUa4acTtF0R
	 72yhZQwIVAlD3tFFbz/9If5+l/9tPZVuw5eT3A7p1EsmeCk5h30HbJhgmRj9sx/kR5
	 SBOgJsJqwuVR61N6kAwyxZBnofQ4Yn3ylgcXkutEFDYVtMZFqdGkEa/symwcInAzvh
	 rHT/+F9C3B9tApR/JwIFGHSvFToR3/Ump8kEd0TG5X4/uInJpe+Dz91MwR2rkVF4Nt
	 1/EX7YfGsakPA==
Date: Thu, 13 Mar 2025 06:39:21 +0000
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From: David Hajes <d.hajes29a@pm.me>
Subject: Fw: Re: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <TzGpH-x0vOCPMkw_YgkZhqXstLu5OHDIA883oSEurHDmgbY2cnSHGBjBUhUNAVVwAqDpshS__-2UN4Oc0y25Eij29dBldktsVAsV9hgKBhM=@pm.me>
In-Reply-To: <mUTk9RKcp55IgkOLdK7prUD52e30aOJ1sQNoTaedBafMvGRVR1TxZnnBFQADU3BVc1AUfps0lsv_e9wG8PxnpXqpWt-UYKHwksp6M1b7sDU=@pm.me>
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me> <20250307234753.473dc4b5@nvm> <wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me> <CAAMCDefMK6PD7+BpfQ9e2WGjdsk_hQaoGOAYmQ2_Rtn5o7nGrQ@mail.gmail.com> <20250308014718.24418feb@nvm> <6Ir6YNRb1H1U2Oo4RAL72oDA3NHeUrwres6F4LBIh0GPJywynko0jERT_t7JPtLBHvy8LwzAK6AqwhZFjGH7gGstzEaLWoYkXBoQlU2B5To=@pm.me> <iySSc1AqmRY1KRcyTemssyoFl73YGVEj-la5iuqHKYLfGZ5T03ftnvuIct26v30dD6y4w1SRWo9x67ZQUki88MQTXBBmKf6vL5eEOXJig8c=@pm.me> <CALtW_ajQimm6duqkmyWbBL3MKZ9yC5Prxj=eE9vW9+pTQ=+7Eg@mail.gmail.com> <mUTk9RKcp55IgkOLdK7prUD52e30aOJ1sQNoTaedBafMvGRVR1TxZnnBFQADU3BVc1AUfps0lsv_e9wG8PxnpXqpWt-UYKHwksp6M1b7sDU=@pm.me>
Feedback-ID: 111191645:user:proton
X-Pm-Message-ID: a18592053a2567820565ff45e948df9a579505e5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Of course, but not by 150%

4 drives RAID10 suppose to be running theoretically 300-500MBs...not 120MBs=
.

Most modern drives do 150-250MBs inside to outside tracks


-------- Original Message --------=20
On 13/03/2025 03:54, Dragan Milivojevi=C4=87 wrote:=20
Speed drops as you approach the end of the disk.=20

On Wed, 12 Mar 2025 at 22:10, David Hajes <d.hajes29a@pm.me> wrote:=20
Update on issue. I came across the "mismatch_cnt" stat after init resync or=
 just common check/scrub.=20

mismatch_cnt suppose to be 0. I had counter reaching millions. I haven't fo=
und definitive answer whether "mismatch_cnt" bad, and should be ignored.=20

Allegedly high mismatch_cnt count suggest HW=C2=A0 or SW issues. I run SMAR=
T, no system corruption.=20

I have tried to run "repair". Repair 400-500MBs, and mismatch_cnt is now 0.=
=20

Initial resync started at 500MBs, 20 min later dropped to 200 MBs. 3 days l=
ater speed was at 120MBs.=20

I will try some real tests to see if array is still fast in real life as we=
ll.=20

Hajes=20


-------- Original Message --------=20
On 08/03/2025 18:59, David Hajes <d.hajes29a@pm.me> wrote:=20

>=C2=A0=20
>=C2=A0 In case someone wonders in future why SW RAID5 or 10 is slow.=20
>=C2=A0=20
>=C2=A0 Unless, two or more process do not write in parallel - ARRAY SPEED =
WILL ALWAYS BE SINGLE DRIVE LIMIT.=20
>=C2=A0=20
>=C2=A0 Basically, any single user operations of storing data on the array =
will became as writing to single drive.=20
>=C2=A0=20
>=C2=A0 In case of modern SATA HDDs, it would be 120-220MBs=20
>=C2=A0=20
>=C2=A0 Only the HW RAID controllers are allegedly capable to write on more=
 than one drive parallel thus achiving the logical/envisioned/intuitive spe=
ed.=20
>=C2=A0=20
>=C2=A0 based on theory where at least two chunks are written at once to th=
e two different drives thus doubling the writing speed as confussingly writ=
ten in all RAID wikis.=20
>=C2=A0=20
>=C2=A0=20
>=C2=A0 -------- Original Message --------=20
>=C2=A0 On 07/03/2025 21:47, Roman Mamedov <rm@romanrm.net> wrote:=20
>=C2=A0=20
>=C2=A0 >=C2=A0 On Fri, 7 Mar 2025 14:42:24 -0600=20
>=C2=A0 >=C2=A0 Roger Heflin <rogerheflin@gmail.com> wrote:=20
>=C2=A0 >=C2=A0=20
>=C2=A0 >=C2=A0 > I put an external bitmap on a raid1 SSD and that seemed t=
o speed up my=20
>=C2=A0 >=C2=A0 > writes.=C2=A0 I am not sure if external bitmaps will cont=
inue to be=20
>=C2=A0 >=C2=A0 > supported as I have seen notes that I don't exactly under=
stand for=20
>=C2=A0 >=C2=A0 > external bitmaps, and I have to reapply the external bitm=
ap on each=20
>=C2=A0 >=C2=A0 > reboot for my arrays which has some data loss risks in a =
crash case=20
>=C2=A0 >=C2=A0 > with a dirty bitmap.=20
>=C2=A0 >=C2=A0 >=20
>=C2=A0 >=C2=A0 > This is the command I used to set it up.=20
>=C2=A0 >=C2=A0 > mdadm --grow --force --bitmap=3D/mdraid-bitmaps/md15-bitm=
ap.img /dev/md15=20
>=C2=A0 >=C2=A0=20
>=C2=A0 >=C2=A0 In this case the result cited seems to have shown the bitma=
p is not the issue.=20
>=C2=A0 >=C2=A0=20
>=C2=A0 >=C2=A0 I remember seeing patches or talks to remove external bitma=
p support, too.=20
>=C2=A0 >=C2=A0=20
>=C2=A0 >=C2=A0 In my experience the internal bitmap with a large enough ch=
unk size does not=20
>=C2=A0 >=C2=A0 slow down the write speed that much. Try a chunk size of 25=
6M. Not sure how=20
>=C2=A0 >=C2=A0 high it's worth going before the benefits diminish.=20
>=C2=A0 >=C2=A0=20
>=C2=A0 >=C2=A0 --=20
>=C2=A0 >=C2=A0 With respect,=20
>=C2=A0 >=C2=A0 Roman=20
>=C2=A0 >=C2=A0=20


