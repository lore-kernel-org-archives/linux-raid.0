Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFEC18C023
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726668508; cv=none; b=IeVGbFBFi1mfy4XrURoeke1vs0bhhLFf9uRiszcqlNR3ppU0cFQEEaizvjeTylrqcwU1r1WeVIs5MWIgC6SXxP0w0HbpCCYtHnZ0BlTMc56V8DX+fBenhNYRPntofLI7Y4rFe40pNbj8Y5kKGUkXeRHTsNx4rn+tzffXFW1/T6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726668508; c=relaxed/simple;
	bh=qGZXg7QYlAXVsKYPB5FiGzn+I449STAdxG7orHUIibw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X48Ti8Jxm9XaKnz/chUygad9sgCzIxPFBSM9UpNs3T9/GQQpdOdgrJNMI7zF/NWPzXBVCZNRHb/GRBBJ7Mw+h/sHnyZnMWIv/JIuqqDRwfyNDbwHMdC1nnq29FzO+ksjmJaoaZw8QKCYbk/xREns65lp3ASCzJrLii0Xx355RJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aafKvPC6; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aafKvPC6"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6dddca05a60so8018077b3.0
        for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 07:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726668505; x=1727273305; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9wIkYEhYvF0ja2WzrdNJIRyHA5BS6I/4v4z3BxdNgA=;
        b=aafKvPC6nyWbhQgQROp3zlL8TufBDqJVfkE58vqqYAzk8FEmiLahyaSEvEZ5Pa6FnM
         XZom9Xo9WgJkJPjAFKZMTi7zELn/bU0396PC/xFyXY6M6aSBwEWPN3kwcQ2V8o8i9e4n
         6vaEJXAcBm4cAqHHytEoA/6/KdvnvVQyGHKIubrGn+ez31W5opCMUEPDxVfAPEzGomjR
         bM6tgVCDPGQ+1063OszJ142E93pO6P5C3i20fG5QJaTeq9K50bCWrDte3DMCZ7X0L5JC
         N6BnbGVloA304daL06A3adAG87gedjs97YwBcXn28bQ3i9VQlV12XtxhlB5NKwbOtPdh
         izbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726668505; x=1727273305;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z9wIkYEhYvF0ja2WzrdNJIRyHA5BS6I/4v4z3BxdNgA=;
        b=GJjm0WHGQtaUqnyCFUYQbYco3uLHkX3lx9eDuyXXHDmxZso0tTugf8nJDWyxmiwZYc
         1b9GPiOh+oaiUFn1254jHyx15EPYzaDgu5iNdlpp/WwduDgwOPGeRy3wPNwIKDbLHE1t
         hsWiCN8p+bpuY3glN+m52pAGtSckQq2mohW+ttrKRdE7+DvBg08B1Q6w4GkcV4nXT/Yp
         55wPXecK5zHw7Zu1MRAuonSmVUcroUbZMPLzZlsFLFP68F6ANt7oPi9qC2ZvABbX3kNn
         QCoEzvfNVhQS+tMMg9GFQPXTl3MjGviFe6qPtj/8yCSNSxLAWIPFG60Xeg7i7xCduL1+
         0zOw==
X-Gm-Message-State: AOJu0YyR+HW4q+PIR0LU/cjTuSoa9CVvy73EOCRvyb6+rhIzfURwRht6
	1y6N31kZ0TVTgaL+xqsjnMW20OsJMcpWCzRbjMC3Px1oxV+67YxxggwklwiwwgmMWy4sb6FzlNa
	02NfrXccoP2FNjOh472cN7NCj5vHxCop6
X-Google-Smtp-Source: AGHT+IGwxIqLOt27MHpqfktT/B7BlFQLICCQEF9YR7u8TQSHoi3FLhK15yulw4sEcC9BdycEBhtvS8rFwzSYVR/MtuQ=
X-Received: by 2002:a05:690c:688c:b0:62f:60db:326 with SMTP id
 00721157ae682-6db95430797mr212370637b3.20.1726668504413; Wed, 18 Sep 2024
 07:08:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
In-Reply-To: <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Wed, 18 Sep 2024 09:08:13 -0500
Message-ID: <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

I tried to mount as read-only and got the following error:

bill@bill-desk:~$ sudo mount -o ro /dev/md127 /media/bill/ARRAY3
mount: /media/bill/ARRAY3: wrong fs type, bad option, bad superblock
on /dev/md127, missing codepage or helper program, or other error.

Superblock seems ok:

bill@bill-desk:~$ sudo mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Sat Nov 20 14:29:13 2021
        Raid Level : raid10
        Array Size : 46877236224 (43.66 TiB 48.00 TB)
     Used Dev Size : 15625745408 (14.55 TiB 16.00 TB)
      Raid Devices : 10
     Total Devices : 10
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sun Sep 15 21:54:43 2024
             State : clean, resyncing (PENDING)
    Active Devices : 10
   Working Devices : 10
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : bitmap

     Delta Devices : 4, (6->10)

              Name : bill-desk:2  (local to host bill-desk)
              UUID : 8a321996:5beb9c15:4c3fcf5b:6c8b6005
            Events : 77987

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync set-A   /dev/sde1
       1       8       81        1      active sync set-B   /dev/sdf1
       2       8       97        2      active sync set-A   /dev/sdg1
       3       8      113        3      active sync set-B   /dev/sdh1
       5       8      209        4      active sync set-A   /dev/sdn1
       4       8      193        5      active sync set-B   /dev/sdm1
       9       8      177        6      active sync set-A   /dev/sdl1
       8       8      161        7      active sync set-B   /dev/sdk1
       7       8      145        8      active sync set-A   /dev/sdj1
       6       8      129        9      active sync set-B   /dev/sdi1


I have noticed a lot of this type of stuff in dmesg, repeating every 5
minutes or so:

[ 1212.352770] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.353063] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.353077] mpt2sas_cm0:     sas_address(0x4433221104000000), phy(4)
[ 1212.353084] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(4)
[ 1212.353090] mpt2sas_cm0:     handle(0x0015),
ioc_status(success)(0x0000), smid(3886)
[ 1212.353096] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.353101] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.353105] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.353110] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.353248] sd 3:0:9:0: [sdj] tag#3886 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.353508] sd 3:0:9:0: [sdj] tag#3886 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.353514] mpt2sas_cm0:     sas_address(0x4433221109000000), phy(9)
[ 1212.353520] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(9)
[ 1212.353524] mpt2sas_cm0:     handle(0x001a),
ioc_status(success)(0x0000), smid(3887)
[ 1212.353530] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.353534] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.353538] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.353543] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.353603] sd 3:0:10:0: [sdk] tag#3887 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.353766] sd 3:0:10:0: [sdk] tag#3887 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.353772] mpt2sas_cm0:     sas_address(0x443322110a000000), phy(10)
[ 1212.353777] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(10)
[ 1212.353781] mpt2sas_cm0:     handle(0x001b),
ioc_status(success)(0x0000), smid(3888)
[ 1212.353786] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.353790] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.353794] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.353799] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.353874] sd 3:0:11:0: [sdl] tag#3888 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.354132] sd 3:0:11:0: [sdl] tag#3888 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.354138] mpt2sas_cm0:     sas_address(0x443322110b000000), phy(11)
[ 1212.354143] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(11)
[ 1212.354148] mpt2sas_cm0:     handle(0x001c),
ioc_status(success)(0x0000), smid(3889)
[ 1212.354153] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.354157] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.354161] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.354166] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.354226] sd 3:0:3:0: [sdd] tag#3889 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.354418] sd 3:0:3:0: [sdd] tag#3889 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.354423] mpt2sas_cm0:     sas_address(0x4433221103000000), phy(3)
[ 1212.354428] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(3)
[ 1212.354432] mpt2sas_cm0:     handle(0x0014),
ioc_status(success)(0x0000), smid(3890)
[ 1212.354437] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.354441] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.354445] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.354450] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.354510] sd 3:0:6:0: [sdg] tag#3890 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.354780] sd 3:0:6:0: [sdg] tag#3890 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.354786] mpt2sas_cm0:     sas_address(0x4433221106000000), phy(6)
[ 1212.354791] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(6)
[ 1212.354795] mpt2sas_cm0:     handle(0x0017),
ioc_status(success)(0x0000), smid(3891)
[ 1212.354800] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.354804] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.354808] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.354812] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.354908] sd 3:0:13:0: [sdn] tag#3891 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.355181] sd 3:0:13:0: [sdn] tag#3891 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.355189] mpt2sas_cm0:     sas_address(0x443322110d000000), phy(13)
[ 1212.355197] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(13)
[ 1212.355203] mpt2sas_cm0:     handle(0x001e),
ioc_status(success)(0x0000), smid(3892)
[ 1212.355210] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.355214] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.355218] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.355223] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.355293] sd 3:0:12:0: [sdm] tag#3892 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.355476] sd 3:0:12:0: [sdm] tag#3892 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.355482] mpt2sas_cm0:     sas_address(0x443322110c000000), phy(12)
[ 1212.355487] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(12)
[ 1212.355491] mpt2sas_cm0:     handle(0x001d),
ioc_status(success)(0x0000), smid(3893)
[ 1212.355497] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.355501] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.355505] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.355509] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.355573] sd 3:0:1:0: [sdb] tag#3893 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.355768] sd 3:0:1:0: [sdb] tag#3893 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.355775] mpt2sas_cm0:     sas_address(0x4433221101000000), phy(1)
[ 1212.355781] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(1)
[ 1212.355786] mpt2sas_cm0:     handle(0x0012),
ioc_status(success)(0x0000), smid(3894)
[ 1212.355793] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.355798] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.355803] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.355809] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.355928] sd 3:0:0:0: [sda] tag#3894 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356135] sd 3:0:0:0: [sda] tag#3894 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356142] mpt2sas_cm0:     sas_address(0x4433221100000000), phy(0)
[ 1212.356147] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(0)
[ 1212.356152] mpt2sas_cm0:     handle(0x0011),
ioc_status(success)(0x0000), smid(3895)
[ 1212.356157] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.356161] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.356165] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.356170] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.356250] sd 3:0:5:0: [sdf] tag#3895 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356428] sd 3:0:5:0: [sdf] tag#3895 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356434] mpt2sas_cm0:     sas_address(0x4433221105000000), phy(5)
[ 1212.356439] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(5)
[ 1212.356443] mpt2sas_cm0:     handle(0x0016),
ioc_status(success)(0x0000), smid(3896)
[ 1212.356448] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.356452] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.356456] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.356461] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.356521] sd 3:0:7:0: [sdh] tag#3896 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356700] sd 3:0:7:0: [sdh] tag#3896 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356706] mpt2sas_cm0:     sas_address(0x4433221107000000), phy(7)
[ 1212.356710] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(7)
[ 1212.356715] mpt2sas_cm0:     handle(0x0018),
ioc_status(success)(0x0000), smid(3897)
[ 1212.356719] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.356723] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.356727] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.356732] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.356790] sd 3:0:8:0: [sdi] tag#3897 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356954] sd 3:0:8:0: [sdi] tag#3897 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.356961] mpt2sas_cm0:     sas_address(0x4433221108000000), phy(8)
[ 1212.356966] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(8)
[ 1212.356970] mpt2sas_cm0:     handle(0x0019),
ioc_status(success)(0x0000), smid(3898)
[ 1212.356975] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.356979] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.356990] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.356995] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1212.363633] sd 3:0:2:0: [sdc] tag#3898 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.363837] sd 3:0:2:0: [sdc] tag#3898 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1212.363842] mpt2sas_cm0:     sas_address(0x4433221102000000), phy(2)
[ 1212.363846] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(2)
[ 1212.363850] mpt2sas_cm0:     handle(0x0013),
ioc_status(success)(0x0000), smid(3899)
[ 1212.363854] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
[ 1212.363857] mpt2sas_cm0:     tag(0), transfer_count(0),
sc->result(0x00000002)
[ 1212.363860] mpt2sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[ 1212.363863] mpt2sas_cm0:     [sense_key,asc,ascq]:
[0x01,0x00,0x1d], count(22)
[ 1516.488470] sd 3:0:4:0: [sde] tag#3899 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 00 00 00 00 08 00 00
[ 1516.488717] sd 3:0:4:0: [sde] tag#3900 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 20 00 00 00 08 00 00
[ 1516.488851] sd 3:0:4:0: [sde] tag#3901 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 40 00 00 00 08 00 00
[ 1516.488967] sd 3:0:4:0: [sde] tag#3902 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 80 00 00 00 08 00 00
[ 1516.489080] sd 3:0:4:0: [sde] tag#3903 CDB: Read(16) 88 00 00 00 00
00 00 04 0d 00 00 00 00 08 00 00
[ 1516.489190] sd 3:0:4:0: [sde] tag#3840 CDB: Read(16) 88 00 00 00 00
00 00 04 0e 00 00 00 00 08 00 00
[ 1516.489300] sd 3:0:6:0: [sdg] tag#3841 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 00 00 00 00 08 00 00
[ 1516.489673] sd 3:0:13:0: [sdn] tag#3842 CDB: Read(16) 88 00 00 00
00 00 00 04 0c 00 00 00 00 08 00 00
[ 1516.489916] sd 3:0:9:0: [sdj] tag#3843 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 00 00 00 00 08 00 00
[ 1516.490136] sd 3:0:11:0: [sdl] tag#3844 CDB: Read(16) 88 00 00 00
00 00 00 04 10 00 00 00 00 08 00 00
[ 1516.490379] sd 3:0:13:0: [sdn] tag#3845 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 80 00 00 00 08 00 00
[ 1516.490531] sd 3:0:13:0: [sdn] tag#3846 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 f0 00 00 00 08 00 00
[ 1516.490660] sd 3:0:4:0: [sde] tag#3847 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 08 00 00 00 08 00 00
[ 1516.700168] sd 3:0:13:0: [sdn] tag#3848 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 f8 00 00 00 08 00 00
[ 1516.700550] sd 3:0:13:0: [sdn] tag#3849 CDB: Read(16) 88 00 00 00
00 07 46 bf f2 f8 00 00 00 08 00 00
[ 1516.700871] sd 3:0:13:0: [sdn] tag#3850 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 c0 00 00 00 08 00 00
[ 1516.701160] sd 3:0:13:0: [sdn] tag#3851 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 00 00 00 00 08 00 00
[ 1516.701454] sd 3:0:13:0: [sdn] tag#3852 CDB: Read(16) 88 00 00 00
00 07 46 bf f2 70 00 00 00 08 00 00
[ 1516.701728] sd 3:0:13:0: [sdn] tag#3853 CDB: Read(16) 88 00 00 00
00 07 46 bf f1 b0 00 00 00 08 00 00
[ 1516.701992] sd 3:0:13:0: [sdn] tag#3854 CDB: Read(16) 88 00 00 00
00 07 46 bf f1 58 00 00 00 08 00 00
[ 1516.702256] sd 3:0:13:0: [sdn] tag#3855 CDB: Read(16) 88 00 00 00
00 07 46 bf f1 20 00 00 00 08 00 00
[ 1516.702533] sd 3:0:13:0: [sdn] tag#3856 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 70 00 00 00 08 00 00
[ 1516.702805] sd 3:0:13:0: [sdn] tag#3857 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 30 00 00 00 08 00 00
[ 1516.703081] sd 3:0:13:0: [sdn] tag#3858 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 20 00 00 00 08 00 00
[ 1516.703387] sd 3:0:13:0: [sdn] tag#3859 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 48 00 00 00 08 00 00
[ 1516.703829] sd 3:0:13:0: [sdn] tag#3860 CDB: Read(16) 88 00 00 00
00 07 46 bf ef f0 00 00 00 08 00 00
[ 1516.704141] sd 3:0:4:0: [sde] tag#3861 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 18 00 00 00 08 00 00
[ 1516.704696] sd 3:0:4:0: [sde] tag#3862 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 38 00 00 00 08 00 00
[ 1516.704967] sd 3:0:4:0: [sde] tag#3863 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 78 00 00 00 08 00 00
[ 1516.705265] sd 3:0:4:0: [sde] tag#3864 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 10 00 00 00 08 00 00
[ 1516.705290] sd 3:0:4:0: [sde] tag#3865 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 28 00 00 00 10 00 00
[ 1516.705312] sd 3:0:4:0: [sde] tag#3866 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 48 00 00 00 30 00 00
[ 1516.705367] sd 3:0:4:0: [sde] tag#3867 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 88 00 00 00 78 00 00
[ 1516.705441] sd 3:0:4:0: [sde] tag#3868 CDB: Read(16) 88 00 00 00 00
00 00 04 0d 08 00 00 00 f8 00 00
[ 1516.706393] sd 3:0:4:0: [sde] tag#3869 CDB: Read(16) 88 00 00 00 00
00 00 04 0e 08 00 00 01 f8 00 00
[ 1516.707457] sd 3:0:13:0: [sdn] tag#3870 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 00 00 00 00 20 00 00
[ 1516.707470] sd 3:0:13:0: [sdn] tag#3871 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 28 00 00 00 08 00 00
[ 1516.707481] sd 3:0:13:0: [sdn] tag#3872 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 38 00 00 00 10 00 00
[ 1516.707494] sd 3:0:13:0: [sdn] tag#3873 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 50 00 00 00 20 00 00
[ 1516.707526] sd 3:0:13:0: [sdn] tag#3874 CDB: Read(16) 88 00 00 00
00 07 46 bf f0 78 00 00 00 a8 00 00
[ 1516.707545] sd 3:0:13:0: [sdn] tag#3875 CDB: Read(16) 88 00 00 00
00 07 46 bf f1 28 00 00 00 30 00 00
[ 1516.707566] sd 3:0:13:0: [sdn] tag#3876 CDB: Read(16) 88 00 00 00
00 07 46 bf f1 60 00 00 00 50 00 00
[ 1516.707604] sd 3:0:13:0: [sdn] tag#3877 CDB: Read(16) 88 00 00 00
00 07 46 bf f1 b8 00 00 00 48 00 00
[ 1516.708573] sd 3:0:13:0: [sdn] tag#3878 CDB: Read(16) 88 00 00 00
00 07 46 bf f2 00 00 00 00 70 00 00
[ 1516.708600] sd 3:0:13:0: [sdn] tag#3879 CDB: Read(16) 88 00 00 00
00 07 46 bf f2 78 00 00 00 80 00 00
[ 1516.708630] sd 3:0:13:0: [sdn] tag#3880 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 08 00 00 00 78 00 00
[ 1516.708646] sd 3:0:13:0: [sdn] tag#3881 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 88 00 00 00 38 00 00
[ 1516.708662] sd 3:0:13:0: [sdn] tag#3882 CDB: Read(16) 88 00 00 00
00 07 46 bf f3 c8 00 00 00 28 00 00
[ 1516.709944] sd 3:0:4:0: [sde] tag#3883 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 02 00 00 00 02 00 00
[ 1516.711635] sd 3:0:4:0: [sde] tag#3884 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 02 00 00 00 02 00 00
[ 1516.712008] sd 3:0:4:0: [sde] tag#3885 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 02 00 00 00 02 00 00
[ 1516.712294] sd 3:0:4:0: [sde] tag#3886 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 00 00 00 00 02 00 00
[ 1516.712574] sd 3:0:4:0: [sde] tag#3887 CDB: Read(16) 88 00 00 00 00
00 00 04 0c 00 00 00 00 01 00 00

I just don't know what else to do here.
