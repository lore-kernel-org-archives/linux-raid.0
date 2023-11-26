Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLvCC03z"
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBD8FD
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 02:18:53 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-548ce28fd23so4310521a12.3
        for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 02:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700993931; x=1701598731; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HWOrDPpkdgntuMOgmpOGOvMCwOcZ4IkBNIHoi9O1sAc=;
        b=fLvCC03z099K5TjY2BrCzCO//UnC68yRXYDbmPm6DOItVqGO2umOOIES2VGWrNVRB0
         fLZ15ru9UzyiMkHoJKYMusDaom62k14NdXNTOGDgAF9gYNXVKtt32KNcS7mOXyZd4MvR
         DveJB801PTgl+++bjgx+yGK+1iccKr6Lq4/zYlf0kHi66MB2JPVhphTzftQy7DSy2Qw/
         4rlW3wgVfILbZLE2G7/kJ9tX0lbfz5TXFTt19kGbbsHfkQlT4s7NZ1YMg9t98kbi44Rh
         Aq0XqO4g0S67KTqQE4Cfok6EXJLJXS6CKECDdeJ5R6w4izDmJN1x5PFPwblVxk6dEZ1b
         PzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700993931; x=1701598731;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HWOrDPpkdgntuMOgmpOGOvMCwOcZ4IkBNIHoi9O1sAc=;
        b=eKE7TdOTsWaIGTFgLiEMvYpAlpDRcWT5XJoioa45eFG6UY2fDz30qOHRpU/bObodN9
         NDDpLvNevx1GS8gpKBm6NrZuoImjQYAEnsx0eePhTuUAVqzJlKJ6B1fDwhHJTX8xRpHt
         5Tc2gjpPejkn1ytdJyTIXtDwWS0IATuUWZ1QE3A9yzUgBYZC/4sbb9roYiVgPwXxdrUU
         3NPXNJGt/M5Ho8kn1tfr520pwY49WZRnIllZsmz4ayBwCTzyVkm1fqtJiaiss+rTjWYD
         ZXRukqWjBdhmsZ9pOSXw4g1BuFQnx3+E63+V42HmrDV5J1ZGq3nCXgzsiZs+xtbtWihK
         u/Ig==
X-Gm-Message-State: AOJu0YwDdGVQi05CXUVypmZm6dRmfktjYYx6MarDs5qIydJElpPiH/NA
	td2dsqPr1WSDf20meO7BlphkY2ewDSeYAEwhoKQlenYEO1lLioeu
X-Google-Smtp-Source: AGHT+IHgc2h6K7KX2FtV5Bt/Nb0SkayxsU+YQTipEp3res8k/VuRt5To5QcirmHWiALJXpEWVj5gN/+8vDDP/BRwUhM=
X-Received: by 2002:a50:8a86:0:b0:547:b04:db3a with SMTP id
 j6-20020a508a86000000b005470b04db3amr6030830edj.21.1700993930910; Sun, 26 Nov
 2023 02:18:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Sun, 26 Nov 2023 11:18:39 +0100
Message-ID: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
Subject: SMR or SSD disks?
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi guys
i'm doing some maintenance replacing some not-yet-failed HDD with WD RED SSD.
I've read the warning on the homepage
https://raid.wiki.kernel.org/index.php/Linux_Raid

Are SSD drives still subject to SMR ? I've thought that it was related
only to magnetic drives not on SSD.

in example i have a WDC  WDS200T1R0A (WD RED SA500), is this subject
to SMR and I have to replace it anyway ? (i've added it to the raid
right now, moving from a 2 way mirror to a 3 way mirror)

If I have to replace them, which 2TB SSD should I use ? Usually i've
used Samsung SSD but i've read some bad reviews on newer models.

Any suggestions ? Ideas ?
