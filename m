Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C4653379
	for <linux-raid@vger.kernel.org>; Wed, 20 Mar 2024 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710947748; cv=none; b=rXnG2sdN9eJJU4uB7RkGPXDbrAYuArToYntrnpSzKc9XSW5K2coG5VnQ3MFhGPHhInnhk7xXUBt3zO25u2Ilv5MGDzdapIoAGGoe61SRs5X/CKO2mmN+JPT2OGRiXQzdOPWnneg0PHd5lANBSP5BNhVomMTKP6OKKJmQ1+rKnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710947748; c=relaxed/simple;
	bh=ougwBorqozwBhdlNAcKf6+K1aQzQm8/Z9jjaXaquXEM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Xx5OLP6i0cst7LRUAShjKYZW74/sGgzprMGDUrLZ3XCs9VmdFFsVopmwB6A3hCl2y0/6Yip9ERNXWNN9lv+Lig9EkLdmdniFue38ITk7/SQr/XuOlqy5G/uE7t/Epc4mXEYz771l+0RUDWu82niS7uvyYICCcTNMI1lRboM3YG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vmj3ZTCl; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vmj3ZTCl"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5a4716cfbbcso3663805eaf.2
        for <linux-raid@vger.kernel.org>; Wed, 20 Mar 2024 08:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710947746; x=1711552546; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TqqwsspzyJGNfuhWBdaLkU6DYOp9lQ1p7c0+j8fyg48=;
        b=Vmj3ZTClv/cpXOzGM7sCx8DgGOKkgdndNwFnS24oh2/J43+N4oqPQKNzmc1v8owrZB
         uE/p5Ahz96AGrGQbfEusRjrDrFl4pJ9Q5J86BQ7yI1iuEDA7peZnEa5ndo8m4rTsThFa
         7F5OB7H9kjO0osxSHjZ9A7DicnaD5BZe4ch4UE6LT5aj7UP6RCU5uH7HBeWtURo6if0s
         gHYKhLOPuimCCk/uHe3KnHwwBPizBd7MSvqQse6dxTXVVCt23HUXym6kyZey1OfXNX7S
         wdLEYzRhhypV20pOUvvsWPW2zIZ+RE/EU1Y6G2x/OEfmQUcL39Sd2MrZjHgmUFVOTR92
         pOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710947746; x=1711552546;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TqqwsspzyJGNfuhWBdaLkU6DYOp9lQ1p7c0+j8fyg48=;
        b=WXgk4Mq6nOtvCa5+4OBgT6Btk8i4/cIVhMWniUO19WqU3eGMSrvl6rZJd9+bu33nrU
         hQW8uN1Tq2fpLli3rfXC3/fXOKe5GXomLmN8bXDCQlaE2Ho+5AnZvVEaNzIAgCp1VPk4
         0TsTNRilQpsSYqwnpIi1BeOqqtAS8IJ0uZb0Xc1BxUuymuzHdQ4tTMeKVU5iAV9lvhEL
         cBpOqREaypVTqhTMlwYsnWYE9lxe/E7i0mx8vofwHjmjS98+NVE5tNnpAyPT5QY9N32G
         6tpcHG0tSDVp+JlBddvPpnPNULx3pKW+i6BCY0V9tNPWlzgA7A/4DlWA2MWtugKRm+la
         +OKw==
X-Gm-Message-State: AOJu0YyUeP7x+SJyz7ziaO3IDspN4AOAUsXOb1cScWIXzMOV01L8Kv0Y
	B6Gc4Gar6UzMRRZaAkGshRgMu38txicvgplubxvuC+NsMK1FDZg+4VlacOl/61RJTPiUrerpSRP
	5CYOhi3Hbm6DUzgtByHa9aTg+zyeYCSMwyaY=
X-Google-Smtp-Source: AGHT+IHZvaNJSNULSUjWz5eHUkhICVaSkkjD7x+4trtmsVdKNO+Ce9nc0oFE5+XQvcNaYH/UWKc8Uz0W55ypmYYSNOY=
X-Received: by 2002:a05:6871:7508:b0:229:8edf:886b with SMTP id
 ny8-20020a056871750800b002298edf886bmr4094316oac.22.1710947745860; Wed, 20
 Mar 2024 08:15:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: d tbsky <tbskyd@gmail.com>
Date: Wed, 20 Mar 2024 23:15:34 +0800
Message-ID: <CAC6SzH+KS2Y9QngciLrRytacMS4EvnCAigafbLO9i+DObm4CqA@mail.gmail.com>
Subject: md-uuid inconsistent in the future
To: list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi:
    today I want to install RHEL 9.3 with mdadm software raid1 "/boot"
partition to a server. installation failed with message "failed to
write boot loader configuration".

   I switched to console and "dmesg" showed a lot of errors about "rtc
write failed with error -22". I checked the system time and found
someone set the server to year "2223". I correct the time to year
"2024" and reinstall RHEL 9.3 with the same disk layout (eg: I didn't
recreate mdadm raid since it will need extra steps). and again
installation failed with the same error message.

   I was curious so I checked what happened. I found md-uuid string is
reversed from "/dev/disk/by-id" and mdadm itself. Below are some
strange results. Maybe the issue is not important and people in the
far future will fix it someday if we don't kill the bug. Just share
the experience.

>ls -la /dev/disk/by-id | grep md-uuid
lrwxrwxrwx 1 root root   11 Mar 20 03:10
md-uuid-a4e266d2:68ae1848:1a6d6a71:a419ebdb -> ../../md127

>mdadm --examine --scan
ARRAY /dev/md/boot  metadata=1.2
UUID=d266e2a4:4818ae68:716a6d1a:dbeb19a4
name=localhost.localdomain:boot

>mdadm -E /dev/sda2  (result show created at year 2223)
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d266e2a4:4818ae68:716a6d1a:dbeb19a4
           Name : localhost.localdomain:boot  (local to host
localhost.localdomain)
  Creation Time : Fri Nov 14 07:32:22 2223
     Raid Level : raid1
   Raid Devices : 5

 Avail Dev Size : 1048576 sectors (512.00 MiB 536.87 MB)
     Array Size : 524288 KiB (512.00 MiB 536.87 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=0 sectors
          State : clean
    Device UUID : 4007990e:44762c79:efab3543:04a55382

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Mar 20 03:07:49 2024
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 87a9793f - correct
         Events : 38


   Device Role : Active device 3
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)


>mdadm --details /dev/md127 (result show created at year 2106 which is not correct)
/dev/md127:
           Version : 1.2
     Creation Time : Sun Feb  7 06:28:15 2106
        Raid Level : raid1
        Array Size : 524288 (512.00 MiB 536.87 MB)
     Used Dev Size : 524288 (512.00 MiB 536.87 MB)
      Raid Devices : 5
     Total Devices : 5
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Wed Mar 20 03:07:49 2024
             State : clean
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

    Number   Major   Minor   RaidDevice State
       0       8       50        0      active sync   /dev/sdd2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8        2        3      active sync   /dev/sda2
       4       8       66        4      active sync   /dev/sde2
