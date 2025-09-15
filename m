Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5E3207A38
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907829; cv=none; b=mfhaUIsAmqJffpPzoBuPmXu0ulq1THwafJWhHWfWZ+CQKF7U/qWc8IF4dDTizZkDxeD6dWpy8s5V5X0/lhziCPoT8e9DtHz5Pe7fBFRTentQzqQUlUv5YnsOG/ivanHz88ruTV+E4rIezzySC1+8hJKrBzjMCkLV452VjLLwu74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907829; c=relaxed/simple;
	bh=o0Rd8ZJtLex7FiYuILGq5adkG8zzAY0wbNpBkBldQ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QPAqw6SL2xdekl6iFpO9lb7bAFzg12ZBiN9XfzGvb/8lSYH5RPUKeU+1NYNc+yTY4Ecdy1Qh2yhQis9r9+rwOwRDKlwGkO2cLsFKJdzqe4rUISmgIWoPbvBLTZs3ALR02GoUn6jyItnWyv8/3H3jYeG3p6wFPaLNyDDlk4W2EMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=sCGGOSax; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="sCGGOSax"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZh004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:10 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=dNMr8Y+863HpIUIHCZHjh4DHeN8AyCy4E4P46xtDhxM=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907790; v=1;
        b=sCGGOSaxu1+J9ZIz6Xj6yxf2tVKIxEnRYCvpZrk+dFJQTP8+NGvb1qvBpBDwg7qJ
         E72lucBkOxZ3/Wi8N3fBJ+mnwPUuqWuZ88Ego/1iTzGsTSBtDgIHSXmEma4+xW2Q
         MESAtYOJqCm2R2haFLJf4iJknZAUiT4Ny3aTUHpcDyi55f8Yay8b+mTEl22/zxy5
         IdbKp20yXwK2S8u/uyQqvaMOfAcvHnjH7/J7E/AqAIflsK3i1ZOwbmCA3BI8pTqS
         lNbpm5otb9Q8zwc6C2hPN7KX3QaZyerC2dnqhgajMO5GxrIhpBHTclbXOXULipVi
         bOZQIVYFbNQrmWiU9ZxNDA==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 0/9] Don't set MD_BROKEN on failfast bio failure
Date: Mon, 15 Sep 2025 12:42:01 +0900
Message-ID: <20250915034210.8533-1-k@mgml.me>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes from V3:
- The error handling in md_error() is now serialized, and a new helper
  function, md_bio_failure_error, has been introduced.
- MD_FAILFAST bio failures are now processed by md_bio_failure_error
  instead of signaling via FailfastIOFailure.
- RAID10: Fix missing reschedule of failfast read bio failure
- Regardless of failfast, in narrow_write_error, writes that succeed
  in retry are returned to the higher layer as success
Changes from V2:
- Fix to prevent the array from being marked broken for all
  Failfast IOs, not just metadata.
- Reflecting the review, update raid{1,10}_error to clear
  FailfastIOFailure so that devices are properly marked Faulty.
Changes from V1:
- Avoid setting MD_BROKEN instead of clearing it
- Add pr_crit() when setting MD_BROKEN
- Fix the message may shown after all rdevs failure:
  "Operation continuing on 0 devices"

v3: https://lore.kernel.org/linux-raid/20250828163216.4225-1-k@mgml.me/
v2: https://lore.kernel.org/linux-raid/20250817172710.4892-1-k@mgml.me/
v1: https://lore.kernel.org/linux-raid/20250812090119.153697-1-k@mgml.me/

When multiple MD_FAILFAST bios fail simultaneously on Failfast-enabled
rdevs in RAID1/RAID10, the following issues can occur:
* MD_BROKEN is set and the array halts, even though this should not occur
  under the intended Failfast design.
* Writes retried through narrow_write_error succeed, but the I/O is still
  reported as BLK_STS_IOERR
* RAID10 only: If a Failfast read I/O fails, it is not retried on any
  remaining rdev, and as a result, the upper layer receives an I/O error.

Simultaneous bio failures across multiple rdevs are uncommon; however,
rdevs serviced via nvme-tcp can still experience them due to something as
simple as an Ethernet fault. The issue can be reproduced using the
following steps.

# prepare nvmet/nvme-tcp and md array #
sh-5.2# cat << 'EOF' > loopback-nvme.sh
set -eu
nqn="nqn.2025-08.io.example:nvmet-test-$1"
back=$2
cd /sys/kernel/config/nvmet/
mkdir subsystems/$nqn
echo 1 > subsystems/${nqn}/attr_allow_any_host
mkdir subsystems/${nqn}/namespaces/1
echo -n ${back} > subsystems/${nqn}/namespaces/1/device_path
echo 1 > subsystems/${nqn}/namespaces/1/enable
ports="ports/1"
if [ ! -d $ports ]; then
        mkdir $ports
        cd $ports
        echo 127.0.0.1 > addr_traddr
        echo tcp       > addr_trtype
        echo 4420      > addr_trsvcid
        echo ipv4      > addr_adrfam
        cd ../../
fi
ln -s /sys/kernel/config/nvmet/subsystems/${nqn} ${ports}/subsystems/
nvme connect -t tcp -n $nqn -a 127.0.0.1 -s 4420
EOF

sh-5.2# chmod +x loopback-nvme.sh
sh-5.2# modprobe -a nvme-tcp nvmet-tcp
sh-5.2# truncate -s 1g a.img b.img
sh-5.2# losetup --show -f a.img
/dev/loop0
sh-5.2# losetup --show -f b.img
/dev/loop1
sh-5.2# ./loopback-nvme.sh 0 /dev/loop0
connecting to device: nvme0
sh-5.2# ./loopback-nvme.sh 1 /dev/loop1
connecting to device: nvme1
sh-5.2# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 \
--failfast /dev/nvme0n1 --failfast /dev/nvme1n1
...
mdadm: array /dev/md0 started.

# run fio #
sh-5.2# fio --name=test --filename=/dev/md0 --rw=randrw --rwmixread=50 \
--bs=4k --numjobs=9 --time_based --runtime=300s --group_reporting --direct=1

# It can reproduce the issue by block nvme traffic during fio #
sh-5.2# iptables -A INPUT -m tcp -p tcp --dport 4420 -j DROP;
sh-5.2# sleep 10; # twice the default KATO value
sh-5.2# iptables -D INPUT -m tcp -p tcp --dport 4420 -j DROP


Patch 1–3 serve as preparatory changes for patch 4.
Patch 4 prevents MD_FAILFAST bio failure causing the array to fail.
Patch 5, regardless of FAILFAST, reports success to the upper layer
if a write retry in narrow_write_error succeeds without marking badblock.
Patch 6 fixes an issue where writes are not retried in a no-bbl
configuration when last rdevs MD_FAILFAST bio failure.
Patch 7 adds the missing retry path for Failfast read errors in RAID10.
Patch 8-9 modify the pr_crit handling in raid{1,10}_error.

Kenta Akagi (9):
  md/raid1,raid10: Set the LastDev flag when the configuration changes
  md: serialize md_error()
  md: introduce md_bio_failure_error()
  md/raid1,raid10: Don't set MD_BROKEN on failfast bio failure
  md/raid1,raid10: Set R{1,10}BIO_Uptodate when successful retry of a
    failed bio
  md/raid1,raid10: Fix missing retries Failfast write bios on no-bbl
    rdevs
  md/raid10: fix failfast read error not rescheduled
  md/raid1,raid10: Add error message when setting MD_BROKEN
  md/raid1,raid10: Fix: Operation continuing on 0 devices.

 drivers/md/md.c     |  61 ++++++++++++++---
 drivers/md/md.h     |  12 +++-
 drivers/md/raid1.c  | 156 ++++++++++++++++++++++++++++++++------------
 drivers/md/raid10.c | 115 ++++++++++++++++++++++++++------
 4 files changed, 270 insertions(+), 74 deletions(-)

-- 
2.50.1

