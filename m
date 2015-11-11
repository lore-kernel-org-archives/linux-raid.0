From: matt@digitallyhosted.com
Subject: Re: Buffer I/O errors & Kernel OOPS with RAID6
Date: Wed, 11 Nov 2015 10:59:36 +0000
Message-ID: <ea52e6218780a51dc1c803bf405f96ba@digitallyhosted.com>
References: <cac386db0aa8fec187d8a2c9f0582934@digitallyhosted.com>
 <20151109173507.GA58083@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151109173507.GA58083@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have now upgraded to 4.3.0

As a test, I have failed and removed a disc with no badblocks, and then 
added it back in, and now the badblock list is the same as my other 
drives with badblocks.

This list of badblocks exists on four of the harddrives now:

Bad-blocks on /dev/sdp1:
           1938038928 for 512 sectors
           1938039440 for 512 sectors
           1938977144 for 512 sectors
           1938977656 for 512 sectors
           3303750816 for 512 sectors
           3303751328 for 512 sectors
           3313648904 for 512 sectors
           3313649416 for 512 sectors
           3313651976 for 512 sectors
           3313652488 for 512 sectors
           3418023432 for 512 sectors
           3418023944 for 512 sectors
           3418024456 for 512 sectors
           3418024968 for 512 sectors
           3418037768 for 512 sectors
           3418038280 for 512 sectors
           3418038792 for 512 sectors
           3418039304 for 512 sectors
           3418112520 for 512 sectors
           3418113032 for 512 sectors
           3418113544 for 512 sectors
           3418114056 for 512 sectors
           3418114568 for 512 sectors
           3418115080 for 512 sectors
           3418124808 for 512 sectors
           3418125320 for 512 sectors
           3418165768 for 512 sectors
           3418166280 for 512 sectors
           3418187272 for 512 sectors
           3418187784 for 512 sectors
           3418213224 for 512 sectors
           3418213736 for 512 sectors
           3418214248 for 512 sectors
           3418214760 for 512 sectors
           3418215272 for 512 sectors
           3418215784 for 512 sectors
           3420607528 for 512 sectors
           3420608040 for 512 sectors
           3420626984 for 512 sectors
           3420627496 for 512 sectors
           3448897824 for 512 sectors
           3448898336 for 512 sectors
           3458897888 for 512 sectors
           3458898400 for 512 sectors
           3519403992 for 512 sectors
           3519404504 for 512 sectors
           3617207456 for 512 sectors
           3617207968 for 512 sectors

Is it normal for badblocks to propagate to newly added drives on the 
array?

I am doing a stress test on the array now (28 nodes of a cluster all 
creating large files on the array) to see if it falls over again.

On 2015-11-09 17:35, Shaohua Li wrote:
> On Mon, Nov 09, 2015 at 11:40:00AM +0000, matt@digitallyhosted.com 
> wrote:
>> Hello,
>> 
>> I am experiencing issues with RAID6 on all kernel versions I have 
>> tried
>> (3.18.12, 4.0.9, 4.1.12).
>> 
>> On 3.18.12, I am getting the following logged to dmesg:
>> 
>> 896.874943] EXT4-fs warning (device md4): ext4_end_bio:317: I/O error 
>> -5
>> writing to inode 361858058 (offset 16777216 size 1052672 starting 
>> block
>> 5172953088)
>> [  896.874945] Buffer I/O error on device md4, logical block 
>> 5172953088
>> [  896.874947] Buffer I/O error on device md4, logical block 
>> 5172953089
>> [  896.874948] Buffer I/O error on device md4, logical block 
>> 5172953090
>> [  896.874949] Buffer I/O error on device md4, logical block 
>> 5172953091
>> [  896.874950] Buffer I/O error on device md4, logical block 
>> 5172953092
>> [  896.874950] Buffer I/O error on device md4, logical block 
>> 5172953093
>> [  896.874951] Buffer I/O error on device md4, logical block 
>> 5172953094
>> [  896.874952] Buffer I/O error on device md4, logical block 
>> 5172953095
>> [  896.874953] Buffer I/O error on device md4, logical block 
>> 5172953096
>> [  896.874953] Buffer I/O error on device md4, logical block 
>> 5172953097
>> [  897.034829] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 1052672 starting block
>> 5172955136)
>> [  897.122306] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 2101248 starting block
>> 5172955264)
>> [  897.130547] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 2101248 starting block
>> 5172955392)
>> [  897.355966] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 2625536 starting block
>> 5172955520)
>> [  897.452464] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858058 (offset 16777216 size 1576960 starting 
>> block
>> 5172953216)
>> [  897.593480] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 3149824 starting block
>> 5172955648)
>> [  897.877728] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 3674112 starting block
>> 5172955776)
>> [  898.156331] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858073 (offset 8388608 size 4198400 starting block
>> 5172955904)
>> [  898.176687] EXT4-fs warning (device md4): ext4_end_bio:317: I/O 
>> error -5
>> writing to inode 361858058 (offset 16777216 size 2101248 starting 
>> block
>> 5172953344)
>> 
>> When this happens, I end up with a file on the array which is 
>> partially
>> corrupt.  For example, if i copied a jpeg file, parts of the image 
>> would be
>> garbage.
>> 
>> I initially thought that this could be a kernel issue, so I tried two
>> further kernel versions (4.0.9 & 4.1.12) and on both, I don't get the 
>> above
>> messages anymore, instead I get a kernel oops and any process 
>> accessing the
>> array will get stuck in state D.  Here is a typical kernel oops 
>> message:
>> 
>> [  158.138253] BUG: unable to handle kernel NULL pointer dereference 
>> at
>> 0000000000000120
>> [  158.138391] IP: [<ffffffffa024cc1f>] handle_stripe+0xdc0/0x1e1f 
>> [raid456]
>> [  158.138482] PGD 24ff59067 PUD 24fe43067 PMD 0
>> [  158.138646] Oops: 0000 [#1] SMP
>> [  158.138758] Modules linked in: ipv6 binfmt_misc joydev
>> x86_pkg_temp_thermal coretemp kvm_intel kvm microcode pcspkr video 
>> i2c_i801
>> thermal acpi_cpufreq fan battery rtc_cmos backlight processor 
>> thermal_sys
>> xhci_pci button xts gf128mul aes_x86_64 cbc sha256_generic
>> scsi_transport_iscsi multipath linear raid10 raid456 async_raid6_recov
>> async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0
>> dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash dm_log dm_mod
>> hid_sunplus hid_sony led_class hid_samsung hid_pl hid_petalynx 
>> hid_monterey
>> hid_microsoft hid_logitech hid_gyration hid_ezkey hid_cypress 
>> hid_chicony
>> hid_cherry hid_belkin hid_apple hid_a4tech sl811_hcd usbhid xhci_hcd
>> ohci_hcd uhci_hcd usb_storage ehci_pci ehci_hcd usbcore usb_common
>> megaraid_sas megaraid_mbox megaraid_mm megaraid sx8
>> [  158.141809]  DAC960 cciss mptsas mptfc scsi_transport_fc mptspi
>> scsi_transport_spi mptscsih mptbase sg
>> [  158.142226] CPU: 0 PID: 2017 Comm: md4_raid6 Not tainted 
>> 4.1.12-gentoo #1
>> [  158.142272] Hardware name: Supermicro X10SAT/X10SAT, BIOS 2.0 
>> 04/21/2014
>> [  158.142323] task: ffff880254267050 ti: ffff880095afc000 task.ti:
>> ffff880095afc000
>> [  158.142376] RIP: 0010:[<ffffffffa024cc1f>]  [<ffffffffa024cc1f>]
>> handle_stripe+0xdc0/0x1e1f [raid456]
>> [  158.142493] RSP: 0018:ffff880095affc18 EFLAGS: 00010202
>> [  158.142554] RAX: 000000000000000d RBX: ffff880095cfac00 RCX:
>> 0000000000000002
>> [  158.142617] RDX: 000000000000000d RSI: 0000000000000000 RDI:
>> 0000000000001040
>> [  158.142682] RBP: ffff880095affcf8 R08: 0000000000000003 R09:
>> 00000000cd920408
>> [  158.142745] R10: 000000000000000d R11: 0000000000000007 R12:
>> 000000000000000d
>> [  158.142809] R13: 0000000000000000 R14: 000000000000000c R15:
>> ffff8802161f2588
>> [  158.142873] FS:  0000000000000000(0000) GS:ffff88025ea00000(0000)
>> knlGS:0000000000000000
>> [  158.142938] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  158.143000] CR2: 0000000000000120 CR3: 0000000253ef4000 CR4:
>> 00000000001406f0
>> [  158.143062] Stack:
>> [  158.143117]  0000000000000000 ffff880254267050 00000000000147c0
>> 0000000000000000
>> [  158.143328]  ffff8802161f25d0 0000000effffffff ffff8802161f3670
>> ffff8802161f2ef0
>> [  158.143537]  0000000000000000 0000000000000000 0000000000000000
>> 0000000c00000000
>> [  158.143747] Call Trace:
>> [  158.143805]  [<ffffffffa024dea3>]
>> handle_active_stripes.isra.37+0x225/0x2aa [raid456]
>> [  158.143873]  [<ffffffffa024e31d>] raid5d+0x363/0x40d [raid456]
>> [  158.143937]  [<ffffffff814315bc>] ? schedule+0x6f/0x7e
>> [  158.143998]  [<ffffffff81372ae7>] md_thread+0x125/0x13b
>> [  158.144060]  [<ffffffff81061b00>] ? wait_woken+0x71/0x71
>> [  158.144122]  [<ffffffff813729c2>] ? md_start_sync+0xda/0xda
>> [  158.144185]  [<ffffffff81050609>] kthread+0xcd/0xd5
>> [  158.144244]  [<ffffffff8105053c>] ? 
>> kthread_create_on_node+0x16d/0x16d
>> [  158.144309]  [<ffffffff81434f92>] ret_from_fork+0x42/0x70
>> [  158.144370]  [<ffffffff8105053c>] ? 
>> kthread_create_on_node+0x16d/0x16d
>> [  158.144432] Code: 8c 0f d0 01 00 00 48 8b 49 10 80 e1 10 74 0d 49 
>> 8b 4f
>> 48 80 e1 40 0f 84 c2 0f 00 00 31 c9 41 39 c8 7e 31 48 8b b4 cd 50 ff 
>> ff ff
>> <48> 83 be 20 01 00 00 00 74 1a 48 8b be 38 01 00 00 40 80 e7 01
>> [  158.147700] RIP [<ffffffffa024cc1f>] handle_stripe+0xdc0/0x1e1f 
>> [raid456]
>> [  158.147801]  RSP <ffff880095affc18>
>> [  158.147859] CR2: 0000000000000120
>> [  158.147916] ---[ end trace 536b72bd7c91f068 ]---
>> 
>> In both cases, discs are never flagged as faulty and the array never 
>> goes
>> into a degraded state.
>> 
>> I have tried posting this in various forums with no solution so far.  
>> A post
>> with further information can be found here:
>> https://forums.gentoo.org/viewtopic-t-1032304.html - In that topic I 
>> have
>> supplied output from various commands that people have asked me to 
>> execute.
>> Rather than pasting all the output from these commands here have 
>> linked to
>> the thread instead.
>> 
>> Any Idea's what could be going on? Any help would be greatly 
>> appreciated.
> 
> Could you please try a upstream kernel? there are some fixes in error 
> handling
> side recently, might be related.
> ebda780bce8d58ec0ab
> 36707bb2e7c6730d79
