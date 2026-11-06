Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793990238;
	b=CFHpnM2EjqtLid7KyN64++PMsc0l7DHTE6XtsB70Kgeodcyculga4O618K8buCafMZFz
	 SMSKjiqCeyxqqlECcRODwQNb0eklzw9NfWjOZCqW8HE1BnRocmpiKH6lNtou8Mlf3J1Wx
	 GnnX8F5oTCr3uOJfQYlLMyGE6QBSJ/UU/wNjMvhCoTFCiy/86I+S/c6IOU/Swf+gsCDLA
	 XWn7/z2+Qav1bW4PdQmG9envH3Q2s4LZL1YJ14GrWaDK7C61mnEVJ35vR5IqoIM9TCRBp
	 DaBUl+MQvqg/E2n402d6P9SF7lLu7yvJZf1wrQo5KLxmVm5aOteU6zM6IowXMWcmfyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=dfDUN0ad8B4jnlz/RVvbv7CkYzR44LqxJQpHnl4Yiok=;
	b=M7x97VUxgpPaLMWcztFr08BXjbAwKD5ZEhe21Bgkl7LtII+kIXcLaP6gi3NTlIY7tFAz
	 0ecIJ/7vuBSHTEaddyC95+5SG6SWWLEgTA07NZ9GAQDQzR5NvCtAYxT+jjbihGE8ZBtTS
	 EwP7xFpFzLn4yN6W0cR5ZimyiZQ5NBzMPdk7EMKPgKPqRonBdjg7S2XvZAxLrzOFMmfw3
	 SKr/BuLUXwqRwKGd5WisJ1kj6MvH9c6MFelo8emo2rVjVJP4VuTiEbPTAHiakOh1PYNdL
	 mDJ0fbXhQnADz3N264ttkbyUtTtuCecjxWlBK33mbw/d5FPEoYBFPTYwOTTNo2JMvNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LR2hxIOg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE6606A331
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 18:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60CE6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LR2hxIOg
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so1266240a12.2
        for <linux-raid@vger.kernel.org>; Fri, 06 Nov 2026 10:37:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793990237; cv=none;
        d=google.com; s=arc-20260327;
        b=iIydELnG7ql58Jror0uhyHY0sWkcDamJrcdJSpNWq6QdczQCTYp2ixxI2QvGnr9PHe
         puUPtZz3CQ1G6gdurEK93W6gPANfYoyqAMHuZSnmI/+5ghh7XsUVr9xScIQNojJqs7cj
         C2E7swuhSUlFHPHwFVJT7EuZUsASa7rRDAAfv5cx+QYvGW04onI1wfwwevsJ0jnWL9RY
         J09qYwFjUQkpPK/I/cTjyS0nI+uKmmlWc+rbe17j9bbNFWr4fZz7vhUMrdY2tLtXqDVY
         bLu+uHJ379v/XURER6RiFowS1nsWlVSGoPb5igmhcArkVkHL1xcf2tE9is723lAjDbNR
         cjPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=dfDUN0ad8B4jnlz/RVvbv7CkYzR44LqxJQpHnl4Yiok=;
        fh=X3wQ2D3DBAZuXswHTOsYFcAief3bMBJ7HKWbj/5u/jo=;
        b=C57IPhEsK5n8Afh2A0w9StYgggNNl32bVXMv9M/rjqi0eDg5OuQPdb/gldpmrxuSXK
         qmSB7G05XJGz3tw8WdNPWsnahYVZZun3ob0oFoCnZqQQecJ6gPlW3zIHkiZEf8uVlKGg
         fTNPCw8vf5dU7UqadUMX+6q4DwM7/50vSrsoYFXN5ij6QTYhjKQT+sH0MTLSXHkyTvT6
         tZaEqNzNY+7dFk/jse5imwR75OaJ0PYRGKfhRDaqhAZ2z3Th5nI86uDMuZLa69eoPxTV
         vTJaaOxJgPFtZcOz6Si4yfKbQuJRRh54qYJhW7hyg3lyfyjqsbWIZ3mMqfd8SVCDRDlv
         LvxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793990237; x=1794595037; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=dfDUN0ad8B4jnlz/RVvbv7CkYzR44LqxJQpHnl4Yiok=;
        b=LR2hxIOgA6IMtdBIEJjr+vNRnfQCzTwUxv2A57q+2+3M3kZg4cu/FkjaYF07L+Mj6y
         RmGFQENuvhl54v4JLOZ2pIzUblrxtT56bmmRbuj+5rzZGTC0kRydv2X25KBSdca9uiMW
         LW8qdRQcOYYuk9/vBlNE1fHPoLzmiKhGcpRCnLu6keyDdGn1YQK/jHIXS1T8raONlcgD
         P9G0UJY7oH4bvWx0NnepvAfciqT491j0GxWhFQvUjlEYkbAVOnVVDFPr1v7I0LUUmVUv
         xT9A0XV2ZzZLcyMX+lVX2o8ceChE/lyIuCdKg5ve5o4j5+iDuM2etNd7Sc2DNeZEsWpT
         JDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793990237; x=1794595037;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dfDUN0ad8B4jnlz/RVvbv7CkYzR44LqxJQpHnl4Yiok=;
        b=mGq7WwDuZf/m3vwYd8+y3P+FS8d0y9MKhkL6yFKXta9ftvPdCSBQI1YLUlp643+Aoh
         0yZa5ioXADUqyGdvX3r9Rbj3qjD1nyZElk3PWHVCOkvls6AqXHn4Jv8CZRvKw+dSXHzs
         e2OgH/sfebDcjernk0A4T+UglL1pAYDNftnOSFfGIacSnNeCDWzj7qwNgOx+H6nnShK2
         iTgskRJIwk+AjKw1n78g2iV52xIkSP6LGIb9Bc32XnJrw2sOYof6Nwg5777PyVxkzgfS
         /bU9M/5Mb4sLC2R9frydntRfVFrtp5eKmeYCH9yMUKkjOgUq/QnJNlf4MPAWmm/YGdEp
         UH7w==
X-Gm-Message-State: APuU4Z/7xO79ltB9sysPsNHsUXpufZ5ifQV0uIFKFp83hxuOEAQHrrne
	FRnwSaRbY/8QOC58F05oz409QVM3aWybQ2YKNOLvrfnMAR1ySErEylB8W46TRMB0CjXcE+QGMND
	gPMidXNID1VRQ+FX3aLO1Yb2lv4c+I/AWuFRJ
X-Gm-Gg: AYBFou37aCjw+z3u4V0AhgJAIESQKmE9mL2fcD/s5Bzgfh8lyoyWhP5DoX20a8mLB1V
	CfiURZrO9j7S5zUGCyzJR6tkykGxS7wNfXdEtyjxI3ny0FwIjPQOTtOAybZNitqpQiVh1WjrFjy
	jjOwnwLeV8or8g9qcnaJi1iIm4XFEBbQXgMoPSvIeqANwdhVD9MBLFo3fpoZ4RXjRED/Dtf+NIE
	W2mxnp4/IF957Kfn3CzjnTN2enzNf3nH9zoFhNnMF3iLdWs3KThMljdjpCY70wdSk9EUQjM2jFb
	/gGyg8jrIiyMZcuqc4XUfb5M5fucYXLBIQLJk6HvE1PFBHBeP3wk/KLs1lVctup1eQBJ0FjhkvX
	zwZLBu+E5oEYIwPuBByOBDwa+pgMSF0McQQHZSg==
X-Received: by 2002:a05:6402:2748:b0:6b6:e905:b045 with SMTP id
 4fb4d7f45d1cf-6b6e905b211mr1500578a12.3.1793990236662; Fri, 06 Nov 2026
 10:37:16 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 6 Nov 2026 20:37:05 +0200
X-Gm-Features: AclHuK9CGX1OobGNptnlxTW6K3mOutSc4ZR5PoireUJDdezWjOmLNh7ehkSmvWc
Message-ID: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
Subject: xor_gen() md-raid6 performance improvement
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello

I would like to share xor_gen performance improvement for md-raid6 write.
Box - AMD Zen5 9455, 6 x PCIe 5.0 NVMe SSD CM7-V in raid6 (4+2),
Fedora Server 45.


[root@memverge3 ~]# uname -r
7.2.15-300.fc45.x86_64
[root@memverge3 ~]# dmesg | grep -i xor
[    0.471277] xor: automatically using best checksumming function   avx
[root@memverge3 ~]# fio --name=test --rw=write --bs=2048k
--filename=/dev/md111 --direct=1 --numjobs=1 --iodepth=64 --exitall
--group_reporting --ioengine=io_uring --runtime=600 --time_based=1
test: (g=0): rw=write, bs=(R) 2048KiB-2048KiB, (W) 2048KiB-2048KiB,
(T) 2048KiB-2048KiB, ioengine=io_uring, iodepth=64
fio-3.43-31-gbfffd
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][w=4712MiB/s][w=2356 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=2351: Fri Nov  6 15:49:05 2026
  write: IOPS=2323, BW=4647MiB/s (4873MB/s)(2723GiB/600026msec)
    slat (usec): min=5, max=3469, avg=26.01, stdev=17.20
    clat (usec): min=2953, max=69868, avg=27516.08, stdev=3473.78
     lat (usec): min=2963, max=69930, avg=27542.09, stdev=3474.01


[root@memverge3 ~]# uname -r
7.4.0-rc1
[root@memverge3 ~]# dmesg | grep -i xor
[    0.553181] xor: automatically using best checksumming function   avx512
[root@memverge3 ~]# fio --name=test --rw=write --bs=2048k
--filename=/dev/md111 --direct=1 --numjobs=1 --iodepth=64 --exitall
--group_reporting --ioengine=io_uring --runtime=600 --time_based=1
test: (g=0): rw=write, bs=(R) 2048KiB-2048KiB, (W) 2048KiB-2048KiB,
(T) 2048KiB-2048KiB, ioengine=io_uring, iodepth=64
fio-3.43-31-gbfffd
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][w=7438MiB/s][w=3719 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=4837: Fri Nov  6 17:02:31 2026
  write: IOPS=3791, BW=7582MiB/s (7951MB/s)(4443GiB/600013msec)
    slat (usec): min=8, max=3073, avg=35.39, stdev=14.87
    clat (usec): min=2334, max=44420, avg=16845.30, stdev=3951.02
     lat (usec): min=2375, max=44455, avg=16880.69, stdev=3955.63


Nice results, but further improvements required to fully unlock PCI
5.0 drives potential.
