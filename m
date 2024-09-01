Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0FCF4EB
	for <linux-raid@vger.kernel.org>; Sun,  1 Sep 2024 23:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725234893; cv=none; b=uYgoRsrjDl9/mWxqFPmE0FwG9xYd8GInIBqcMmEjICXw8IGNZeKMYW0VSs4fgMx832razSfpcZ+Vw5qYfosNaKOW3UO0nNvQ8/0YW3TReJu2lbKp+TmFsgC/6yq7rn6WcJMefLGrklbPlaEgoRIBrqIqYUF5Mk8tA1KuSOCRXpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725234893; c=relaxed/simple;
	bh=j5KZvj8sR/UAP15LkyVdTuZogVK3p7+elCqETjQoGcc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=tUbxfiNGqruEPoDjZHl9zq8jYUImyvME+YWjmjz7v0J286J90jykEnpRuHKV27xiWaLTcF3vvFbIKJGCFpp5JrP13Lxnnkgv0b8/YguEx/em8rGzAtUhBfWuOAx+nUigqFGdnZ6Lz52r6w/zOO5rU7q4N50QIV40K5rvWEHBlrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdfPU4g7; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdfPU4g7"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5df96759e37so2511695eaf.2
        for <linux-raid@vger.kernel.org>; Sun, 01 Sep 2024 16:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725234891; x=1725839691; darn=vger.kernel.org;
        h=content-transfer-encoding:disposition-notification-to:subject:from
         :to:content-language:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zI3a7Gv+zdprTwGi/h5yWQeG+iYqU3f01fbHV9A0wJ4=;
        b=KdfPU4g7PRaOuGV1V0dxWWD622326ARArLp+0IgF1Se0rjuY+X7zbyJZUZdwxgIuwP
         FreEldjjcYxjgyShCIWqGV/6QU473CUUvQKMYFTEych0uOer0SA0Y09zsGGqUQjlGNXI
         o1AzXHgDVxYDs3bG23E8nr6YFA1+6WKi/O/66/9pmWnnWWJAvLEnnJ3MtqMQk1dz+JvM
         HMtx8mv0f4GJ4lc02HN/foSX+YmDzm3eB68hG7ZMZ1l0QLmPz3BHb8m5khdrse8Xjntn
         7UaEjOdM/dXqCOb1D9Ep436Em7Ym/8ugWKSwH/F51nAg969QB76OIOwcDWANpqbEQi/7
         GKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725234891; x=1725839691;
        h=content-transfer-encoding:disposition-notification-to:subject:from
         :to:content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zI3a7Gv+zdprTwGi/h5yWQeG+iYqU3f01fbHV9A0wJ4=;
        b=eVxrzkrQ6Y23g/FhquS7kHAx5lJzDziAGpYCFhWWPC4SMPjqiyoS5M6RLs5apf4DZd
         KCJ/LRbnNoToQ2ofa3nHtT6T3NDtJDQBUJB3GYHQ+pi2WDSoLhKx8l9fRTGNljMx4xLm
         G3faz+Gkm7sfkQ392uLTcYmD1xWBpktV7PX1SfKRFxgoYUzSAuKqfBcaE0RstwSqsKdL
         XNGSvWRMvVGUBVxqFnIealVsdoRtR9Rz6YjbQNFafieFv5zMJA8CDat3gbqdmnYl45T9
         IRylycak/vsxSI0MJnn8VSaiEeHJBR4GqyRL/z3qfd68a84OSVh3ydhpo35aczT6JulB
         T/Ow==
X-Gm-Message-State: AOJu0Yxrxeq+vLZyHgJV+Usy/PkcnNt3cjFGmTl1FAz32P0/ztoj6mNI
	0FDAT0vcfN6vQGwhUszpxNVNS/SKOp7bYgk/WcSUF00GoxkMjS6YUZFMzA==
X-Google-Smtp-Source: AGHT+IEtXJfypfR018N8EsmqUJCIdQMazrAWBZWBBRP1hJjqGOoyVBNZdl7nuT3j0MQF6kUOL5yAhw==
X-Received: by 2002:a05:6820:2707:b0:5d5:d7fc:955c with SMTP id 006d021491bc7-5dfacf88d18mr8292056eaf.5.1725234890764;
        Sun, 01 Sep 2024 16:54:50 -0700 (PDT)
Received: from [192.168.6.104] (mail.3111skyline.com. [66.76.46.195])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5dfa04bda37sm1516236eaf.21.2024.09.01.16.54.49
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Sep 2024 16:54:50 -0700 (PDT)
Message-ID: <e7956b07-f838-4282-b179-9883da259d9c@gmail.com>
Date: Sun, 1 Sep 2024 18:54:49 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: mdraid <linux-raid@vger.kernel.org>
From: "David C. Rankin" <drankinatty@gmail.com>
Subject: What RAID Level is this? (found on Refurb drive out of package)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

All,

   I had a rather curious event. I lost one drive in a 2-disk Raid1 array, so 
I removed and replaced the drive (/dev/sdd). However when I went to --add the 
drive back to the array, I was greeted with:

# mdadm /dev/md4 -v --add /dev/sdd
mdadm: Cannot open /dev/sdd: Device or resource busy

   I had just cut the plastic anti-static plastic off this drive right out of 
the box (it was a HGST HUS724030AL 3T drive [refurb]) I bought several years 
ago as a bandaid if one of the drives failed.

   lsof showed nothing, it obviously wasn't mounted anywhere, that the heck is 
going on? So on a lark, I decided to see what mdadm was seeing when it tried 
to add the disk, and got the surprise of the month (maybe year):

# mdadm -E /dev/sdd
/dev/sdd:
           Magic : de11de11
         Version : 01.00.00
Controller GUID : 4C534920:20202020:53563334:31313633:34380000:20300000
                   (LSI     SV34116348)
  Container GUID : 4C534920:20202020:1000005B:10009270:411B88D1:6029330D
                   (LSI      08/12/14 10:12:17)
             Seq : 00000550
   Redundant hdr : yes
   Virtual Disks : 2

       VD GUID[0] : 4C534920:20202020:1000005B:10009270:411B88D1:BD45C505
                   (LSI      08/12/14 10:12:17)
          unit[0] : 0
         state[0] : Optimal, Consistent
    init state[0] : Not Initialised
        access[0] : Read/Write
          Name[0] :
  Raid Devices[0] : 16 (15@0K 16@0K 17@0K 18@0K 19@0K 20@0K 21@0K 22@0K 23@0K 
24@0K 25@0K 26@0K 27@0K 28@0K 29@0K 30@0K)
    Chunk Size[0] : 512 sectors
    Raid Level[0] : RAID1E
   Secondary Position[0] : 1 of 2
   Secondary Level[0] : Striped
   Device Size[0] : 4480000
    Array Size[0] : 71680000

       VD GUID[1] : 4C534920:20202020:1000005B:10009270:411B88D6:ECDB16EF
                   (LSI      08/12/14 10:12:22)
          unit[1] : 1
         state[1] : Optimal, Consistent
    init state[1] : Not Initialised
        access[1] : Read/Write
          Name[1] :
  Raid Devices[1] : 16 (15@4480000K 16@4480000K 17@4480000K 18@4480000K 
19@4480000K 20@4480000K 21@4480000K 22@4480000K 23@4480000K 24@4480000K 
25@4480000K 26@4480000K 27@4480000K 28@4480000K 29@4480000K 30@4480000K)
    Chunk Size[1] : 512 sectors
    Raid Level[1] : RAID1E
   Secondary Position[1] : 1 of 2
   Secondary Level[1] : Striped
   Device Size[1] : 2925241344
    Array Size[1] : 46803861504

  Physical Disks : 255
       Number    RefNo      Size       Device      Type/State
          0    0ad7585a  2929721344K                 active/Online
          1    518d3f01  2929721344K                 active/Online
          2    80062324  2929721344K                 active/Online
          3    fcd9b45a  2929721344K                 active/Online
          4    dee97a8f  2929721344K                 active/Online
          5    37eeb412  2929721344K                 active/Online
          6    67f7a94f  2929721344K                 active/Online
          7    d4db0cc4  2929721344K                 active/Online
          8    d93ab586  2929721344K                 active/Online
          9    1c0c5d44  2929721344K                 active/Online
         10    ab5862da  2929721344K                 active/Online
         11    4ce04fdd  2929721344K                 active/Online
         12    f87b19d5  2929721344K                 active/Online
         13    9ed6a400  2929721344K                 active/Online
         14    b158d61f  2929721344K                 active/Online
         15    769312ca  2929721344K                 active/Online
         16    2f3c43bc  2929721344K                 active/Online
         17    0ecbdee0  2929721344K                 active/Online
         18    875cf12d  2929721344K                 active/Online
         19    9d862550  2929721344K                 active/Online
         20    ba3eb4cc  2929721344K                 active/Online
         21    3f82524e  2929721344K                 active/Online
         22    b21ba5b3  2929721344K                 active/Online
         23    f7cb675b  2929721344K /dev/sdd        active/Online
         24    c8e6b3a6  2929721344K                 active/Online
         25    8995cef6  2929721344K                 active/Online
         26    dbe8f6ed  2929721344K                 active/Online
         27    f581f610  2929721344K                 active/Online
         28    d358c6bc  2929721344K                 active/Online
         29    1e2b11eb  2929721344K                 active/Online
         30    00533f3b  2929721344K                 active/Online
         31    3ab5dd66  2929721344K                 active/Online
         32    3767c1f2  1952972800K                 Global-Spare/Offline


   Ahah! So this refurb had been part of a giant array (of some kind) in 
apparently a Dell server before it was refurbed and one part of that array had 
/dev/sdd mounted. So my guess is when mdadm scanned for drives to assemble it 
found the superblock info on the new (refurbed) drive and reserved (or somehow 
associated) /dev/sdd with one of this giant arrays parts even though there is 
nothing related to it on this box.

   It must have been some huge 45-46T array made up of a lot of smaller 3T 
drives that could be distributed around the network. I'd not seen a setup like 
this before which looks like it had 32 drives in it??

   What type of array is this (level wise)?

   After identifying the issue, I used wipefs to remove the existing array 
info, rebooted, then --add went just fine and automatically started the rebuild.

   (lesson: always check cheap refurbs for evidence from their prior life -- 
or don't by refurbs at all, but... I'd rather have a refurb and use it as a 
bandaid, than risk a remaining drive fail before the new arrives...)

-- 
David C. Rankin, J.D.,P.E.
