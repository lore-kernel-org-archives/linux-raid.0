Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4687F224DF
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699918; cv=none; b=Z2pBEpvnBJj5LjAFLmpHpiQvOJVpk06b7/F0u8xkH/aj3Uddh7nU34AKzGA3+Ih/LEGMxua1dis/Ecj+vjUryqFzYbLwddoamU+eXcKjgzb2DvKmq1HZN4gLFg8cWJsCbRiXSgDykOqJdxp+fQ31MSpI67Tp+oOTqzuWCRiJj9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699918; c=relaxed/simple;
	bh=ryGOj6RgyT3Pa/X8F1kaML86zfcGxT3/C32d61cO96w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ixZVNUvDilfdJXN+bEE7Ss5aba+dm6UGRBElUZ2X2798DaJt6DsEqUdzBJ1icLExDPyB5MsVB/i9E/RDLyikupYVb2fmLGcEe3OBdohyrEPorZ8nto/1RgaLDxYaXfjanRWe7v0AIm9ueoM1yTAixL6i/53N33OM6mQNZ6wMA9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFrf0TWl; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFrf0TWl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699915; x=1740235915;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ryGOj6RgyT3Pa/X8F1kaML86zfcGxT3/C32d61cO96w=;
  b=jFrf0TWlC+wcl06GGGmevxoxNuM5sjDVugo5Vyo13ZHzeObpSWe5JCQE
   4v9cKawb9drFHbreukHJWB27pExVS617AEoToBTaBABm7L5TjExG1zvlF
   l6C8gKe6ZpL4YPtu1OkHOYMcTYhSzc8JVEBZutCHGY+SOZtljjCpKMKBn
   W6wMJijU9BRSqAQM+E+uD3kWbRzATT3g2sFEFo2I7W5nQIFQWqkbrN3By
   onkmWVj58T/w3ONz47UPoP2Mzjq1qXo6pq2SOOZc5KiSCZiUYke8nt4wo
   lr/kWj/ZXioSGPa40OZCnfqQwdHW3SJq8QOXFWhmac3FtoCsMdu7liJ/w
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454888"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454888"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:51:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495402"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:51:54 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 0/6] Repository cleanup
Date: Fri, 23 Feb 2024 15:51:40 +0100
Message-Id: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove legacy files and ANNOUNCEs. They can still be reverted on demand.
Create special documentation folder and move text files out from main
directory.

Mariusz Tkaczyk (6):
  mdadm: remove ANNOUNCEs
  mdadm: remove TODO
  mdadm: remove makedist
  mdadm: remove mdadm.spec
  mdadm: remove mkinitramfs stuff
  mdadm: move documentation to folder

 ANNOUNCE-3.0                                  |  98 --------
 ANNOUNCE-3.0.1                                |  22 --
 ANNOUNCE-3.0.2                                |  21 --
 ANNOUNCE-3.0.3                                |  29 ---
 ANNOUNCE-3.1                                  |  33 ---
 ANNOUNCE-3.1.1                                |  39 ----
 ANNOUNCE-3.1.2                                |  46 ----
 ANNOUNCE-3.1.3                                |  46 ----
 ANNOUNCE-3.1.4                                |  37 ---
 ANNOUNCE-3.1.5                                |  42 ----
 ANNOUNCE-3.2                                  |  77 -------
 ANNOUNCE-3.2.1                                |  75 ------
 ANNOUNCE-3.2.2                                |  36 ---
 ANNOUNCE-3.2.3                                |  24 --
 ANNOUNCE-3.2.4                                | 144 ------------
 ANNOUNCE-3.2.5                                |  31 ---
 ANNOUNCE-3.2.6                                |  57 -----
 ANNOUNCE-3.3                                  |  63 ------
 ANNOUNCE-3.3.1                                |  23 --
 ANNOUNCE-3.3.2                                |  16 --
 ANNOUNCE-3.3.3                                |  18 --
 ANNOUNCE-3.3.4                                |  37 ---
 ANNOUNCE-3.4                                  |  24 --
 ANNOUNCE-4.0                                  |  22 --
 ANNOUNCE-4.1                                  |  16 --
 ANNOUNCE-4.2                                  |  19 --
 README.initramfs                              | 122 ----------
 TODO                                          | 213 ------------------
 .../external-reshape-design.txt               |   0
 .../mdadm.conf-example                        |   0
 .../mdmon-design.txt                          |   0
 makedist                                      |  96 --------
 mdadm.spec                                    |  47 ----
 mkinitramfs                                   |  55 -----
 34 files changed, 1628 deletions(-)
 delete mode 100644 ANNOUNCE-3.0
 delete mode 100644 ANNOUNCE-3.0.1
 delete mode 100644 ANNOUNCE-3.0.2
 delete mode 100644 ANNOUNCE-3.0.3
 delete mode 100644 ANNOUNCE-3.1
 delete mode 100644 ANNOUNCE-3.1.1
 delete mode 100644 ANNOUNCE-3.1.2
 delete mode 100644 ANNOUNCE-3.1.3
 delete mode 100644 ANNOUNCE-3.1.4
 delete mode 100644 ANNOUNCE-3.1.5
 delete mode 100644 ANNOUNCE-3.2
 delete mode 100644 ANNOUNCE-3.2.1
 delete mode 100644 ANNOUNCE-3.2.2
 delete mode 100644 ANNOUNCE-3.2.3
 delete mode 100644 ANNOUNCE-3.2.4
 delete mode 100644 ANNOUNCE-3.2.5
 delete mode 100644 ANNOUNCE-3.2.6
 delete mode 100644 ANNOUNCE-3.3
 delete mode 100644 ANNOUNCE-3.3.1
 delete mode 100644 ANNOUNCE-3.3.2
 delete mode 100644 ANNOUNCE-3.3.3
 delete mode 100644 ANNOUNCE-3.3.4
 delete mode 100644 ANNOUNCE-3.4
 delete mode 100644 ANNOUNCE-4.0
 delete mode 100644 ANNOUNCE-4.1
 delete mode 100644 ANNOUNCE-4.2
 delete mode 100644 README.initramfs
 delete mode 100644 TODO
 rename external-reshape-design.txt => documentation/external-reshape-design.txt (100%)
 rename mdadm.conf-example => documentation/mdadm.conf-example (100%)
 rename mdmon-design.txt => documentation/mdmon-design.txt (100%)
 delete mode 100755 makedist
 delete mode 100644 mdadm.spec
 delete mode 100644 mkinitramfs

-- 
2.35.3

