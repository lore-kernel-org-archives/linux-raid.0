From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Sun, 7 Jan 2018 21:16:22 +0100
Message-ID: <20180107201622.GA7977@metamorpher.de>
References: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid.pkoch@dfgh.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 06, 2018 at 04:44:12PM +0100, mdraid.pkoch@dfgh.net wrote:
> Now today I increased the RAID10 again from 20 to 21 disks with the
> following commands:
> 
> mdadm /dev/md5 --add /dev/sdo
> mdadm --grow /dev/md5 --raid-devices=21
> 
> Just one second after starting the reshape operation
> XFS failed with the following messages:
> 
> md: reshape of RAID array md5
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000 
> KB/sec) for reshape.
> md: using 128k window, over a total of 19533829120k.
> XFS (md5): metadata I/O error: block 0x12c08f360 
> ("xfs_trans_read_buf_map") error 5 numblks 16

Ouch. No idea what happened there.

Use overlays to try to recover. Don't write anymore.

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

I tried to reproduce your problem, created a 20 drive RAID, 
and a while loop to grow to 21 drives, then shrink back to 20.

    truncate -s 100M {001..021}
    losetup ...
    mdadm --create /dev/md42 --level=10 --raid-devices=20 /dev/loop{1..20}
    mdadm --grow /dev/md42 --add /dev/loop21

    while :
    do
        mdadm --wait /dev/md42
        mdadm --grow /dev/md42 --raid-devices=21
        mdadm --wait /dev/md42
        mdadm --grow /dev/md42 --array-size 1013760
        mdadm --wait /dev/md42
        mdadm --grow /dev/md42 --raid-devices=20
    done

Then I put XFS on top and another while loop to extract a Linux tarball.

    while :
    do
        tar xf linux-4.13.4.tar.xz
        sync
        rm -rf linux-4.13.4
        sync
    done

Both running in parallel ad infinitum.

I couldn't get the XFS to corrupt.

mdadm itself eventually died though.

Told me two drives failed though none did and would refuse to continue 
the grow operation. Unless I'm missing something, the degraded counter 
seems to have gone out of whack. There was nothing in dmesg.

# cat /sys/block/md42/md/degraded 
2

# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md42 : active raid10 loop20[19] loop19[18] loop18[17] loop17[16] loop16[15] loop15[14] loop14[13] loop13[12] loop12[11] loop11[10] loop10[9] loop9[8] loop8[7] loop7[6] loop6[5] loop5[4] loop4[3] loop3[2] loop2[1] loop1[0]
      1013760 blocks super 1.2 512K chunks 2 near-copies [20/18] [UUUUUUUUUUUUUUUUUUUU]

Stopping and re-assembling and degraded went back to 0.

# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md42 : active raid10 loop1[0] loop20[19] loop19[18] loop18[17] loop17[16] loop16[15] loop15[14] loop14[13] loop13[12] loop12[11] loop11[10] loop10[9] loop9[8] loop8[7] loop7[6] loop6[5] loop5[4] loop4[3] loop3[2] loop2[1]
      1013760 blocks super 1.2 512K chunks 2 near-copies [20/20] [UUUUUUUUUUUUUUUUUUUU]

But this should be unrelated to your issue.
No idea what happened to you.
Sorry.

Regards
Andreas Klauer
