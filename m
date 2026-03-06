Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A1328B7F
	for <linux-raid@vger.kernel.org>; Fri,  6 Mar 2026 04:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772771138; cv=none; b=UC1IUBATdtbZoWdRC/9X0LtqFdqHmRrGm4Rp7hc5vu+F2/H/1YZv+Ne8FtUawKG/xTYW3btfviEAUvvZGjULO9lpEvhY6WwG2YfjQXN7phayWK6oee3FQVu4LuJ69bLH+PeTNjgKuCmAFdTeoOUpIaWoanYQOmki75Xu0BNCFNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772771138; c=relaxed/simple;
	bh=3xlmtB2PFFJoc9WG8mIDsCqppWWwbZ7rLVmpPFx2GjA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oSzJPSthcrXeY3sQFnL6krMiA/RIMIYvyzGaxudRsx6nZdhtupEebwdcCgHRjzVPJ3aG1/yzFoUduWTn8WzAZ+ba3ckQ1Fm8M245xDVZDRWso1SE4/0f1Id+ATeQmgLfxEaq10BzUSaQO6WyMT4SMtNnSBZKWcJvbEoRcq1P9j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MBIIAEZL; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MBIIAEZL"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48370174e18so52758625e9.2
        for <linux-raid@vger.kernel.org>; Thu, 05 Mar 2026 20:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772771135; x=1773375935; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KA1lszZwUH3EqTcHfpy8Dr7ptwzwhEjwl9qaPj5djgU=;
        b=MBIIAEZLPAnbZkxiL0iFTLWCPano6bTV7Y0SewRHtaJw2YKG1zLn/t5B21eiPsVziy
         vAIWCwa6H6zhArX9wuAjytH2YmcBKvs1lh1qef3Zd72SczOASUJ0vRqBheYMqsTikstU
         buFurrZfDXeTb9k4yVltbMjNjp5hKXX0tjtIKuSLCNmoqCd8gSSk8POUjgVjKb7509eS
         GJv5wmi3HzH6fhVxhHulaujkzqPkQ420SXVHQM/ZPHqxQ62hJSzjVI01dRLgTGBVSlWM
         YoXD8gjzno7zMDIt1bjx88HQhlEjcxbSisGlnQPJqYaubm7kOo6jvCgcTC/7TAcstkY0
         94Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772771135; x=1773375935;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KA1lszZwUH3EqTcHfpy8Dr7ptwzwhEjwl9qaPj5djgU=;
        b=LxNpnP2OnFix7pB0nURDfVPsuycoK1vWgPJ4hqO7gZgdSlePKKORtA33v8cbeDFQii
         WdqZqZl3sKSAWIbMKvHRXFOaje5mE9h1NspNQBfxkpB5nixezTl90/iaWWBGrnWKkgeE
         tR8JOqp2BU9aXE9JO4IrramjNHXOAXkhodB1g5x9lgbP7JgopIxxnLhWsGNyFLJtLVP2
         aAx8y3zJVHvMekN2avQfnxpqfArhzri65CfcJkKmPokatKr7FvboVUA9QyuA/bIRe2EQ
         m8rX1wGGM446Ddk8B6597Z0T/65snbiUxRdqjstzCVHTR7tZV0ghpJdEYxXTP6zzu2RU
         nT4A==
X-Gm-Message-State: AOJu0YyQm4jrIALh+X5wgAUOGB59Sc0BhENkFJB8vGiZ0t1NGVVJSVWt
	v4fa/92rb/ERPhfs45J65v9pKlP0YYmi0FaggK9gbgw2ibY9NnDXjfTFWdu2vL4ykAc=
X-Gm-Gg: ATEYQzz37j46WvP7felnfn5w7yMZFgk8IakctVNY0Mq7zmJkNQKel7xdXwye9+6q5Xr
	MXcGSR9vLNwdU73QktUB9SHj+mzqrB/2WoJUiCDZiSfWpis+FboJtz6NU/amVIOXps/+goihBfP
	3IEe/00M8AEXudnmdsd3XbndYceUcrIsaxwNMCHrEqd20BvFYH62uM489M2ym4FicesIH/5IrZk
	s56uDFEgnjqOSC38pg+ZNzSxIwIj59/YFRw1j/IpozUxXWBvCqSJWV2Crk0MJFXo9up/LxkvhQo
	Iz8DEo3xLJnyL85N1wWWlBaq/xZPQvcMddWbNqNExiyQm/GgLMkHt5aMIkSX+cSJBbiQlYjInnb
	imldBeyDZ2gqitTgB9ZW1LqQmPBpB4Ai4RGETUDdp73xo+qAxh0I9M0L6ceihSXExOOLBAgEsDO
	sAFjrTYeY8buJDnWv0WhQRz6I1rQ==
X-Received: by 2002:a05:600c:46d1:b0:47a:814c:eea1 with SMTP id 5b1f17b1804b1-4852697956amr9208445e9.35.1772771135261;
        Thu, 05 Mar 2026 20:25:35 -0800 (PST)
Received: from smtpclient.apple ([154.26.180.185])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f828b30sm353805eec.8.2026.03.05.20.25.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2026 20:25:33 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap
 offset while growing
From: Glass Su <glass.su@suse.com>
In-Reply-To: <202603060614.AZY6J9w9-lkp@intel.com>
Date: Fri, 6 Mar 2026 12:25:15 +0800
Cc: linux-raid@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev,
 song@kernel.org,
 xni@redhat.com,
 linan122@huawei.com,
 yukuai@fnnas.com,
 Heming Zhao <heming.zhao@suse.com>,
 Su Yue <l@damenly.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <56C72373-16C6-46D7-8DB7-A12E704CE480@suse.com>
References: <20260303033731.83885-2-glass.su@suse.com>
 <202603060614.AZY6J9w9-lkp@intel.com>
To: kernel test robot <lkp@intel.com>
X-Mailer: Apple Mail (2.3864.400.21)



> On Mar 6, 2026, at 06:50, kernel test robot <lkp@intel.com> wrote:
>=20
> Hi Su,
>=20
> kernel test robot noticed the following build errors:
>=20
> [auto build test ERROR on linus/master]
> [also build test ERROR on v7.0-rc2 next-20260305]
> [If your patch is applied to the wrong git tree, kindly drop us a =
note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    =
https://github.com/intel-lab-lkp/linux/commits/Su-Yue/md-restore-bitmap-lo=
cation-to-fix-wrong-bitmap-offset-while-growing/20260303-114108
> base:   linus/master
> patch link:    =
https://lore.kernel.org/r/20260303033731.83885-2-glass.su%40suse.com
> patch subject: [PATCH 1/3] md: restore bitmap/location to fix wrong =
bitmap offset while growing
> config: i386-randconfig-051-20260305 =
(https://download.01.org/0day-ci/archive/20260306/202603060614.AZY6J9w9-lk=
p@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=3D1 build): =
(https://download.01.org/0day-ci/archive/20260306/202603060614.AZY6J9w9-lk=
p@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: =
https://lore.kernel.org/oe-kbuild-all/202603060614.AZY6J9w9-lkp@intel.com/=

>=20
> All errors (new ones prefixed by >>):
>=20
>   ld: drivers/md/md.o: in function `md_alloc':
>>> drivers/md/md.c:6376:(.text+0xb36c): undefined reference to =
`md_sysfs_create_common_group'

Forget to test it with=20

# CONFIG_MD_BITMAP is not set

Anyway, I will do  revision as Yu Kuai=E2=80=99s suggestion.

=E2=80=94=20
Su

>=20

>=20
> vim +6376 drivers/md/md.c
>=20
>  6276=20
>  6277 struct mddev *md_alloc(dev_t dev, char *name)
>  6278 {
>  6279 /*
>  6280 * If dev is zero, name is the name of a device to allocate with
>  6281 * an arbitrary minor number.  It will be "md_???"
>  6282 * If dev is non-zero it must be a device number with a MAJOR of
>  6283 * MD_MAJOR or mdp_major.  In this case, if "name" is NULL, then
>  6284 * the device is being created by opening a node in /dev.
>  6285 * If "name" is not NULL, the device is being created by
>  6286 * writing to /sys/module/md_mod/parameters/new_array.
>  6287 */
>  6288 static DEFINE_MUTEX(disks_mutex);
>  6289 struct mddev *mddev;
>  6290 struct gendisk *disk;
>  6291 int partitioned;
>  6292 int shift;
>  6293 int unit;
>  6294 int error;
>  6295=20
>  6296 /*
>  6297 * Wait for any previous instance of this device to be completely
>  6298 * removed (mddev_delayed_delete).
>  6299 */
>  6300 flush_workqueue(md_misc_wq);
>  6301=20
>  6302 mutex_lock(&disks_mutex);
>  6303 mddev =3D mddev_alloc(dev);
>  6304 if (IS_ERR(mddev)) {
>  6305 error =3D PTR_ERR(mddev);
>  6306 goto out_unlock;
>  6307 }
>  6308=20
>  6309 partitioned =3D (MAJOR(mddev->unit) !=3D MD_MAJOR);
>  6310 shift =3D partitioned ? MdpMinorShift : 0;
>  6311 unit =3D MINOR(mddev->unit) >> shift;
>  6312=20
>  6313 if (name && !dev) {
>  6314 /* Need to ensure that 'name' is not a duplicate.
>  6315 */
>  6316 struct mddev *mddev2;
>  6317 spin_lock(&all_mddevs_lock);
>  6318=20
>  6319 list_for_each_entry(mddev2, &all_mddevs, all_mddevs)
>  6320 if (mddev2->gendisk &&
>  6321    strcmp(mddev2->gendisk->disk_name, name) =3D=3D 0) {
>  6322 spin_unlock(&all_mddevs_lock);
>  6323 error =3D -EEXIST;
>  6324 goto out_free_mddev;
>  6325 }
>  6326 spin_unlock(&all_mddevs_lock);
>  6327 }
>  6328 if (name && dev)
>  6329 /*
>  6330 * Creating /dev/mdNNN via "newarray", so adjust hold_active.
>  6331 */
>  6332 mddev->hold_active =3D UNTIL_STOP;
>  6333=20
>  6334 disk =3D blk_alloc_disk(NULL, NUMA_NO_NODE);
>  6335 if (IS_ERR(disk)) {
>  6336 error =3D PTR_ERR(disk);
>  6337 goto out_free_mddev;
>  6338 }
>  6339=20
>  6340 disk->major =3D MAJOR(mddev->unit);
>  6341 disk->first_minor =3D unit << shift;
>  6342 disk->minors =3D 1 << shift;
>  6343 if (name)
>  6344 strcpy(disk->disk_name, name);
>  6345 else if (partitioned)
>  6346 sprintf(disk->disk_name, "md_d%d", unit);
>  6347 else
>  6348 sprintf(disk->disk_name, "md%d", unit);
>  6349 disk->fops =3D &md_fops;
>  6350 disk->private_data =3D mddev;
>  6351=20
>  6352 disk->events |=3D DISK_EVENT_MEDIA_CHANGE;
>  6353 mddev->gendisk =3D disk;
>  6354 error =3D add_disk(disk);
>  6355 if (error)
>  6356 goto out_put_disk;
>  6357=20
>  6358 kobject_init(&mddev->kobj, &md_ktype);
>  6359 error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, =
"%s", "md");
>  6360 if (error) {
>  6361 /*
>  6362 * The disk is already live at this point.  Clear the hold flag
>  6363 * and let mddev_put take care of the deletion, as it isn't any
>  6364 * different from a normal close on last release now.
>  6365 */
>  6366 mddev->hold_active =3D 0;
>  6367 mutex_unlock(&disks_mutex);
>  6368 mddev_put(mddev);
>  6369 return ERR_PTR(error);
>  6370 }
>  6371=20
>  6372 /*
>  6373 * md_sysfs_remove_common_group is not needed because =
mddev_delayed_delete
>  6374 * calls kobject_put(&mddev->kobj) if mddev is to be deleted.
>  6375 */
>> 6376 if (md_sysfs_create_common_group(mddev))
>  6377 pr_warn("md: cannot register common bitmap attributes for %s\n",
>  6378 mdname(mddev));
>  6379=20
>  6380 kobject_uevent(&mddev->kobj, KOBJ_ADD);
>  6381 mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, =
"array_state");
>  6382 mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, =
"level");
>  6383 mutex_unlock(&disks_mutex);
>  6384 return mddev;
>  6385=20
>  6386 out_put_disk:
>  6387 put_disk(disk);
>  6388 out_free_mddev:
>  6389 mddev_free(mddev);
>  6390 out_unlock:
>  6391 mutex_unlock(&disks_mutex);
>  6392 return ERR_PTR(error);
>  6393 }
>  6394=20
>=20
> --=20
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

