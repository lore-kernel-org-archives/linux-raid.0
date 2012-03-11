From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Raid5 device hangs in active state
Date: Sun, 11 Mar 2012 17:39:59 -0500
Message-ID: <4F5D29BF.1050500@nuclearwinter.com>
References: <4F0A129E.5020706@nuclearwinter.com> <20120109112644.489e4a48@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030006000305010503060404"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120109112644.489e4a48@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030006000305010503060404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I either have more info or a totally different scenario. I initiated a
raid5->raid6 reshape on a different machine. At the same time I (perhaps
stupidly) ran resize2fs to shrink the ext4 fs on the array being
reshaped. The reshape is going slowly (as I would expect) but the resize
is nearly dead. It is only able to write a single 4k block to the array
about every 5-6 seconds.

If that's expected then sorry for the noise and please ignore the rest.
Otherwise...

When I tried reducing sync_speed_min to 1000 the resize2fs write
interval increased to once per 8-10s. When I lowered sync_speed_max to
1000 I saw no more writes until I set the min/max back to 500000 at
which point iostat reported a w_await time roughly equal to the time the
array had the lower max.

The '# echo t > /proc/sysrq-trigger ' output seems to indicate that
resize2fs is stuck doing an fsync. The full dump is attached.

Here's an iostat showing 100% utilization of the LVM volume and the 4k
block writes.

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     1.00    0.00    0.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    1.00     0.00     4.00    
8.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    1.00     0.00     4.00    
8.00     1.00 6200.00    0.00 6200.00 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     1.00    0.00    0.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     1.00    0.00    0.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     1.00    0.00    0.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     1.00    0.00    0.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    1.00     0.00     4.00    
8.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    1.00     0.00     4.00    
8.00     1.00 5450.00    0.00 5450.00 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md2               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00    
0.00     1.00    0.00    0.00    0.00   0.00 100.00

/proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [raid0]
md10 : active raid5 md11[3] sdo1[1] sdn1[0]
      1250259200 blocks super 1.2 level 5, 128k chunk, algorithm 2 [3/3]
[UUU]

md11 : active raid0 sdm1[1] sdad1[0]
      625138176 blocks super 1.2 128k chunks

md5 : active raid5 sdq1[6] sdp1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
      1220981760 blocks super 1.2 level 5, 128k chunk, algorithm 2 [6/6]
[UUUUUU]

md3 : active raid6 sdy2[4] md4[2] sdx3[1] sdt3[0]
      1875411968 blocks super 1.2 level 6, 128k chunk, algorithm 2 [4/3]
[UUU_]
        resync=DELAYED

md2 : active raid6 sdy1[11] sdz2[0] sdt2[10] sdx2[9] sdu2[8] sds2[7]
sdw2[6] sdv2[5] sdr2[4] sdac2[3] sdaa2[2] sdab2[1]
      6641912320 blocks super 0.91 level 6, 128k chunk, algorithm 18
[12/11] [UUUUUUUUUUU_]
      [===============>.....]  reshape = 77.4% (514551296/664191232)
finish=1030.3min speed=2420K/sec

md1 : active raid5 sdj1[0] sdu1[14] sdx1[13] sdt1[12] sdv1[11] sdw1[10]
sdh1[9] sdac1[8] sdaa1[7] sdr1[6] sdab1[5] sdz1[4] sdk1[3] sds1[2] sdl1[1]
      4375960064 blocks level 5, 64k chunk, algorithm 2 [15/15]
[UUUUUUUUUUUUUUU]

md4 : active raid0 sdi1[1] sdg1[0]
      976769024 blocks super 1.2 128k chunks

md0 : active raid1 sdb1[1] sda1[0]
      41941944 blocks super 1.2 [2/2] [UU]

unused devices: <none>

Kernel: 3.2.9-1.fc16.x86_64
mdadm:  v3.2.3
resize2fs: 1.41.14

--Larkin

On 1/8/2012 6:26 PM, NeilBrown wrote:
> On Sun, 08 Jan 2012 16:03:10 -0600 Larkin Lowrey
<llowrey@nuclearwinter.com>
> wrote:
>
>> Suggestions?
>
> # echo t > /proc/sysrq-trigger
>
> and capture that messages that go to 'dmesg'. Post them.
>
> Hopefully your message ring buffer is big enough to collect the entire
> output. If it isn't you might need to boot with
> log_buf_len=1M
> or similar.
>
> That should show what process is blocking on what.
>
> NeilBrown


--------------030006000305010503060404
Content-Type: application/octet-stream;
 name="resize2fs hang.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="resize2fs hang.zip"

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
AAAAAQABAEAAAADrXwAAAAA=
--------------030006000305010503060404--
