Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7AEA937
	for <linux-raid@vger.kernel.org>; Tue,  3 Jun 2025 01:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748913127; cv=none; b=JPx2DZ0n+vUuBkw9uCeOwKacyM00ouD3ECVmZwHZ1X6on7+DYsAORXSCANEr7BCPLzoXjy5L4hzEXPay+En98qSflHAIVvwJ6kMZBBcuxn/DCftHp7mRrKYRdydlQn+/Ki3kwfV6Z14hQQas2y2LzpTrqYKUBiwwDAutQmYF1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748913127; c=relaxed/simple;
	bh=ScoRkzfWxwKPIKnrJDTp2bupEd2tmJxoop3VVwf7i34=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=koN1gC4YxX3x0HfWYh26xlutN/aGr4+FU3B4MvFb+v6hRXRRPyqX8Gz2oDp6BIOQh0lNPyrXinJLlzlrAY0UDw8cLvmKGrl0lSTBvfxLkbMsMs77m8GzN4uka+/0Pj02kOQKmvwymOj4/3BZLkHPWEXy0I8CHnY6jLlsRYt+XXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=bVFSaQ36; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="bVFSaQ36"
Received: (qmail 1615 invoked from network); 3 Jun 2025 01:04:05 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 3 Jun 2025 01:04:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:cc:subject:message-id:mime-version:content-type
	:content-transfer-encoding; s=2018; bh=ScoRkzfWxwKPIKnrJDTp2bupE
	d2tmJxoop3VVwf7i34=; b=bVFSaQ36BouCUAeeekcHjlQKJb63O/77YVOzKYN96
	M1ySS72ziPTulBP2dz258xNfunuu5eeCHr+XvEnkPvR9YOb23NMVunLoFlykSAlN
	M3GnrJDlkyNhJQSJ/hrzh+7DPUFkecUj/T9CS2DGJrEm7Tdrg4LSVoux57crXGkJ
	UY=
Received: (qmail 94987 invoked from network); 2 Jun 2025 20:05:22 -0500
Received: by simscan 1.4.0 ppid: 94928, pid: 94942, t: 0.9122s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 3 Jun 2025 01:05:21 -0000
Date: Mon, 2 Jun 2025 21:05:14 -0400
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Need help increasing raid scan efficiency.
Message-ID: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
X-Mailer: Claws Mail 4.3.0git38 (GTK 3.24.24; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,
My PC suffered a rather nasty case of HW failure recently where the MB
would break the CPU and RAM. I ended up with different data on different
members of my RAID6 array.

I wanted to scan through the drives and take some checksums of various
files in an attempt to ascertain which drives took the most data
corruption damage, to try and find the date that the damage started
occurring (as it was unclear when exactly this began), and to try and
rescue some of the data off of the good pairs.

So I setup the array into read-only mode and started the array with only
two of the drives. Drives 0 and 1. Then I proceeded to try and start a
second pair, drives 2 and 3, so that I could scan them simultaneously.
With the intent of then switching it over to 0 and 2 and 1 and 3, then 0
and 3 and 1 and 2.


This failed with the error message:
# mdadm --assemble -o --run /dev/md128 /dev/sdc /dev/sdd
mdadm: Found some drive for array that is already active: /dev/md127
mdadm: giving up.
# mdadm --detail /dev/md127
           Version : 1.2
     Creation Time : XXX
        Raid Level : raid6
        Array Size : XXX
     Used Dev Size : XXX
      Raid Devices : 4
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : XXX
             State : clean, degraded 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

              Name : XXX
              UUID : XXX
            Events : 3826931

    Number   Major   Minor   RaidDevice State
       7       9        0        0      active sync   /dev/md0
       -       0        0        1      removed
       -       0        0        2      removed
       6       9        1        3      active sync   /dev/md1



Any ideas as to how I can get mdadm to run the array as I requested
above? I did try --force, but mdadm refused to listen.

Thanks,
David
