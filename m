Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D649F13E8A5
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725282961; cv=none; b=J2dx7GVgCh5PNsU99YqbY8XS+JlMa0heZbQhx2vEpwpSBwA1o1WutRCByJj4w27Ugya+QGgEmzFay5Z7XuzwY1/Uu7IGreX4rRW+ZhhVsN17Eubp1EVTstyU5ICNdc1IyFCeFrBXrmLe+hXfwQQkSNr14ZJuWOLZ6F6AclamWqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725282961; c=relaxed/simple;
	bh=+GV9kw5e1OjfPkA5e7aWlV6Bmk3I1ggByPygtEUZa9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rwWXWHpIOyRaa/gOSRb64lU61F00jFnIjF3dCva8BJbvI3/K3PZL9v9WI8B79y0gBKCTq268KfYae13A1Slh6NrObYsKb/uH2rSpDJyVGr1vtSxF+Pns4bm9x5b2f67gNdWnUtc3SBBT3jU9t5Q97jTFNKeKJrfT7GBnC0FTsMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KFgVzJBP; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFgVzJBP"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2068acc8a4fso1242645ad.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Sep 2024 06:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725282959; x=1725887759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ehXjq5NRPRnO4MQi8kFxSzdNDsphhdKHMuJ+9jNUwKk=;
        b=KFgVzJBPT9Ah8jg6iKPtZsnWpJ8pk17qgH3bqEP/fZI/FGE6WSMTxMc0W/mKYiHBt2
         XraDJsv+F4J39IlTjdqBuRjeO/V9nQd+AU9YcxmG4P6R128QB5eWZ49xTMDDZwpzBeyX
         7f7TUb8ruFzVtXhdfYAAZ2CJu+8osTkH7ROmK0H5NlrBnadC8C1vhySQ+D4KpVKFU70s
         L1LlHBLwz9HeP0Wxwwm1Ri02+/h47rK9FqG2iI6c4lWUBkp8YkY1nL8qctHscncPHnYC
         bKYbRFV5NSBss8fmPLC+XylxyP9JR06RsgbzTuHL6tHllcnT52uBaCvqagcsLSY/IQQY
         y0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725282959; x=1725887759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehXjq5NRPRnO4MQi8kFxSzdNDsphhdKHMuJ+9jNUwKk=;
        b=Jcto/7rpxQce41xjNYRfvLRfyLe4wmzut/o5N6GF9MPRqYVtsvpFOeGm8rAvmTkBv6
         VR42cSUMOaGTuxq7aaEY+wCoWUTaXIGBVOd/pHl2AOJf2p6JxYy/jKhfDaUg3024ViwS
         bGUyv+ciSlMKErII3z6f4L7LRR6V1F9QI9nJi94vVFOi/TrpwHUMxvFDljKME2wdYoB+
         RUm5VgfGEtx4xM0uesyTTJKa3lruZIumd3VMDmRve+vWasv8skl8UVNtJ/EV+TqZRJe1
         k5WYtP9JOy7qeK54X3SYSSPObtSyR3fMnEZ4Pxt+iWx4237sWVFuhBa0CJdEWLqE4siU
         uvtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrJ7J2EwJDvWVmp++CWC/kDcPw775iH+i7ZGgRkwR0StUPqau27HnLD3WnIYGK1xB1T6CNDeM3bHvy@vger.kernel.org
X-Gm-Message-State: AOJu0YwJyCvfBXN9DQZYyjtaXB86IjnwLKOLloGkEHjjzZ7noo6n+79u
	wbEWUHmSJniIgxLZQlWI3FIMu65rBt9DmkaAcCt3ByO/cVv3FgTH
X-Google-Smtp-Source: AGHT+IG5ifBrc2IcirkbTG8BmfNiHd3KQeK99alKoix0pHRkyncmy0ragTZukgw0v3AI7RnGaz2xjQ==
X-Received: by 2002:a17:902:f647:b0:201:feb8:3444 with SMTP id d9443c01a7336-2050c2159f1mr130829615ad.2.1725282958854;
        Mon, 02 Sep 2024 06:15:58 -0700 (PDT)
Received: from [192.168.1.31] (ip68-231-38-120.ph.ph.cox.net. [68.231.38.120])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205812d8310sm12384935ad.51.2024.09.02.06.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2024 06:15:58 -0700 (PDT)
Message-ID: <ee66876c-c927-4387-b1a0-34d2db7212f6@gmail.com>
Date: Mon, 2 Sep 2024 06:15:57 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: What RAID Level is this? (found on Refurb drive out of package)
To: "David C. Rankin" <drankinatty@gmail.com>,
 mdraid <linux-raid@vger.kernel.org>
References: <e7956b07-f838-4282-b179-9883da259d9c@gmail.com>
Content-Language: en-US
From: Paul E Luse <paulluselinux@gmail.com>
In-Reply-To: <e7956b07-f838-4282-b179-9883da259d9c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/1/24 4:54 PM, David C. Rankin wrote:
> All,
> 
>    I had a rather curious event. I lost one drive in a 2-disk Raid1 
> array, so I removed and replaced the drive (/dev/sdd). However when I 
> went to --add the drive back to the array, I was greeted with:
> 
> # mdadm /dev/md4 -v --add /dev/sdd
> mdadm: Cannot open /dev/sdd: Device or resource busy
> 
>    I had just cut the plastic anti-static plastic off this drive right 
> out of the box (it was a HGST HUS724030AL 3T drive [refurb]) I bought 
> several years ago as a bandaid if one of the drives failed.
> 
>    lsof showed nothing, it obviously wasn't mounted anywhere, that the 
> heck is going on? So on a lark, I decided to see what mdadm was seeing 
> when it tried to add the disk, and got the surprise of the month (maybe 
> year):
> 
> # mdadm -E /dev/sdd
> /dev/sdd:
>            Magic : de11de11
>          Version : 01.00.00
> Controller GUID : 4C534920:20202020:53563334:31313633:34380000:20300000
>                    (LSI     SV34116348)
>   Container GUID : 4C534920:20202020:1000005B:10009270:411B88D1:6029330D
>                    (LSI      08/12/14 10:12:17)
>              Seq : 00000550
>    Redundant hdr : yes
>    Virtual Disks : 2
> 
>        VD GUID[0] : 4C534920:20202020:1000005B:10009270:411B88D1:BD45C505
>                    (LSI      08/12/14 10:12:17)
>           unit[0] : 0
>          state[0] : Optimal, Consistent
>     init state[0] : Not Initialised
>         access[0] : Read/Write
>           Name[0] :
>   Raid Devices[0] : 16 (15@0K 16@0K 17@0K 18@0K 19@0K 20@0K 21@0K 22@0K 
> 23@0K 24@0K 25@0K 26@0K 27@0K 28@0K 29@0K 30@0K)
>     Chunk Size[0] : 512 sectors
>     Raid Level[0] : RAID1E
>    Secondary Position[0] : 1 of 2
>    Secondary Level[0] : Striped
>    Device Size[0] : 4480000
>     Array Size[0] : 71680000
> 
>        VD GUID[1] : 4C534920:20202020:1000005B:10009270:411B88D6:ECDB16EF
>                    (LSI      08/12/14 10:12:22)
>           unit[1] : 1
>          state[1] : Optimal, Consistent
>     init state[1] : Not Initialised
>         access[1] : Read/Write
>           Name[1] :
>   Raid Devices[1] : 16 (15@4480000K 16@4480000K 17@4480000K 18@4480000K 
> 19@4480000K 20@4480000K 21@4480000K 22@4480000K 23@4480000K 24@4480000K 
> 25@4480000K 26@4480000K 27@4480000K 28@4480000K 29@4480000K 30@4480000K)
>     Chunk Size[1] : 512 sectors
>     Raid Level[1] : RAID1E
>    Secondary Position[1] : 1 of 2
>    Secondary Level[1] : Striped
>    Device Size[1] : 2925241344
>     Array Size[1] : 46803861504
> 
>   Physical Disks : 255
>        Number    RefNo      Size       Device      Type/State
>           0    0ad7585a  2929721344K                 active/Online
>           1    518d3f01  2929721344K                 active/Online
>           2    80062324  2929721344K                 active/Online
>           3    fcd9b45a  2929721344K                 active/Online
>           4    dee97a8f  2929721344K                 active/Online
>           5    37eeb412  2929721344K                 active/Online
>           6    67f7a94f  2929721344K                 active/Online
>           7    d4db0cc4  2929721344K                 active/Online
>           8    d93ab586  2929721344K                 active/Online
>           9    1c0c5d44  2929721344K                 active/Online
>          10    ab5862da  2929721344K                 active/Online
>          11    4ce04fdd  2929721344K                 active/Online
>          12    f87b19d5  2929721344K                 active/Online
>          13    9ed6a400  2929721344K                 active/Online
>          14    b158d61f  2929721344K                 active/Online
>          15    769312ca  2929721344K                 active/Online
>          16    2f3c43bc  2929721344K                 active/Online
>          17    0ecbdee0  2929721344K                 active/Online
>          18    875cf12d  2929721344K                 active/Online
>          19    9d862550  2929721344K                 active/Online
>          20    ba3eb4cc  2929721344K                 active/Online
>          21    3f82524e  2929721344K                 active/Online
>          22    b21ba5b3  2929721344K                 active/Online
>          23    f7cb675b  2929721344K /dev/sdd        active/Online
>          24    c8e6b3a6  2929721344K                 active/Online
>          25    8995cef6  2929721344K                 active/Online
>          26    dbe8f6ed  2929721344K                 active/Online
>          27    f581f610  2929721344K                 active/Online
>          28    d358c6bc  2929721344K                 active/Online
>          29    1e2b11eb  2929721344K                 active/Online
>          30    00533f3b  2929721344K                 active/Online
>          31    3ab5dd66  2929721344K                 active/Online
>          32    3767c1f2  1952972800K                 Global-Spare/Offline
> 
> 
>    Ahah! So this refurb had been part of a giant array (of some kind) in 
> apparently a Dell server before it was refurbed and one part of that 
> array had /dev/sdd mounted. So my guess is when mdadm scanned for drives 
> to assemble it found the superblock info on the new (refurbed) drive and 
> reserved (or somehow associated) /dev/sdd with one of this giant arrays 
> parts even though there is nothing related to it on this box.
> 
>    It must have been some huge 45-46T array made up of a lot of smaller 
> 3T drives that could be distributed around the network. I'd not seen a 
> setup like this before which looks like it had 32 drives in it??
> 
>    What type of array is this (level wise)?


It shows the RAID level above as 1E which is effectively RAID1 near 
layout as described here: 
https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm

-Paul


> 
>    After identifying the issue, I used wipefs to remove the existing 
> array info, rebooted, then --add went just fine and automatically 
> started the rebuild.
> 
>    (lesson: always check cheap refurbs for evidence from their prior 
> life -- or don't by refurbs at all, but... I'd rather have a refurb and 
> use it as a bandaid, than risk a remaining drive fail before the new 
> arrives...)
> 

