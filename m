Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E80542AA9
	for <linux-raid@vger.kernel.org>; Sun, 15 Mar 2026 08:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773564992; cv=none; b=kQimgb6YlZ0yWIFSxCK1PM13+SwZ7TTz3bMo/UJEPLbGPNhqAN+wj/8tB5pKvmDYm+5btHjswkVBGNjj3DpOhU8bO1wKMmaK8EOgg+rVX7qk76ZiajAkUFv7KLsbkJo1dfaWbOvgBgzQrtVlYlcne26XkQLjKwQbs+uDO6/HsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773564992; c=relaxed/simple;
	bh=HPURIIyiewquP94PYqxi4/7Oqvjyk1INdIsRWkTb3Ks=;
	h=From:Message-Id:Content-Type:Mime-Version:Subject:Date:
	 In-Reply-To:Cc:To:References; b=mb5NXVLkKrIpOdrJVY1ATVsRxZXQ54Qk5vo24fdxP1vbcqmxuP/1KkesAEsWGhLN4P9dyHj75gR/59GYnCC2VJE6uB0kHqDL2IU8A7DqEDta/vAbnYFcJsyphHLfcgkI0QJQggPNfDWkfwDEQoCrrXVLJII8wDZHAzQqrecinos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SYQPPz6p; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SYQPPz6p"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so40493025e9.3
        for <linux-raid@vger.kernel.org>; Sun, 15 Mar 2026 01:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773564988; x=1774169788; darn=vger.kernel.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=7F7/z9cl1uMRc8EA6BXiQicmqdGcXttZYsVrXeHZwOg=;
        b=SYQPPz6p+NE+8duPjBOBGQQ/JApphex3XkCZlOSEu2YobfFDBn1ZsiE25tA7CHltqv
         cJ7HQnNOhMVR+wKIwOb84ae3lNQ+0PyYS9LdHKRx6jLY+unWA3NL7LX4G3ggSudPUowT
         cJ765uvZzW/MhQOQCxSaPWHaNQt9O1dw4LKvtp1BDn18ZAD+DSbDTtAz2t1aVFX7a3Jf
         MeeidKLpOFIm+dBLGEd9Ua9uRFJ/sK1nr5OCdwOD94Xlp/wTx08Dw645UjJvouCzr4mY
         iIu1QP1dXbYPOfyzNWaQEa8gGOi1x1RVVAvPUjNQnrmYNOlhMkCJ7fd/SM9Bnyu3aadM
         p/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773564988; x=1774169788;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7F7/z9cl1uMRc8EA6BXiQicmqdGcXttZYsVrXeHZwOg=;
        b=nTA7rRTLlWFRweo6UqSkVJ9d6uxu03DGkWCdGBe6SOPVb4O3j8lpJK7gFw0PvU8Q+x
         Ztgcize+Zxtk7JzDKIUmnr1+StQpA95YTozssP6D2oUGs3yApjyd22RTS+zAcesgxobu
         zOQlWwDcLTJk/HRBwGbuTScav9mgHUSXotMmMSZgyGMlsEDmKhQ6DdU00/KV2eUEKa04
         OeyzKe12zBCI9pL04MlttLit18IPqOVeOoNvsnWZyaKVYOzufZpr4G8qAsOusDHqBJIL
         9OzCzFr282zQrfNmcuaV6Wpbb42yefPzEnLviASdDX6KlI/IH4aGVDes9Dewa8tMhJEe
         1kNA==
X-Forwarded-Encrypted: i=1; AJvYcCUJn0Q8HGWxFNbcxfzUFbjBqFk/FmDimTDM8Ct7/4Vss5psZOwp9pDNy2Nx8m5nnHbxvsuJtjguUlvq@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8cD3+t105Kl1TEWcginZuPLONyRfImwOoytiG5jU7z52mZ2gn
	B81Z/yHdnMgI8piMTZHRQ8g/Q72jKQp3aYjKyQk2bJC1DX3llOWxxM3Qjqjr5IECUTE=
X-Gm-Gg: ATEYQzwO7QM/SZiqRvcHVtfw4FDsw7EYA60L49XcnOnn9g+9Z8boMjZAJucJM4XL6HJ
	cK8eVYZZheoJcsYf6jrXs5aOrfYEu/ptv1FZ6iMGNO5ED7u03xaAzPcrXaD9rn/zp70uT/TjBq8
	VZX05X23wdsMNhMzQ02ER1everRdgEu7Y52ap6rk45GYmMWL/8Q0k6SpBgcSvalCc7XwrQ8L97j
	4VHp/fX4Yuvcp8ieLQz0g6+1OFqWGgcmOYQLnYqxtTq9h+wvr6JWjEALcjCWmF6ezG71mA1QvRQ
	CXqQtChHt/eXibUPCTPvoAtKaQl+V59AFtWYqviNBbvdt+qQKyfdALKisonIrbRz5gyhfEd6IF1
	KSFUgILgdlgWt8DopCYnHrzkWa2TULksb2+shr5BQZp9VBvTF5mffrAQrjRP31V2bJgVwDNT329
	O0i9Fuemgeojudr6cUoJejPh2y8g==
X-Received: by 2002:a05:600c:8208:b0:485:34b3:8589 with SMTP id 5b1f17b1804b1-4855a8d7004mr131075065e9.31.1773564988164;
        Sun, 15 Mar 2026 01:56:28 -0700 (PDT)
Received: from smtpclient.apple ([154.26.180.185])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128f62837ccsm10565872c88.3.2026.03.15.01.56.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2026 01:56:27 -0700 (PDT)
From: Glass Su <glass.su@suse.com>
Message-Id: <94F22BD7-A521-496B-AAAE-50DD825A4353@suse.com>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_85FB90DD-2A4D-4045-86BD-9CC155465240"
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap
 offset while growing
Date: Sun, 15 Mar 2026 16:56:12 +0800
In-Reply-To: <04a3d0bf-838c-43b5-bb69-410829464042@fnnas.com>
Cc: Su Yue <l@damenly.org>,
 linux-raid@vger.kernel.org,
 song@kernel.org,
 xni@redhat.com,
 linan122@huawei.com,
 Heming Zhao <heming.zhao@suse.com>
To: yukuai@fnnas.com
References: <20260303033731.83885-1-glass.su@suse.com>
 <20260303033731.83885-2-glass.su@suse.com>
 <20fcd6f0-b27d-49aa-8064-79f58f109d5d@fnnas.com> <342g70bt.fsf@damenly.org>
 <04a3d0bf-838c-43b5-bb69-410829464042@fnnas.com>
X-Mailer: Apple Mail (2.3864.400.21)


--Apple-Mail=_85FB90DD-2A4D-4045-86BD-9CC155465240
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Mar 6, 2026, at 01:57, Yu Kuai <yukuai@fnnas.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2026/3/4 11:14, Su Yue =E5=86=99=E9=81=93:
>> On Wed 04 Mar 2026 at 10:30, "Yu Kuai" <yukuai@fnnas.com> wrote:
>>=20
>>> Hi,
>>>=20
>>> =E5=9C=A8 2026/3/3 11:37, Su Yue =E5=86=99=E9=81=93:
>>>> Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration of=20
>>>> bitmap_ops until creating bitmap")
>>>> if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and=20
>>>> clustered have
>>>> the sysfs file bitmap/location.
>>>>=20
>>>> After the commit, if bitmap is none, bitmap/location doesn't exist=20=

>>>> anymore.
>>>> It breaks 'grow' behavior of a md array of madam with=20
>>>> MD_FEATURE_BITMAP_OFFSET.
>>>> Take level=3Dmirror and metadata=3D1.2 as an example:
>>>>=20
>>>> $ mdadm  --create  /dev/md0 -f --bitmap=3Dnone --raid-devices=3D2=20=

>>>> --level=3Dmirror \
>>>>    --metadata=3D1.2 /dev/vdd /dev/vde
>>>> $ mdadm --grow /dev/md0 --bitmap=3Dinternal
>>>> $ cat /sys/block/md0/md/bitmap/location
>>>> Before:+8
>>>> After: +2
>>>>=20
>>>> While growing bitmap from none to internal, clustered and llbitmap,
>>>> mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location =
first.
>>>> 1)If bitmap/location exists, it sets bitmap/location after=20
>>>> getinfo_super().
>>>> 2)If bitmap/location doesn't exist, mdadm just calls=20
>>>> md_set_array_info() then
>>>> mddev->bitmap_info.default_offset will be used.
>>>> Situation can be worse if growing none to clustered, bitmap offset=20=

>>>> of the node
>>>> calling `madm --grow` will be changed but the other node are =
reading=20
>>>> bitmap sb from
>>>> the old location.
>>>=20
>>> Now that we have a new sysfs attribute bitmap_type, can we fix this =
by:
>>> - in the kernel, allow writing to this file in this case;
>>> - in mdadm and the grow case above, write to this file first, and =
change
>>> bitmap_type from none to bitmap(For llbitmap, there is still more=20
>>> work to do).
>>>=20
>> Yes. It's indeed feasible. But how about old versions mdadm? We can't=20=

>> require
>> users' madadm + kernel combinations for old feature. Kernel part=20
>> should keep
>> compatibility with userspace. sysfs changes and broken haviros are =
not=20
>> ideal
>> especially userspace depends on it unless there's a strong reason.
>> That's why linux/Documentation/ABI exists.
>=20
> Okay, I can accept keep this old behavior.
>=20
> However, instead of introducing a new common_group with the same name =
"bitmap",
> I'll prefer to introducing a separate bitmap_ops for none bitmap as =
well, and
> you can define the attrs that are necessary.
>=20

After a try, the thing I realized is that a common group is unavoidable =
for bitmap and none bitmap.

mdadm writes to /sys/block/md0/md/bitmap/location, if remove_files() =
called by sysfs_remove_group()/
sysfs_update_group() on same kernfs node, recursive locks will be =
triggered:

[  139.516750] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  139.517363] WARNING: possible recursive locking detected
[  139.517953] 7.0.0-rc1-custom+ #282 Tainted: G           OE
[  139.518628] --------------------------------------------
[  139.519233] mdadm/2346 is trying to acquire lock:
[  139.519836] ffff8e6b24d85000 (kn->active#116){++++}-{0:0}, at: =
__kernfs_remove+0xd1/0x3e0
[  139.520848]
               but task is already holding lock:
[  139.521561] ffff8e6b24d85000 (kn->active#116){++++}-{0:0}, at: =
kernfs_fop_write_iter+0x12d/0x250
[  139.522603]
               other info that might help us debug this:
[  139.523383]  Possible unsafe locking scenario:

[  139.524169]        CPU0
[  139.524430]        ----
[  139.524682]   lock(kn->active#116);
[  139.525047]   lock(kn->active#116);
[  139.525398]
                *** DEADLOCK ***

[  139.525990]  May be due to missing lock nesting notation

[  139.526658] 4 locks held by mdadm/2346:
[  139.527049]  #0: ffff8e6acd5ec420 (sb_writers#5){.+.+}-{0:0}, at: =
ksys_write+0x6c/0xe0
[  139.527838]  #1: ffff8e6acd54fa88 (&of->mutex){+.+.}-{4:4}, at: =
kernfs_fop_write_iter+0x118/0x250
[  139.528713]  #2: ffff8e6b24d85000 (kn->active#116){++++}-{0:0}, at: =
kernfs_fop_write_iter+0x12d/0x250
[  139.529594]  #3: ffff8e6b26b51370 =
(&mddev->reconfig_mutex){+.+.}-{4:4}, at: location_store+0x6c/0x360 =
[md_mod]

[  139.530535]  dump_stack_lvl+0x68/0x90
[  139.530540]  print_deadlock_bug.cold+0xc0/0xcd
[  139.530549]  __lock_acquire+0x1324/0x2250
[  139.530556]  lock_acquire+0xc6/0x2f0
[  139.530564]  kernfs_drain+0x1eb/0x200
[  139.530568]  __kernfs_remove+0xd1/0x3e0
[  139.530570]  kernfs_remove_by_name_ns+0x5e/0xb0
[  139.530572]  internal_create_group+0x221/0x4d0
[  139.530578]  md_bitmap_create+0x122/0x130 [md_mod]
[  139.530586]  location_store+0x1e9/0x360 [md_mod]
[  139.530594]  md_attr_store+0xb8/0x1a0 [md_mod]
[  139.530602]  kernfs_fop_write_iter+0x176/0x250
[  139.530605]  vfs_write+0x21b/0x560
[  139.530609]  ksys_write+0x6c/0xe0
[  139.530611]  do_syscall_64+0x10f/0x5f0
[  139.530623]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The  patch implemented by separated bitmap_ops is attached. This version =
looks pretty similar to the first
version because of the reason listed above and IMO ungraceful. Dummy ops =
and functions are a little unnecessary.

I would like to ask your opinion since you are the maintainer even =
though I prefer v1 version + (remove the location entry for llbitmap).
Thanks.


--Apple-Mail=_85FB90DD-2A4D-4045-86BD-9CC155465240
Content-Disposition: attachment;
	filename=000-md-add-dummy-bitmap-ops-for-none-to-fix-wrong-bitmap.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="000-md-add-dummy-bitmap-ops-for-none-to-fix-wrong-bitmap.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=201dd81c439b0097d0a9a5975682801ce75448e108=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Su=20Yue=20<glass.su@suse.com>=0ADate:=20Sat,=20=
7=20Mar=202026=2012:30:36=20+0800=0ASubject:=20[PATCH=201/2]=20md:=20add=20=
dummy=20bitmap=20ops=20for=20none=20to=20fix=20wrong=20bitmap=0A=20=
offset=0A=0ABefore=20commit=20fb8cc3b0d9db=20("md/md-bitmap:=20delay=20=
registration=20of=20bitmap_ops=20until=20creating=20bitmap")=0Aif=20=
CONFIG_MD_BITMAP=20is=20enabled,=20both=20bitmap=20none,=20internal=20=
and=20clustered=20have=0Athe=20sysfs=20file=20bitmap/location.=0A=0A=
After=20the=20commit,=20if=20bitmap=20is=20none,=20bitmap/location=20=
doesn't=20exist=20anymore.=0AIt=20breaks=20'grow'=20behavior=20of=20a=20=
md=20array=20of=20madam=20with=20MD_FEATURE_BITMAP_OFFSET.=0ATake=20=
level=3Dmirror=20and=20metadata=3D1.2=20as=20an=20example:=0A=0A$=20=
mdadm=20=20--create=20=20/dev/md0=20-f=20--bitmap=3Dnone=20=
--raid-devices=3D2=20--level=3Dmirror=20\=0A=20=20--metadata=3D1.2=20=
/dev/vdd=20/dev/vde=0A$=20mdadm=20--grow=20/dev/md0=20--bitmap=3Dinternal=0A=
$=20cat=20/sys/block/md0/md/bitmap/location=0ABefore:+8=0AAfter:=20+2=0A=0A=
While=20growing=20bitmap=20from=20none=20to=20internal,=20clustered=20=
and=20llbitmap,=0Amdadm/Grow.c:Grow_addbitmap()=20tries=20to=20detect=20=
bitmap/location=20first.=0A1)If=20bitmap/location=20exists,=20it=20sets=20=
bitmap/location=20after=20getinfo_super().=0A2)If=20bitmap/location=20=
doesn't=20exist,=20mdadm=20just=20calls=20md_set_array_info()=20then=0A=
mddev->bitmap_info.default_offset=20will=20be=20used.=0ASituation=20can=20=
be=20worse=20if=20growing=20none=20to=20clustered,=20bitmap=20offset=20=
of=20the=20node=0Acalling=20`madm=20--grow`=20will=20be=20changed=20but=20=
the=20other=20node=20are=20reading=20bitmap=20sb=20from=0Athe=20old=20=
location.=0A=0AHere=20introducing=20a=20dummy=20bitmap_operations=20for=20=
ID_BITMAP_NONE=20to=20restore=20sysfs=0Afile=20bitmap/location=20for=20=
ID_BITMAP_NONE=20and=20ID_BITMAP.=0A=0AFixes:=20fb8cc3b0d9db=20=
("md/md-bitmap:=20delay=20registration=20of=20bitmap_ops=20until=20=
creating=20bitmap")=0ASigned-off-by:=20Su=20Yue=20<glass.su@suse.com>=0A=
---=0A=20drivers/md/md-bitmap.c=20|=2048=20=
++++++++++++++++++++++++++++++++++++++++--=0A=20drivers/md/md.c=20=20=20=20=
=20=20=20=20|=2046=20++++++++++++++++++++++++++++------------=0A=202=20=
files=20changed,=2078=20insertions(+),=2016=20deletions(-)=0A=0Adiff=20=
--git=20a/drivers/md/md-bitmap.c=20b/drivers/md/md-bitmap.c=0Aindex=20=
83378c033c72..d5354cf35a65=20100644=0A---=20a/drivers/md/md-bitmap.c=0A=
+++=20b/drivers/md/md-bitmap.c=0A@@=20-240,6=20+240,11=20@@=20static=20=
bool=20bitmap_enabled(void=20*data,=20bool=20flush)=0A=20=09=20=20=20=20=20=
=20=20bitmap->storage.filemap=20!=3D=20NULL;=0A=20}=0A=20=0A+static=20=
bool=20dummy_bitmap_enabled(void=20*data,=20bool=20flush)=0A+{=0A+=09=
return=20false;=0A+}=0A+=0A=20/*=0A=20=20*=20check=20a=20page=20and,=20=
if=20necessary,=20allocate=20it=20(or=20hijack=20it=20if=20the=20alloc=20=
fails)=0A=20=20*=0A@@=20-2201,6=20+2206,11=20@@=20static=20int=20=
bitmap_create(struct=20mddev=20*mddev)=0A=20=09return=200;=0A=20}=0A=20=0A=
+static=20int=20dummy_bitmap_create(struct=20mddev=20*mddev)=0A+{=0A+=09=
return=200;=0A+}=0A+=0A=20static=20int=20bitmap_load(struct=20mddev=20=
*mddev)=0A=20{=0A=20=09int=20err=20=3D=200;=0A@@=20-2956,7=20+2966,7=20=
@@=20__ATTR(max_backlog_used,=20S_IRUGO=20|=20S_IWUSR,=0A=20=20=20=20=20=20=
=20=20behind_writes_used_show,=20behind_writes_used_reset);=0A=20=0A=20=
static=20struct=20attribute=20*md_bitmap_attrs[]=20=3D=20{=0A-=09=
&bitmap_location.attr,=0A+//=09&bitmap_location.attr,=0A=20=09=
&bitmap_space.attr,=0A=20=09&bitmap_timeout.attr,=0A=20=09=
&bitmap_backlog.attr,=0A@@=20-2972,6=20+2982,17=20@@=20static=20struct=20=
attribute_group=20md_bitmap_group=20=3D=20{=0A=20=09.attrs=20=3D=20=
md_bitmap_attrs,=0A=20};=0A=20=0A+/*=20Only=20necessary=20attrs=20for=20=
compatibility=20*/=0A+static=20struct=20attribute=20=
*md_dummy_bitmap_attrs[]=20=3D=20{=0A+=09&bitmap_location.attr,=0A+=09=
NULL=0A+};=0A+=0A+static=20struct=20attribute_group=20=
md_dummy_bitmap_group=20=3D=20{=0A+=09.name=20=3D=20"bitmap",=0A+=09=
.attrs=20=3D=20md_dummy_bitmap_attrs,=0A+};=0A+=0A=20static=20struct=20=
bitmap_operations=20bitmap_ops=20=3D=20{=0A=20=09.head=20=3D=20{=0A=20=09=
=09.type=09=3D=20MD_BITMAP,=0A@@=20-3016,18=20+3037,41=20@@=20static=20=
struct=20bitmap_operations=20bitmap_ops=20=3D=20{=0A=20=09.group=09=09=09=
=3D=20&md_bitmap_group,=0A=20};=0A=20=0A+static=20struct=20=
bitmap_operations=20dummy_bitmap_ops=20=3D=20{=0A+=09.head=20=3D=20{=0A+=09=
=09.type=09=3D=20MD_BITMAP,=0A+=09=09.id=09=3D=20ID_BITMAP_NONE,=0A+=09=09=
.name=09=3D=20"none",=0A+=09},=0A+=0A+=09.enabled=09=09=3D=20=
dummy_bitmap_enabled,=0A+=09.create=09=09=09=3D=20dummy_bitmap_create,=0A=
+=09.destroy=09=09=3D=20bitmap_destroy,=0A+=09.load=09=09=09=3D=20=
bitmap_load,=0A+=09.get_stats=09=09=3D=20bitmap_get_stats,=0A+=09.free=09=
=09=09=3D=20md_bitmap_free,=0A+=09.group=09=09=09=3D=20=
&md_dummy_bitmap_group,=0A+};=0A+=0A=20int=20md_bitmap_init(void)=0A=20{=0A=
+=09int=20ret;=0A+=0A=20=09md_bitmap_wq=20=3D=20=
alloc_workqueue("md_bitmap",=20WQ_MEM_RECLAIM=20|=20WQ_UNBOUND,=0A=20=09=09=
=09=09=20=20=20=20=20=20=200);=0A=20=09if=20(!md_bitmap_wq)=0A=20=09=09=
return=20-ENOMEM;=0A=20=0A-=09return=20=
register_md_submodule(&bitmap_ops.head);=0A+=09ret=20=3D=20=
register_md_submodule(&bitmap_ops.head);=0A+=09if=20(ret)=0A+=09=09=
return=20ret;=0A+=0A+=09return=20=
register_md_submodule(&dummy_bitmap_ops.head);=0A=20}=0A=20=0A=20void=20=
md_bitmap_exit(void)=0A=20{=0A=20=09destroy_workqueue(md_bitmap_wq);=0A=20=
=09unregister_md_submodule(&bitmap_ops.head);=0A+=09=
unregister_md_submodule(&dummy_bitmap_ops.head);=0A=20}=0Adiff=20--git=20=
a/drivers/md/md.c=20b/drivers/md/md.c=0Aindex=20=
3ce6f9e9d38e..94ded8efb725=20100644=0A---=20a/drivers/md/md.c=0A+++=20=
b/drivers/md/md.c=0A@@=20-682,9=20+682,9=20@@=20static=20bool=20=
mddev_set_bitmap_ops(struct=20mddev=20*mddev)=0A=20{=0A=20=09struct=20=
bitmap_operations=20*old=20=3D=20mddev->bitmap_ops;=0A=20=09struct=20=
md_submodule_head=20*head;=0A+=09int=20err=20=3D=200;=0A=20=0A-=09if=20=
(mddev->bitmap_id=20=3D=3D=20ID_BITMAP_NONE=20||=0A-=09=20=20=20=20(old=20=
&&=20old->head.id=20=3D=3D=20mddev->bitmap_id))=0A+=09if=20(old=20&&=20=
old->head.id=20=3D=3D=20mddev->bitmap_id)=0A=20=09=09return=20true;=0A=20=
=0A=20=09xa_lock(&md_submodule);=0A@@=20-704,13=20+704,24=20@@=20static=20=
bool=20mddev_set_bitmap_ops(struct=20mddev=20*mddev)=0A=20=09=
xa_unlock(&md_submodule);=0A=20=0A=20=09if=20(!mddev_is_dm(mddev)=20&&=20=
mddev->bitmap_ops->group)=20{=0A-=09=09if=20=
(sysfs_create_group(&mddev->kobj,=20mddev->bitmap_ops->group))=0A+=0A+=09=
=09if=20(old=20&&=20old->head.id=20=3D=3D=20ID_BITMAP_NONE)=20{=0A+=09=09=
=09if=20(head->id=20=3D=3D=20ID_BITMAP)=20{=0A+=09=09=09=09err=20=3D=20=
sysfs_merge_group(&mddev->kobj,=20mddev->bitmap_ops->group);=0A+=09=09=09=
}=20else=20if=20(head->id=20=3D=3D=20ID_LLBITMAP)=20{=0A+=09=09=09=09=
sysfs_remove_group(&mddev->kobj,=20mddev->bitmap_ops->group);=0A+=09=09=09=
=09err=20=3D=20sysfs_create_group(&mddev->kobj,=20=
mddev->bitmap_ops->group);=0A+=09=09=09}=0A+=09=09}=20else=20{=0A+=09=09=09=
err=20=3D=20sysfs_create_group(&mddev->kobj,=20=
mddev->bitmap_ops->group);=0A+=09=09}=0A+=0A+=09=09if=20(err)=0A=20=09=09=
=09pr_warn("md:=20cannot=20register=20extra=20bitmap=20attributes=20for=20=
%s\n",=0A=20=09=09=09=09mdname(mddev));=0A=20=09=09else=0A=20=09=09=09/*=0A=
-=09=09=09=20*=20Inform=20user=20with=20KOBJ_CHANGE=20about=20new=20=
bitmap=0A-=09=09=09=20*=20attributes.=0A+=09=09=09=20*=20Inform=20user=20=
with=20KOBJ_CHANGE=20about=20bitmap=20attributes=20changes.=0A=20=09=09=09=
=20*/=0A=20=09=09=09kobject_uevent(&mddev->kobj,=20KOBJ_CHANGE);=0A=20=09=
}=0A@@=20-723,11=20+734,20=20@@=20static=20bool=20=
mddev_set_bitmap_ops(struct=20mddev=20*mddev)=0A=20=0A=20static=20void=20=
mddev_clear_bitmap_ops(struct=20mddev=20*mddev)=0A=20{=0A-=09if=20=
(!mddev_is_dm(mddev)=20&&=20mddev->bitmap_ops=20&&=0A-=09=20=20=20=20=
mddev->bitmap_ops->group)=0A-=09=09sysfs_remove_group(&mddev->kobj,=20=
mddev->bitmap_ops->group);=0A+=09if=20(mddev_is_dm(mddev)=20||=20=
!mddev->bitmap_ops)=0A+=09=09return;=0A=20=0A-=09mddev->bitmap_ops=20=3D=20=
NULL;=0A+=09if=20(mddev->bitmap_ops->head.id=20=3D=3D=20ID_BITMAP_NONE)=0A=
+=09=09return;=0A+=0A+=09if=20(mddev->bitmap_ops->group)=0A+=09=09=
sysfs_remove_group(&mddev->kobj,=20mddev->bitmap_ops->group);=0A+=09/*=0A=
+=09=20*=20group=20of=20ID_BITMAP_NONE=20is=20removed=20when=20new=20=
bitmap=20is=0A+=09=20*=20creating=20in=20mddev_set_bitmap_ops().=0A+=09=20=
*/=0A+=09mddev->bitmap_id=20=3D=20ID_BITMAP_NONE;=0A+=09=
md_bitmap_create(mddev);=0A=20}=0A=20=0A=20int=20mddev_init(struct=20=
mddev=20*mddev)=0A@@=20-6449,9=20+6469,6=20@@=20static=20int=20=
start_dirty_degraded;=0A=20=0A=20static=20int=20md_bitmap_create(struct=20=
mddev=20*mddev)=0A=20{=0A-=09if=20(mddev->bitmap_id=20=3D=3D=20=
ID_BITMAP_NONE)=0A-=09=09return=20-EINVAL;=0A-=0A=20=09if=20=
(!mddev_set_bitmap_ops(mddev))=0A=20=09=09return=20-ENOENT;=0A=20=0A@@=20=
-6610,8=20+6627,9=20@@=20int=20md_run(struct=20mddev=20*mddev)=0A=20=09=09=
=09(unsigned=20long=20long)pers->size(mddev,=200,=200)=20/=202);=0A=20=09=
=09err=20=3D=20-EINVAL;=0A=20=09}=0A-=09if=20(err=20=3D=3D=200=20&&=20=
pers->sync_request=20&&=0A-=09=20=20=20=20(mddev->bitmap_info.file=20||=20=
mddev->bitmap_info.offset))=20{=0A+=09if=20(err=20=3D=3D=200=20&&=20=
pers->sync_request)=20{=0A+=09=09if=20(mddev->bitmap_info.offset=20=3D=3D=20=
0)=0A+=09=09=09mddev->bitmap_id=20=3D=20ID_BITMAP_NONE;=0A=20=09=09err=20=
=3D=20md_bitmap_create(mddev);=0A=20=09=09if=20(err)=0A=20=09=09=09=
pr_warn("%s:=20failed=20to=20create=20bitmap=20(%d)\n",=0A--=20=0A2.53.0=0A=
=0A=

--Apple-Mail=_85FB90DD-2A4D-4045-86BD-9CC155465240
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



=E2=80=94=20
Su



> For llbitmap, I think it's fine, we don't need this old sysfs attr =
anyway. I'll
> support to convert from none/bitmap to llbitmap by writing the new =
bitmap_type
> file.
>=20
>=20
>>=20
>> --=20
>> Su
>>=20
>>>>=20
>>>> Here restore sysfs file bitmap/location for ID_BITMAP_NONE and=20
>>>> ID_BITMAP.
>>>> And it d adds the entry for llbitmap too.
>>>>=20
>>>> New attribute_group md_bitmap_common_group is introduced and =
created in
>>>> md_alloc() as before commit fb8cc3b0d9db.
>>>> Add New operations register_group and unregister_group to struct=20
>>>> bitmap_operations.
>>>>=20
>>>> Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of =
bitmap_ops=20
>>>> until creating bitmap")
>>>> Signed-off-by: Su Yue <glass.su@suse.com>
>>>> ---
>>>>   drivers/md/md-bitmap.c   | 32 +++++++++++++++++++++++++++++++-
>>>>   drivers/md/md-bitmap.h   |  5 +++++
>>>>   drivers/md/md-llbitmap.c | 13 +++++++++++++
>>>>   drivers/md/md.c          | 16 ++++++++++++----
>>>>   4 files changed, 61 insertions(+), 5 deletions(-)
>>>>=20
>>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>>> index 83378c033c72..8ff1dc94ed78 100644
>>>> --- a/drivers/md/md-bitmap.c
>>>> +++ b/drivers/md/md-bitmap.c
>>>> @@ -2956,7 +2956,6 @@ __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
>>>>          behind_writes_used_show, behind_writes_used_reset);
>>>>=20
>>>>   static struct attribute *md_bitmap_attrs[] =3D {
>>>> -    &bitmap_location.attr,
>>>>       &bitmap_space.attr,
>>>>       &bitmap_timeout.attr,
>>>>       &bitmap_backlog.attr,
>>>> @@ -2967,11 +2966,40 @@ static struct attribute *md_bitmap_attrs[] =
=3D {
>>>>       NULL
>>>>   };
>>>>=20
>>>> +static struct attribute *md_bitmap_common_attrs[] =3D {
>>>> +    &bitmap_location.attr,
>>>> +    NULL
>>>> +};
>>>> +
>>>>   static struct attribute_group md_bitmap_group =3D {
>>>>       .name =3D "bitmap",
>>>>       .attrs =3D md_bitmap_attrs,
>>>>   };
>>>>=20
>>>> +static struct attribute_group md_bitmap_common_group =3D {
>>>> +    .name =3D "bitmap",
>>>> +    .attrs =3D md_bitmap_common_attrs,
>>>> +};
>>>> +
>>>> +int md_sysfs_create_common_group(struct mddev *mddev)
>>>> +{
>>>> +    return sysfs_create_group(&mddev->kobj, =
&md_bitmap_common_group);
>>>> +}
>>>> +
>>>> +static int bitmap_register_group(struct mddev *mddev)
>>>> +{
>>>> +    /*
>>>> +     * md_bitmap_group and md_bitmap_common_group are using same =
name
>>>> +     * 'bitmap'.
>>>> +     */
>>>> +    return sysfs_merge_group(&mddev->kobj, &md_bitmap_group);
>>>> +}
>>>> +
>>>> +static void bitmap_unregister_group(struct mddev *mddev)
>>>> +{
>>>> +    sysfs_unmerge_group(&mddev->kobj, &md_bitmap_group);
>>>> +}
>>>> +
>>>>   static struct bitmap_operations bitmap_ops =3D {
>>>>       .head =3D {
>>>>           .type    =3D MD_BITMAP,
>>>> @@ -3013,6 +3041,8 @@ static struct bitmap_operations bitmap_ops =3D =
{
>>>>       .set_pages        =3D bitmap_set_pages,
>>>>       .free            =3D md_bitmap_free,
>>>>=20
>>>> +    .register_group        =3D bitmap_register_group,
>>>> +    .unregister_group    =3D bitmap_unregister_group,
>>>>       .group            =3D &md_bitmap_group,
>>>>   };
>>>>=20
>>>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>>>> index b42a28fa83a0..371791e9011d 100644
>>>> --- a/drivers/md/md-bitmap.h
>>>> +++ b/drivers/md/md-bitmap.h
>>>> @@ -125,6 +125,9 @@ struct bitmap_operations {
>>>>       void (*set_pages)(void *data, unsigned long pages);
>>>>       void (*free)(void *data);
>>>>=20
>>>> +    int (*register_group)(struct mddev *mddev);
>>>> +    void (*unregister_group)(struct mddev *mddev);
>>>> +
>>>>       struct attribute_group *group;
>>>>   };
>>>>=20
>>>> @@ -169,6 +172,8 @@ static inline void md_bitmap_end_sync(struct=20
>>>> mddev *mddev, sector_t offset,
>>>>       mddev->bitmap_ops->end_sync(mddev, offset, blocks);
>>>>   }
>>>>=20
>>>> +int md_sysfs_create_common_group(struct mddev *mddev);
>>>> +
>>>>   #ifdef CONFIG_MD_BITMAP
>>>>   int md_bitmap_init(void);
>>>>   void md_bitmap_exit(void);
>>>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>>>> index bf398d7476b3..24ff5f7f8751 100644
>>>> --- a/drivers/md/md-llbitmap.c
>>>> +++ b/drivers/md/md-llbitmap.c
>>>> @@ -1561,6 +1561,16 @@ static struct attribute_group=20
>>>> md_llbitmap_group =3D {
>>>>       .attrs =3D md_llbitmap_attrs,
>>>>   };
>>>>=20
>>>> +static int llbitmap_register_group(struct mddev *mddev)
>>>> +{
>>>> +    return sysfs_create_group(&mddev->kobj, &md_llbitmap_group);
>>>> +}
>>>> +
>>>> +static void llbitmap_unregister_group(struct mddev *mddev)
>>>> +{
>>>> +    sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
>>>> +}
>>>> +
>>>>   static struct bitmap_operations llbitmap_ops =3D {
>>>>       .head =3D {
>>>>           .type    =3D MD_BITMAP,
>>>> @@ -1597,6 +1607,9 @@ static struct bitmap_operations llbitmap_ops =
=3D {
>>>>       .dirty_bits        =3D llbitmap_dirty_bits,
>>>>       .write_all        =3D llbitmap_write_all,
>>>>=20
>>>> +    .register_group        =3D llbitmap_register_group,
>>>> +    .unregister_group    =3D llbitmap_unregister_group,
>>>> +
>>>>       .group            =3D &md_llbitmap_group,
>>>>   };
>>>>=20
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 3ce6f9e9d38e..ab969e950ea8 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -703,8 +703,8 @@ static bool mddev_set_bitmap_ops(struct mddev=20=

>>>> *mddev)
>>>>       mddev->bitmap_ops =3D (void *)head;
>>>>       xa_unlock(&md_submodule);
>>>>=20
>>>> -    if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
>>>> -        if (sysfs_create_group(&mddev->kobj,=20
>>>> mddev->bitmap_ops->group))
>>>> +    if (!mddev_is_dm(mddev) && mddev->bitmap_ops->register_group) =
{
>>>> +        if (mddev->bitmap_ops->register_group(mddev))
>>>>               pr_warn("md: cannot register extra bitmap attributes=20=

>>>> for %s\n",
>>>>                   mdname(mddev));
>>>>           else
>>>> @@ -724,8 +724,8 @@ static bool mddev_set_bitmap_ops(struct mddev=20=

>>>> *mddev)
>>>>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>>>   {
>>>>       if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
>>>> -        mddev->bitmap_ops->group)
>>>> -        sysfs_remove_group(&mddev->kobj, =
mddev->bitmap_ops->group);
>>>> +        mddev->bitmap_ops->unregister_group)
>>>> +        mddev->bitmap_ops->unregister_group(mddev);
>>>>=20
>>>>       mddev->bitmap_ops =3D NULL;
>>>>   }
>>>> @@ -6369,6 +6369,14 @@ struct mddev *md_alloc(dev_t dev, char =
*name)
>>>>           return ERR_PTR(error);
>>>>       }
>>>>=20
>>>> +    /*
>>>> +     * md_sysfs_remove_common_group is not needed because=20
>>>> mddev_delayed_delete
>>>> +     * calls kobject_put(&mddev->kobj) if mddev is to be deleted.
>>>> +     */
>>>> +    if (md_sysfs_create_common_group(mddev))
>>>> +        pr_warn("md: cannot register common bitmap attributes for=20=

>>>> %s\n",
>>>> +            mdname(mddev));
>>>> +
>>>>       kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>>       mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd,  =
=20
>>>> "array_state");
>>>>       mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd,  =
=20
>>>> "level");
>=20
> --=20
> Thansk,
> Kuai



--Apple-Mail=_85FB90DD-2A4D-4045-86BD-9CC155465240--
