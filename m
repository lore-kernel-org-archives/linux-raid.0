Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB913093CB
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577518; cv=none; b=PKbpPfzggQVs4CGhaCTHJrnVXlyGaWUT/YBGdp1Mf9aSQUC4dsTlzETdTteNBzi4mhT5C8h4iHItuILeu8NOeFRMJIbbkGZoSEVxPXBDK79iA1c4hMorE9C7ug4Yo4OL5QGcNDMXpBfN3G1JnWOoMmXYhq3vkHJaqEQmIclst9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577518; c=relaxed/simple;
	bh=A7Ytmx+msXbCMLv7qizf3sUsu6PFFcNzN3DCqr+RMMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=poP9JwOvjOJZxWc9N0ZkY6hnhCSnzxRXOZJIF5ET7ouDflD7o8nT8Bh6HwvCBvo7p960VVghq/d10/Q+HgPXmRt5wu2gQT3L+yqLcEazCnkpw7RfHyLyjuGOUupI29j8jDx72oCh/mErLtQ6+aVSvIdGu3HkN+Wk4QtXiO/h9P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=vhpgpzbi; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="vhpgpzbi"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAa090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:45 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=qn1+tAAVX5cF2gzds3Icn8juF28uRNlDHtH6BY/VYYc=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577485; v=1;
        b=vhpgpzbiRT7MvFblbPzybnrt8Rq7StII0xjn4IJfrcUbkvyW2Uy/nu0OaIuIfEzP
         yaHR0+uSkSMaV3k8PAHgUNDUx2FcaCi78VUY9ESCEWKOM6AgkHKirsVn7O6vptDc
         c9y2lzq5iicxVhaSNBlxB/QsGaGDwHij8tXjFAIENoeRdoSaTs9TsXeWfizastJ0
         Df3qv6DiDm9uIIgQRjkVeQuScWS57psPjIaWX/LLtpgEbiFyCgWASoikEwoNjH4S
         lqmIfkCFlVBdb98WA9bJrNylw3Gf/qlzOCbtv9e9+NNsYvmNiSfg7t7Ke+9D9ZbU
         dg+auOrrEbHBWMEuN5S9ug==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 00/16] Don't set MD_BROKEN on failfast bio failure
Date: Tue, 28 Oct 2025 00:04:17 +0900
Message-ID: <20251027150433.18193-1-k@mgml.me>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes from V4:
- Use device_lock to serialize md_error() instead of adding a new
  spinlock_t.
- Rename new function md_bio_failure_error() to md_cond_error().
- Add helper function pers->should_error() to determine whether to fail
  rdev in failfast bio failure, instead of using the LastDev flag.
- Avoid changing the behavior of the LastDev flag.
- Drop fix for R{1,10}BIO_Uptodate not being set despite successful
  retry; this will be sent separately after Nan's refactor.
- Drop fix for the message 'Operation continuing on 0 devices'; as it is
  outside the scope of this patch, it will be sent separately.
- Improve logging when metadata writing fails.
- Rename LastDev to RetryingSBWrite.
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

v4: https://lore.kernel.org/linux-raid/20250915034210.8533-1-k@mgml.me/
v3: https://lore.kernel.org/linux-raid/20250828163216.4225-1-k@mgml.me/
v2: https://lore.kernel.org/linux-raid/20250817172710.4892-1-k@mgml.me/
v1: https://lore.kernel.org/linux-raid/20250812090119.153697-1-k@mgml.me/

When multiple MD_FAILFAST bios fail simultaneously on Failfast-enabled
rdevs in RAID1/RAID10, the following issues can occur:
* MD_BROKEN is set and the array halts, even though this should not occur
  under the intended Failfast design.
* Writes retried through narrow_write_error succeed, but the I/O is still
  reported as BLK_STS_IOERR
  * NOTE: a fix for this was removed in v5, will be send separetely
    https://lore.kernel.org/linux-raid/6f0f9730-4bbe-7f3c-1b50-690bb77d5d90@huaweicloud.com/
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


Patch 1-2 serialize the md_error() with device_lock
Patch 3-6 introduce md_cond_error() and dependent helpers
Patch 7-8 preparation refactor for patch 11-12
Patch 9 adds the missing retry path for Failfast read errors in RAID10.
Patch 10-12 prevents MD_FAILFAST bio failure causing the array to fail;
this is what I want to achieve.
Patch 13-14 add the error log when the array stops functioning.
Patch 15 simply rename the LastDev flag.
Patch 16 add the mddev and rdev name to the error log when metadata
writing fails.
 
Kenta Akagi (16):
  md: move device_lock from conf to mddev
  md: serialize md_error()
  md: add pers->should_error() callback
  md: introduce md_cond_error()
  md/raid1: implement pers->should_error()
  md/raid10: implement pers->should_error()
  md/raid1: refactor handle_read_error()
  md/raid10: refactor handle_read_error()
  md/raid10: fix failfast read error not rescheduled
  md: prevent set MD_BROKEN on super_write failure with failfast
  md/raid1: Prevent set MD_BROKEN on failfast bio failure
  md/raid10: Prevent set MD_BROKEN on failfast bio failure
  md/raid1: add error message when setting MD_BROKEN
  md/raid10: Add error message when setting MD_BROKEN
  md: rename 'LastDev' rdev flag to 'RetryingSBWrite'
  md: Improve super_written() error logging

 drivers/md/md-linear.c   |   1 +
 drivers/md/md.c          |  58 ++++++++++++++--
 drivers/md/md.h          |  12 +++-
 drivers/md/raid0.c       |   1 +
 drivers/md/raid1.c       | 111 ++++++++++++++++++++-----------
 drivers/md/raid1.h       |   2 -
 drivers/md/raid10.c      | 116 ++++++++++++++++++++------------
 drivers/md/raid10.h      |   1 -
 drivers/md/raid5-cache.c |  16 ++---
 drivers/md/raid5.c       | 139 +++++++++++++++++++--------------------
 drivers/md/raid5.h       |   1 -
 11 files changed, 283 insertions(+), 175 deletions(-)

-- 
2.50.1

