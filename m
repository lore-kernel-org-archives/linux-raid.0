From: Xiao Ni <xni@redhat.com>
Subject: raid5_finish_reshape is stuck at revalidate_disk
Date: Mon, 28 Aug 2017 04:55:03 -0400 (EDT)
Message-ID: <1999382853.2558337.1503910503285.JavaMail.zimbra@redhat.com>
References: <1005529738.2550097.1503908586139.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1005529738.2550097.1503908586139.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Shaohua

We countered one stuck problem in RHEL7.4 and reproduced with 4.7.0-rc3 before. It's
hard to reproduce this problem. The steps we did:

#!/bin/bash
num=0
while [ 1 ]
do
	echo "*************************$num"
	mdadm -Ss
	mdadm --create --run /dev/md0 --level 5 --metadata 1.2 --raid-devices 5 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --spare-devices 1 /dev/loop5 --chunk 512
	mdadm --wait /dev/md0
	mkfs -t ext4 /dev/md0
	mount -t ext4 /dev/md0 /mnt/md_test
	dd if=/dev/urandom of=/mnt/md_test/testfile bs=1M count=100
	mdadm --add /dev/md0 /dev/loop7
	mdadm --grow --raid-devices 6 /dev/md0
	mdadm --wait /dev/md0
	((num++))
	umount /dev/md0
done

The size of loop devices is 500MB

The calltrace is:
[440673.498495] INFO: task ext4lazyinit:27649 blocked for more than 120 seconds.
[440673.505634] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[440673.513556] ext4lazyinit    D 0000000000001000     0 27649      2 0x00000080
[440673.513560]  ffff880201fefbf0 0000000000000046 ffff88022084ce70 ffff880201feffd8
[440673.521119]  ffff880201feffd8 ffff880201feffd8 ffff88022084ce70 ffff88022fc96d00
[440673.528673]  0000000000000000 7fffffffffffffff ffff88022084ce70 0000000000001000
[440673.536231] Call Trace:
[440673.538767]  [<ffffffff81689d39>] schedule+0x29/0x70
[440673.543825]  [<ffffffff81687859>] schedule_timeout+0x239/0x2c0
[440673.549753]  [<ffffffff814f4b8c>] ? md_make_request+0xdc/0x230
[440673.555678]  [<ffffffff81180fc5>] ? mempool_alloc_slab+0x15/0x20
[440673.561784]  [<ffffffff810e797c>] ? ktime_get_ts64+0x4c/0xf0
[440673.567530]  [<ffffffff8168939e>] io_schedule_timeout+0xae/0x130
[440673.573631]  [<ffffffff8168a406>] wait_for_completion_io+0x116/0x170
[440673.580083]  [<ffffffff810c1e30>] ? wake_up_state+0x20/0x20
[440673.585745]  [<ffffffff812f153c>] blkdev_issue_zeroout+0x24c/0x260
[440673.592019]  [<ffffffffa0a13f02>] ? jbd2_journal_get_write_access+0x32/0x40 [jbd2]
[440673.599686]  [<ffffffffa0a3386c>] ext4_init_inode_table+0x17c/0x3c0 [ext4]
[440673.606650]  [<ffffffffa0a52305>] ext4_lazyinit_thread+0x275/0x2f0 [ext4]
[440673.613529]  [<ffffffffa0a52090>] ? ext4_unregister_li_request+0x60/0x60 [ext4]
[440673.620924]  [<ffffffff810ae2bf>] kthread+0xcf/0xe0
[440673.625897]  [<ffffffff810ae1f0>] ? kthread_create_on_node+0x140/0x140
[440673.632514]  [<ffffffff81695598>] ret_from_fork+0x58/0x90
[440673.638007]  [<ffffffff810ae1f0>] ? kthread_create_on_node+0x140/0x140
[440793.653200] INFO: task md0_raid5:27638 blocked for more than 120 seconds.
[440793.660081] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[440793.668004] md0_raid5       D ffffffff81687e70     0 27638      2 0x00000080
[440793.668007]  ffff88005499f810 0000000000000046 ffff88022084de20 ffff88005499ffd8
[440793.675578]  ffff88005499ffd8 ffff88005499ffd8 ffff88022084de20 ffff88022fcd6d00
[440793.683153]  0000000000000000 7fffffffffffffff ffff88022ff99de8 ffffffff81687e70
[440793.690721] Call Trace:
[440793.693259]  [<ffffffff81687e70>] ? bit_wait+0x50/0x50
[440793.698491]  [<ffffffff81689d39>] schedule+0x29/0x70
[440793.703559]  [<ffffffff81687859>] schedule_timeout+0x239/0x2c0
[440793.709488]  [<ffffffffa0a13798>] ? jbd2_journal_try_to_free_buffers+0xd8/0x120 [jbd2]
[440793.717502]  [<ffffffffa0a33cc2>] ? ext4_releasepage+0x52/0xb0 [ext4]
[440793.724034]  [<ffffffff81687e70>] ? bit_wait+0x50/0x50
[440793.729266]  [<ffffffff8168939e>] io_schedule_timeout+0xae/0x130
[440793.735368]  [<ffffffff81689438>] io_schedule+0x18/0x20
[440793.740689]  [<ffffffff81687e81>] bit_wait_io+0x11/0x50
[440793.746008]  [<ffffffff816879a5>] __wait_on_bit+0x65/0x90
[440793.751504]  [<ffffffff8117d521>] wait_on_page_bit+0x81/0xa0
[440793.757260]  [<ffffffff810af450>] ? wake_bit_function+0x40/0x40
[440793.763274]  [<ffffffff8118e34b>] truncate_inode_pages_range+0x3bb/0x740
[440793.770071]  [<ffffffff8118e74e>] truncate_inode_pages_final+0x5e/0x90
[440793.776697]  [<ffffffffa0a3b3d0>] ext4_evict_inode+0x70/0x4d0 [ext4]
[440793.783146]  [<ffffffff81216567>] evict+0xa7/0x170
[440793.788031]  [<ffffffff8121666e>] dispose_list+0x3e/0x50
[440793.793440]  [<ffffffff81217424>] invalidate_inodes+0x134/0x160
[440793.799457]  [<ffffffff812357aa>] __invalidate_device+0x3a/0x60
[440793.805471]  [<ffffffff812357fb>] flush_disk+0x2b/0xd0
[440793.810707]  [<ffffffff81235929>] check_disk_size_change+0x89/0x90
[440793.816983]  [<ffffffff81425857>] ? put_device+0x17/0x20
[440793.822390]  [<ffffffff81235984>] revalidate_disk+0x54/0x80
[440793.828059]  [<ffffffffa09f2c9f>] raid5_finish_reshape+0x5f/0x180 [raid456]
[440793.835114]  [<ffffffff814fec14>] md_reap_sync_thread+0x54/0x150
[440793.841216]  [<ffffffff814ff0e9>] md_check_recovery+0x119/0x4f0
[440793.847231]  [<ffffffffa09fdc24>] raid5d+0x594/0x930 [raid456]
[440793.853160]  [<ffffffff814f7f45>] md_thread+0x155/0x1a0


I got one vmcore and did some analysis:
For process raid5d:
In the calltrace raid5d was stuck at truncate_inode_pages_range

crash> set 27638
    PID: 27638
COMMAND: "md0_raid5"
   TASK: ffff88022084de20  [THREAD_INFO: ffff88005499c000]
    CPU: 3
  STATE: TASK_UNINTERRUPTIBLE 
crash> bt -f
...
 #7 [ffff88005499f970] wait_on_page_bit at ffffffff8117d521
    ffff88005499f978: ffffea0005642e80 000000000000000d 
    ffff88005499f988: 0000000000000000 0000000000000000 
    ffff88005499f998: ffff88022084de20 ffffffff810af450 
    ffff88005499f9a8: ffff88022ff99df0 ffff88022ff99df0 
    ffff88005499f9b8: 000000002dd494e2 ffff88005499fb10 
    ffff88005499f9c8: ffffffff8118e34b 
 #8 [ffff88005499f9c8] truncate_inode_pages_range at ffffffff8118e34b

/usr/src/debug/kernel-3.10.0-547.el7/linux-3.10.0-547.el7.x86_64/include/linux/pagemap.h: 433
0xffffffff8118e337 <truncate_inode_pages_range+935>:	mov    %rdx,%rdi
0xffffffff8118e33a <truncate_inode_pages_range+938>:	mov    $0xd,%esi
0xffffffff8118e33f <truncate_inode_pages_range+943>:	mov    %rdx,-0x130(%rbp)
0xffffffff8118e346 <truncate_inode_pages_range+950>:	callq  0xffffffff8117d4a0 <wait_on_page_bit>
0xffffffff8118e34b <truncate_inode_pages_range+955>:	mov    -0x130(%rbp),%rdx   //the command waits to be process

430 static inline void wait_on_page_writeback(struct page *page)
431 {                       
432         if (PageWriteback(page))
433                 wait_on_page_bit(page, PG_writeback);
434 }

Because the PG_writeback couldn't be cleared, so raid5d was stuck at
revalidate_disk ... truncate_inode_pages_range ... wait_on_page_writeback


crash> mddev ffff88020e701000
struct mddev {
  private = 0xffff88022388a400,   //r5conf

crash> r5conf 0xffff88022388a400
struct r5conf {
...
  handle_list = {
    next = 0xffff88022388a488,      //empty
    prev = 0xffff88022388a488
  },
  hold_list = {
    next = 0xffff8802057e09a0,     //have stripes,  
    prev = 0xffff880210ac0010
  },
  delayed_list = {
    next = 0xffff880225eca650,     //have stripes
    prev = 0xffff8802162909a0
  },

crash> struct -ox stripe_head
struct stripe_head {
    [0x0] struct hlist_node hash;
   [0x10] struct list_head lru;

The address in hold_list and delayed_list are stripe_head->lru. So the address of stripe_head need to subtract 0x10.

crash> list -H 0xffff880210ac0010
ffff88022388a498          //list head
ffff8802057e09a0          //address of stripe_head is ffff8802057e0990
ffff880216264300
...

crash> stripe_head ffff8802057e0990
struct stripe_head {
...
towrite = 0xffff8800c2a10800, //it's the bio that hold in stripe_head


crash>   bio 0xffff8800c2a10800
struct bio {
  bi_sector = 473832, 
  bi_next = 0x0, 
  bi_bdev = 0xffff880036179d40, 
  bi_flags = 3458764513820549121, 
  bi_rw = 1, 
  bi_vcnt = 31, 
  bi_idx = 0, 
  bi_phys_segments = 8, 
  bi_size = 126976, 
  bi_seg_front_size = 0, 
  bi_seg_back_size = 0, 
  bi_end_io = 0xffffffffa0a3d640 <ext4_end_bio>, 
  bi_private = 0xffff8801fe545360, 

I checked all the bios in stripe_head. The bi_end_io of all bios is ext4_end_bio. 

Function ext4_bio_write_page calls:
--set_page_writeback
--io_submit_add_bh
--io_submit_init_bio

static int io_submit_init_bio(struct ext4_io_submit *io,
                              struct buffer_head *bh)
{
        ...
        bio->bi_end_io = ext4_end_bio;
        bio->bi_private = ext4_get_io_end(io->io_end);

In callback function ext4_end_bio it can clear PG_writeback.
 
It's a deadlock now. Do you agree this? If my analysis is right, upstream
should have this problem too. 

Best Regards
Xiao






