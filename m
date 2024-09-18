Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3992918C356
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667847; cv=none; b=TqsDGlgv7tsqc74nJmFSzATeYrjMIrpC3JL0rZUvOAHctH2zmEM4r8iliqMr8jKjg64NYdgMKX3JBss0b8xZK3nGsDg8dvnGyn0x36yzXJZeNKJEdy0pd1JKvceuPkLd6sH5L//yqFkEg47tw9t7So1H0YlKgQZIPctSQCEyzt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667847; c=relaxed/simple;
	bh=CYnZo8oIXaibxDIo8/Zf5BqlMMsWwzDyhbg/rO7KVMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iVX3xFoz9Rjcf8tLgDki4/aDRlS+lOMXxAYlWK3eDpX+N8cDYEtyXEDCelMBJC/tPJr1+RtgFAzbTeCf3rvHY4uduuUvuBsU7uy4KpgHfuYRtyhRjG1vyg53XH1lY6x9FSlW3i/OoS4+QWjwKAWleWCFNEMNi8f75Hv29gmA0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nniyfbRS; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nniyfbRS"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6ddcd0b4c59so32447317b3.3
        for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 06:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726667844; x=1727272644; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CYnZo8oIXaibxDIo8/Zf5BqlMMsWwzDyhbg/rO7KVMw=;
        b=nniyfbRSZFJdqoD2QBd9ulyYa94BA4LUiFpaiMnL6SqQUbiFllXL3D7/9OenDnd7hi
         CiogO1qLTh01okdZEqpG7a+z1OUhwPfNorL7iCQcxK0WyRQTxNfLTcVKDjT7G8yyZVpz
         sEqu54cT7ClzagQH+6D/PEs0veoUBh1lpir9ZYf8TLv5jH5RRZiRhJg3VJ+Pjmn5C20C
         BprDIwH2UmhrRHnYCSIx0xhWDWrfZYkgfMGZUo2aWVHi+kPcf/CcbQ3vcsPbDHmER7U9
         WTc7vUxu6vombYhsNGmT3w3a+/dXQpOWRFNVPV9SmBRFWZIz2moN1hLbevJLk0lbBha7
         vSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726667844; x=1727272644;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYnZo8oIXaibxDIo8/Zf5BqlMMsWwzDyhbg/rO7KVMw=;
        b=Mi8awUmXenQ4T3SZEo5CKYvkLQkuJ34GdDOYHHKVdMYQCaoSosAijqPjXJ+KFo9eKI
         9049gNfASlqTNOxmMYa455COlXZPgfYBR1EhSTLBIJWqrarQz/k1K6tIzwSsrwFcaQN4
         OkUnjr5OCnCqiom3KzNu6LsZHC/zXSeMMTYTDnAQixvG5HFOFYr08FT57/caSkOSGluw
         5DlKy6G3q9khJU82fpcxq9Iwmvd42cukyKDoHHgwlHMljhQAkZAXY6/0uRg9sA+d2p2s
         mf5QxbnXZXPEcBLTYR3lyWc7uUmNqgK4lVdPVm5XP1vF38EC4bFwXoMhXWHrGt8TelEW
         +mcw==
X-Gm-Message-State: AOJu0YyGE164wmovU+wGRFJIhT3PXOV6g7aCd6LLDROP5hEGE+1uW/E1
	out7jpARtzmD797qJmTOkRAB9KaoIAnOHv/PV8VS0bYNNr/KAj4oAHCyGLdXG3uDwttrXmMDVm/
	QxvVxfK0z2UN5kbUDRcuMvfvMckRTrDVC
X-Google-Smtp-Source: AGHT+IGj5FCSyJK6hrCBRXwrOM2Lfk243bVZGgIr5JDDEP6itHzEICegAzgBQM1EdVMJ2Z/1bvqlG/2+okB20DnSqoo=
X-Received: by 2002:a05:690c:7092:b0:6dd:c474:9cd8 with SMTP id
 00721157ae682-6ddc4749d1cmr100006467b3.18.1726667843927; Wed, 18 Sep 2024
 06:57:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
In-Reply-To: <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Wed, 18 Sep 2024 08:57:12 -0500
Message-ID: <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Also, here are all the disks:

bill@bill-desk:~$ sudo blkid | sort
/dev/md1: UUID="8f645711-4d2b-42bf-877c-a8c993923a7c"
BLOCK_SIZE="4096" TYPE="ext4"
/dev/nvme0n1p1: UUID="291e31b9-fe93-4ca2-a55e-925bd52e22ce"
BLOCK_SIZE="4096" TYPE="ext4"
PARTUUID="4c04494c-aeae-4026-b619-319a47ea9b73"
/dev/nvme0n1p2: UUID="3D01-0380" BLOCK_SIZE="512" TYPE="vfat"
PARTUUID="a04ff739-1730-4a58-8831-77b32e6e8f97"
/dev/sda1: UUID="00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB="1f8a44fb-1f2d-602d-885b-0f8d0d993989" LABEL="bill-desk:1"
TYPE="linux_raid_member"
PARTUUID="8fcf7b2e-9f81-464c-bec4-12b6fa522098"
/dev/sdb1: UUID="00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB="b6c783f4-aadf-ab7a-e272-6885ac2b8165" LABEL="bill-desk:1"
TYPE="linux_raid_member"
PARTUUID="3bbdd3f0-65f2-4b73-8466-138416d715f7"
/dev/sdc1: UUID="00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB="5f32fb20-4db9-b554-1736-4d88d3de79b3" LABEL="bill-desk:1"
TYPE="linux_raid_member"
PARTUUID="a57f49a2-b490-4d7a-b2e4-ef1fd35b4fea"
/dev/sdd1: UUID="00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB="4204adc8-7a63-46c6-44ed-2959bbfcb92b" LABEL="bill-desk:1"
TYPE="linux_raid_member"
PARTUUID="10920175-cafa-4fa1-bd24-3eee1ceadaad"
/dev/sde1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="b22c0936-bec1-5431-b61f-c45452468eec" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="afa8f851-6dd8-4939-b0a0-8d4a941eb1cd"
/dev/sdf1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="dde8f226-617b-a075-0e4a-c08034067fc8" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="23fc5af9-a323-4dac-ba07-d71edfe8dc97"
/dev/sdg1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="42de9d6f-948d-537a-4176-c549534bd3c7" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="8c469209-3b5e-40d5-9b09-adbe701db0db"
/dev/sdh1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="56ca9b88-840c-c04e-cfed-c8a695804962" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="994e38fb-9bc7-4882-84d8-18e4eb7bb9ae"
/dev/sdi1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="9500b832-c47a-be89-adbf-f33493800ea9" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="0d2c9546-7204-4f82-8038-e42c06baeab3"
/dev/sdj1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="408f8551-5047-76ce-9066-9f13b2ab0de4" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="9c90f79f-d588-4c50-80d2-f9660ae03287"
/dev/sdk1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="c85fabbb-03da-1c1b-2362-35f9fe1e3da9" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="06177e2c-e030-418b-bae4-1d0243fce01d"
/dev/sdl1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="ffb9bedc-4cd0-f3ea-e5c7-e98467f8929d" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="fc41c31d-fd6e-4433-8373-4a7104b88b80"
/dev/sdm1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="9e3a942a-e9e8-0c16-648c-0d37000b04fe" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="414d1111-1f1d-4448-8c51-2a6f4c582b4f"
/dev/sdn1: UUID="8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB="7d7be15e-062c-df3b-cef5-a56ec0dee5fc" LABEL="bill-desk:2"
TYPE="linux_raid_member"
PARTUUID="dbb4786e-d396-41de-a5e0-51d48b3069e0"
/dev/sdo1: UUID="acabcdd0-80cd-4e5e-bf0c-f483ae58c0c2"
BLOCK_SIZE="4096" TYPE="ext4"
PARTUUID="f979fc82-a8c2-4a44-898c-8a5fb9b3d3af"

All the disks (sde-sdn) still seem to still be part of the correct
array, going by the UUID="8a32....."

Will the array mount properly if I do it manually?


> Thanks for the help.
> Bill
