From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v4 00/15] md/raid5: set STRIPE_SIZE as a configurable value
Date: Fri, 12 Jun 2020 19:42:05 +0800
Message-ID: <20200612114220.13126-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

Hi, all

 For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5
 will issue echo bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64.
 However, filesystem usually issue bio in the unit of 4KB. Then, RAID5 may
 waste resource of disk bandwidth.

 To solve the problem, this patchset try to set stripe_size as a configuare
 value. The default value is 4096. We will add a new sysfs entry and set it
 by writing a new value, likely:

 	echo 16384 > /sys/block/md1/md/stripe_size

 Normally, using default stripe_size can get better performance. So, NeilBrown
 have suggested just to fix the it as 4096. But, out test result shows that
 a big value of stripe_size may have better performance when size of issued
 IOs are mostly bigger than 4096. Thus, in this patchset, we still want to
 set stripe_size as a configurable value.

 In current implementation, grow_buffers() uses alloc_page() to allocate the
 buffers for each stripe_head. With the change, it means we allocate 64K buffers
 but just use 4K of them. To save memory, we try to let multiple buffers of
 stripe_head to share only one real page. Detail shows in following patch.

 To evaluate the new feature, we create raid5 device '/dev/md5' with 4 SSD disk
 and test it on arm64 machine with 64KB PAGE_SIZE.
 
 1) We format /dev/md5 with mkfs.ext4 and mount ext4 with default configure on
    /mnt directory. Then, trying to test it by dbench with command:
    dbench -D /mnt -t 1000 10. Result show as:
 
    'stripe_size = 64KB'
   
      Operation      Count    AvgLat    MaxLat
      ----------------------------------------
      NTCreateX    9805011     0.021    64.728
      Close        7202525     0.001     0.120
      Rename        415213     0.051    44.681
      Unlink       1980066     0.079    93.147
      Deltree          240     1.793     6.516
      Mkdir            120     0.004     0.007
      Qpathinfo    8887512     0.007    37.114
      Qfileinfo    1557262     0.001     0.030
      Qfsinfo      1629582     0.012     0.152
      Sfileinfo     798756     0.040    57.641
      Find         3436004     0.019    57.782
      WriteX       4887239     0.021    57.638
      ReadX        15370483     0.005    37.818
      LockX          31934     0.003     0.022
      UnlockX        31933     0.001     0.021
      Flush         687205    13.302   530.088
     
     Throughput 307.799 MB/sec  10 clients  10 procs  max_latency=530.091 ms
     -------------------------------------------------------
     
    'stripe_size = 4KB'
     
      Operation      Count    AvgLat    MaxLat
      ----------------------------------------
      NTCreateX    11999166     0.021    36.380
      Close        8814128     0.001     0.122
      Rename        508113     0.051    29.169
      Unlink       2423242     0.070    38.141
      Deltree          300     1.885     7.155
      Mkdir            150     0.004     0.006
      Qpathinfo    10875921     0.007    35.485
      Qfileinfo    1905837     0.001     0.032
      Qfsinfo      1994304     0.012     0.125
      Sfileinfo     977450     0.029    26.489
      Find         4204952     0.019     9.361
      WriteX       5981890     0.019    27.804
      ReadX        18809742     0.004    33.491
      LockX          39074     0.003     0.025
      UnlockX        39074     0.001     0.014
      Flush         841022    10.712   458.848
     
     Throughput 376.777 MB/sec  10 clients  10 procs  max_latency=458.852 ms
     -------------------------------------------------------
 
    It shows that setting stripe_size as 4KB has higher thoughput, i.e.
    (376.777 vs 307.799) and has smaller latency (530.091 vs 458.852)
    than that setting as 64KB.
 
 2) We try to evaluate IO throughput for /dev/md5 by fio with config:
 
     [4KB randwrite]
     direct=1
     numjob=2
     iodepth=64
     ioengine=libaio
     filename=/dev/md5
     bs=4KB
     rw=randwrite
     
     [64KB write]
     direct=1
     numjob=2
     iodepth=64
     ioengine=libaio
     filename=/dev/md5
     bs=1MB
     rw=write
     
    The fio test result as follow:
     
                   +                   +
                   | STRIPE_SIZE(64KB) | STRIPE_SIZE(4KB)
     +----------------------------------------------------+
     4KB randwrite |     15MB/s        |      100MB/s
     +----------------------------------------------------+
     1MB write     |   1000MB/s        |      700MB/s
 
    The result shows that when size of io is bigger than 4KB (64KB),
    64KB stripe_size has much higher IOPS. But for 4KB randwrite, that
    means, size of io issued to device are smaller, 4KB stripe_size
    have better performance.

V4:
 * Add sysfs entry for setting stripe_size.
 * Fix wrong page index and offset computation for function
   raid5_get_dev_page(), raid5_get_page_offset().
 * Fix error page offset in handle_stripe_expansion().

V3: 
 * RAID6 can support shared pages.
 * Rename function raid5_compress_stripe_pages() as 
   raid5_stripe_pages_shared() and update commit message.
 * Rename CONFIG_MD_RAID456_STRIPE_SIZE as CONFIG_MD_RAID456_STRIPE_SHIFT,
   and make the STRIPE_SIZE as multiple of 4KB.

V2:
 https://www.spinics.net/lists/raid/msg64254.html
 Introduce share pages strategy to save memory, just support RAID4 and RAID5.

V1:
 https://www.spinics.net/lists/raid/msg63111.html
 Just add CONFIG_MD_RAID456_STRIPE_SIZE to set STRIPE_SIZE

Yufen Yu (15):
  md/raid456: covert macro define of STRIPE_* as members of struct
    r5conf
  md/raid5: add sysfs entry to set and show stripe_size
  md/raid5: set default stripe_size as 4096
  md/raid5: add a member of r5pages for struct stripe_head
  md/raid5: allocate and free shared pages of r5pages
  md/raid5: set correct page offset for bi_io_vec in ops_run_io()
  md/raid5: set correct page offset for async_copy_data()
  md/raid5: resize stripes and set correct offset when reshape array
  md/raid5: add new xor function to support different page offset
  md/raid5: add offset array in scribble buffer
  md/raid5: compute xor with correct page offset
  md/raid5: support config stripe_size by sysfs entry
  md/raid6: let syndrome computor support different page offset
  md/raid6: compute syndrome with correct page offset
  raid6test: adaptation with syndrome function

 crypto/async_tx/async_pq.c          |  72 ++--
 crypto/async_tx/async_raid6_recov.c | 163 ++++++--
 crypto/async_tx/async_xor.c         | 120 +++++-
 crypto/async_tx/raid6test.c         |  24 +-
 drivers/md/raid5-cache.c            |   8 +-
 drivers/md/raid5-ppl.c              |  12 +-
 drivers/md/raid5.c                  | 627 +++++++++++++++++++++-------
 drivers/md/raid5.h                  | 103 ++++-
 include/linux/async_tx.h            |  23 +-
 9 files changed, 884 insertions(+), 268 deletions(-)

-- 
2.21.3
