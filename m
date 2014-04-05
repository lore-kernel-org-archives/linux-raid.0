From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing RAID5 SSD Array
Date: Sun, 06 Apr 2014 05:25:10 +1000
Message-ID: <53405896.5070902@websitemanagers.com.au>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au> <532DE6FC.5010301@hardwarefreak.com> <5331804B.6010708@websitemanagers.com.au> <5331E7AB.9080904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5331E7AB.9080904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/03/14 07:31, Stan Hoeppner wrote:
> On 3/25/2014 8:10 AM, Adam Goryachev wrote:
>> I'll respond to the other email later on, but in between, I've found something else that seems just plain wrong.
>>
>> So, right now, I've shutdown most of the VM's (just one Linux VM left, which should be mostly idle since it is after 11pm local time). I'm trying to create a duplicate copy of one LV to another as a backup (in case I mess it up). So, I've shutdown DRBD, so we are operating independently (not that there is any change if DRBD is connected), I'm running on the storage server itself (so no iscsi or network issues).
>>
>> So, two LV's:
>>    LV VG   Attr     LSize   Pool Origin Data%  Move Log Copy%  Convert
>>    backup_xptserver1_d1_20140325_224311 vg0  -wi-ao-- 453.00g
>>    xptserver1_d1                                              vg0 -wi-ao-- 452.00g
> So you're copying 452 GB of raw bytes from one LV to another.
>
>> running the command:
> This is part of the problem:
>> dd if=/dev/vg0/xptserver1_d1 of=/dev/vg0/backup_xptserver1_d1_20140325_224311
> Using the dd defaults of buffered IO and 512 byte block size is horribly inefficient when copying 452 GB of data, especially to SSD.  Buffered IO consumes 904 GB of extra memory bandwidth.  Using 512 byte IOs requires much work of the raid5 write thread and more stripe cache bandwidth.  Use this instead:
>
> dd if=/dev/vg0/xxx of=/dev/vg0/yyy iflag=direct oflag=direct bs=1536k
>
> This eliminates 904 GB of RAM b/w in memcpy's and writes out to the block layer in 1.5 MB IOs, i.e. four full stripes.  This decreases the amount of work required of md as it receives 4 stripes of ligned IO at once, instead of 512 byte IOs which it must assemble.

Yes, of course, I should have known better! What a waste of three hours 
or so....
>> from another shell I run:
>> while pidof dd > /dev/null;do kill -USR1 `pidof dd`;sleep 10;done
>>
>> dd shows this output:
>> 99059692032 bytes (99 GB) copied, 2515.43 s, 39.4 MB/s
>> 99403235840 bytes (99 GB) copied, 2525.45 s, 39.4 MB/s
>> 99817538048 bytes (100 GB) copied, 2535.47 s, 39.4 MB/s
>> 100252660224 bytes (100 GB) copied, 2545.49 s, 39.4 MB/s
> Yes, that is very low, worse than single rust.  Using the dd options above should bump this up substantially.  However I have read claims that LVM2 over md tends to decrease performance.  I'm still looking into that for verification.
>
> When you performed the in depth FIO testing last year with the job files I provided, was the target the md RAID device or an LV?

I'm certain that it was against an LV on DRBD on MD RAID5, while the 
DRBD was disconnected.

>> iostat -dmx 1 shows this output:
>>
>> sda - sdg are the RAID5 SSD drives, single partition, used by md only
>> dm-8 is the source for the dd copy
>> dm-17 is the destination of the dd copy,
>> dm-12 is the Linux VM which is currently running...
>>
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sdg             957.00  6767.00  930.00  356.00     8.68    27.65 57.85     0.65    0.50    0.16    1.39   0.37  48.00
>> sdd             956.00  6774.00  921.00  313.00     8.69    27.50 60.06     0.26    0.21    0.08    0.60   0.17  20.80
>> sda             940.00  6781.00  927.00  326.00     8.65    27.57 59.20     0.28    0.22    0.09    0.60   0.17  20.80
>> sdf             967.00  6768.00  927.00  320.00     8.70    27.50 59.46     0.29    0.23    0.12    0.55   0.16  20.00
>> sde             943.00  6770.00  933.00  369.00     8.69    27.71 57.26     0.74    0.57    0.16    1.60   0.44  57.20
>> sdc             983.00  6790.00  937.00  317.00     8.86    27.55 59.46     1.58    1.27    0.71    2.90   0.49  61.60
>> sdb             966.00  6813.00  929.00  313.00     8.76    27.57 59.92     1.20    0.97    0.34    2.84   0.49  61.20
>                    ^^^^^^^ ^^^^^^^
> Note the difference between read merges and write merges, about 7:1, whereas the bandwidth is about 3:1.  That's about 7K read merges/s and 48K write merges/s.  Telling dd to use 1.5 MB IOs should reduce merges significantly, increasing throughout by a non negligible amount.  It should also decrease %util substantially, as less CPU time is required for merging, and less for md to assemble stripes from tiny 512 byte writes.
>
>> md1               0.00     0.00 12037.00 42030.00    56.42 164.04     8.35     0.00    0.00    0.00    0.00   0.00   0.00
>> drbd2             0.00     0.00 12034.00 41989.00    56.41 164.02     8.36   177.73    3.31    0.46    4.13   0.02  91.60
>> dm-8              0.00     0.00 5955.00    0.00    23.26 0.00     8.00     4.43    0.74    0.74    0.00   0.01   6.40
>> dm-12             0.00     0.00  254.00    5.00    10.39     0.02 82.38     0.28    1.08    1.01    4.80   0.59  15.20
>> dm-17             0.00     0.00 5813.00 41984.00    22.71 164.00     8.00   174.87    3.65    0.15    4.13   0.02 100.00
> ...
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sdg            1472.00     0.00 1681.00    0.00    14.70     0.00 17.90     0.14    0.08    0.08    0.00   0.08  13.60
>> sdd            1472.00     0.00 1668.00    0.00    14.64     0.00 17.98     0.12    0.07    0.07    0.00   0.07  11.20
>> sda            1472.00     0.00 1673.00    0.00    14.66     0.00 17.95     0.12    0.07    0.07    0.00   0.07  11.60
>> sdf            1472.00     0.00 1680.00    0.00    14.69     0.00 17.91     0.13    0.08    0.08    0.00   0.07  12.40
>> sde            1472.00     0.00 1685.00    0.00    14.71     0.00 17.88     0.12    0.07    0.07    0.00   0.07  11.60
>> sdc            1478.00     0.00 1687.00    0.00    14.72     0.00 17.87     0.12    0.07    0.07    0.00   0.07  11.20
>> sdb            1487.00     0.00 1679.00    0.00    14.69     0.00 17.92     0.14    0.08    0.08    0.00   0.08  13.20
>> md1               0.00     0.00 22182.00    0.00   103.29 0.00     9.54     0.00    0.00    0.00    0.00   0.00   0.00
>> drbd2             0.00     0.00 22244.00    0.00   103.66 0.00     9.54     5.76    0.26    0.26    0.00   0.03  59.60
>> dm-8              0.00     0.00 10945.00    0.00    42.75 0.00     8.00     5.74    0.50    0.50    0.00   0.00   4.00
>> dm-12             0.00     0.00  446.00    0.00    18.51     0.00 84.99     0.07    0.15    0.15    0.00   0.07   3.20
>> dm-17             0.00     0.00 10836.00    0.00    42.33 0.00     8.00     0.58    0.05    0.05    0.00   0.05  57.60
> No clue here.  You're reading exactly the same amount from the drives, drbd2, dm-8, and dm-17.  Given your description of a dd copy from dm-8 to dm-17, it seems odd that dm-8 and dm-17 are being read nearly the same number of bytes here, with no writes.
I've just double checked, definitely reading from dm-8 and writing to 
dm-17, since all the LV's are on DRBD, the total reads on the LV's 
should equal the reads on drbd2, same goes for writes. Also, values for 
drbd2 should (approx) equal md1, and the sum of sd[a-g]. I really have 
no idea who, what, or why there would be any reads on dm-17...

>> Another 15 seconds of 0.00 wMB/s on dm-17
> These periods of no write activity suggest that your iostat timing didn't fully coincide with your dd copy.  If it's not that, then something is causing your write IO to stall entirely.  Any stack traces in dmesg?

Definitely not, the stats were collected and the email sent hours before 
the dd completed.... I only collected the stats for 76 seconds, the copy 
took around 4 hours...

Very interesting.... looking at log files can be at times :)
So, no stack traces etc in relation to this, however, just last night, 
the log started recording errors on the OS drive (sdh), some testing 
with dd shows that it is returning unreadable errors at 77551MB to 
77555MB. This first one works, the second fails:
dd if=/dev/sdh of=/dev/null bs=1M iflag=direct skip=77550 count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.00356682 s, 294 MB/s

dd if=/dev/sdh of=/dev/null bs=1M iflag=direct skip=77551 count=1
dd: reading `/dev/sdh': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.213353 s, 0.0 kB/s

This drive is on a different SATA controller (onboard) while all the 
rest of the drives are on the LSI SATA controller. I can read from the 
drive fine before 77551 and after 77556. I've just ordered a replacement 
drive, and will replace that tonight, then wait for the warranty 
replacement later. FYI, it's a Intel 120GB SSD.

I can't be sure, but I don't think this should have impacted on the 
copy, given that the OS isn't even in use generally, and wasn't the 
source/destination of the copy.

Actually, drive was replaced already....

>> In fact, the peak value is 180.00 and the minimum is 0.00, with a total of 44 seconds of 0.00 and 16seconds over 100.00 and 16 seconds between 0 and 100.
>>
>> Here is a look at top -b -d 0.5 -n 60|grep ^\%Cpu
>>>>>    95.9% --  %Cpu0  :  2.1 us, 29.2 sy,  0.0 ni,  4.2 id, 64.6 wa,  0.0 hi,  0.0 si,  0.0 st
>>>>>    91.1% --  %Cpu0  :  0.0 us, 24.4 sy,  0.0 ni,  6.7 id, 66.7 wa,  0.0 hi,  2.2 si,  0.0 st
>>>>>    82.9% --  %Cpu0  :  0.0 us, 25.5 sy,  0.0 ni, 14.9 id, 57.4 wa,  0.0 hi,  2.1 si,  0.0 st
>>>>>    91.3% --  %Cpu0  :  2.2 us, 32.6 sy,  0.0 ni,  4.3 id, 56.5 wa,  0.0 hi,  4.3 si,  0.0 st
>>>>>   100.0% --  %Cpu0  :  4.0 us, 42.0 sy,  0.0 ni,  0.0 id, 54.0 wa,  0.0 hi,  0.0 si,  0.0 st
>>>>>   100.0% --  %Cpu0  :  2.2 us, 39.1 sy,  0.0 ni,  0.0 id, 58.7 wa,  0.0 hi,  0.0 si,  0.0 st
>>>>>    93.5% --  %Cpu0  :  2.2 us, 34.8 sy,  0.0 ni,  4.3 id, 56.5 wa,  0.0 hi,  2.2 si,  0.0 st
> It would appear that the raid5 write thread is being scheduled only on Cpu0, which is not good as core0 is the only core on this machine that processes interrupts.  Hardware interrupt load above is zero, but with a real disk and network throughput rate it will eat into the cycles needed by the RAID5 thread.
OK, I'm going to add the following to the /etc/rc.local:
for irq in `cat /proc/interrupts |grep mpt2sas| awk -F: '{ print $1}'`
do
         echo 4 > /proc/irq/${irq}/smp_affinity
done

That will move the LSI card interrupt processing to CPU2 like this:
   57:  143806142       7246      41052          0 IR-PCI-MSI-edge      
mpt2sas0-msix0
   58:   14381650          0      22952          0 IR-PCI-MSI-edge      
mpt2sas0-msix1
   59:    6733526          0     144387          0 IR-PCI-MSI-edge      
mpt2sas0-msix2
   60:    3342802          0      32053          0 IR-PCI-MSI-edge      
mpt2sas0-msix3

You can see I briefly moved one to CPU1 as well.

Would you suggest moving the eth devices to another CPU as well, perhaps 
CPU3 ?

> The physical IO work does not seem to be spread very well across all 4 cores.  However, the data rates are so low here it's difficult to come to any conclusion.  Cores 1-2 are performing a little work, 5-10% or so.  If you present a workload with bare minimal optimization, removing the choke hold from md and the elevator, as in my dd example up above, I'm sure you'll see much more work done by the other cores, as there will be far more IO to process.
I'll run a bunch more tests tonight, and get a better idea. For now though:
dd if=/dev/vg0/xptest of=/dev/vg0/testing iflag=direct oflag=direct 
bs=1536k count=5k
iostat shows much more solid read and write rates, around 120MB/s peaks, 
dd reported 88MB/s, it also shows 0 for rrqm and wrqm, so no more 
merging was being done. The avgrq-sz value is always 128 for the 
destination, and almost always 128 for the source during the copy. This 
seems to equal 64kB, so I'm not sure why that is if we told dd to use 
1536k ...

top shows:
%Cpu0  :  0.0 us,  3.9 sy,  0.0 ni, 92.2 id,  2.0 wa,  0.0 hi,  2.0 si,  
0.0 st
%Cpu1  :  0.0 us,  2.0 sy,  0.0 ni, 94.1 id,  3.9 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  2.0 us,  8.2 sy,  0.0 ni, 75.5 id, 12.2 wa,  0.0 hi,  2.0 si,  
0.0 st
%Cpu3  :  0.0 us,  9.6 sy,  0.0 ni, 86.5 id,  3.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  : 19.2 us, 13.5 sy,  0.0 ni, 61.5 id,  5.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  : 21.6 us, 11.8 sy,  0.0 ni, 66.7 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  : 17.6 us, 19.6 sy,  0.0 ni, 51.0 id,  7.8 wa,  0.0 hi,  3.9 si,  
0.0 st
%Cpu3  : 19.6 us, 15.7 sy,  0.0 ni, 58.8 id,  5.9 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  2.0 sy,  0.0 ni, 91.8 id,  6.1 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  1.9 sy,  0.0 ni, 96.2 id,  1.9 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  2.0 us, 10.0 sy,  0.0 ni, 80.0 id,  8.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  2.0 us,  7.8 sy,  0.0 ni, 88.2 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  2.0 sy,  0.0 ni, 96.1 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni, 93.9 id,  6.1 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us, 10.0 sy,  0.0 ni, 76.0 id, 14.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  9.3 sy,  0.0 ni, 85.2 id,  5.6 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  3.9 sy,  0.0 ni, 92.2 id,  2.0 wa,  0.0 hi,  2.0 si,  
0.0 st
%Cpu1  :  0.0 us,  2.0 sy,  0.0 ni, 94.1 id,  3.9 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  1.9 us, 15.1 sy,  0.0 ni, 67.9 id, 15.1 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  5.9 sy,  0.0 ni, 84.3 id,  9.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  2.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us, 10.2 sy,  0.0 ni, 81.6 id,  8.2 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  6.1 sy,  0.0 ni, 85.7 id,  8.2 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  3.8 sy,  0.0 ni, 90.4 id,  5.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni, 88.2 id, 11.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  8.0 sy,  0.0 ni, 90.0 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  2.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni, 96.0 id,  4.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  2.0 us,  6.0 sy,  0.0 ni, 86.0 id,  6.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  9.3 sy,  0.0 ni, 75.9 id, 14.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  3.9 sy,  0.0 ni, 80.4 id, 15.7 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  3.8 sy,  0.0 ni, 90.4 id,  5.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  2.0 us,  3.9 sy,  0.0 ni, 92.2 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  2.0 sy,  0.0 ni, 94.1 id,  3.9 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  3.9 sy,  0.0 ni, 96.1 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  1.9 sy,  0.0 ni, 94.2 id,  3.8 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us, 10.4 sy,  0.0 ni, 79.2 id, 10.4 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  6.1 sy,  0.0 ni, 91.8 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  4.1 sy,  0.0 ni, 95.9 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  2.0 us,  2.0 sy,  0.0 ni, 94.1 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us, 12.0 sy,  0.0 ni, 76.0 id, 12.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us, 13.2 sy,  0.0 ni, 81.1 id,  5.7 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  2.0 us,  4.0 sy,  0.0 ni, 88.0 id,  6.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni, 96.0 id,  4.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  6.2 sy,  0.0 ni, 83.3 id, 10.4 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  7.7 sy,  0.0 ni, 84.6 id,  7.7 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us,  4.0 sy,  0.0 ni, 96.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  3.8 sy,  0.0 ni, 88.5 id,  7.7 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  6.4 sy,  0.0 ni, 87.2 id,  6.4 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  8.0 sy,  0.0 ni, 84.0 id,  8.0 wa,  0.0 hi,  0.0 si,  
0.0 st

So it looks like CPU0 is less busy, with more work being done on CPU2 
(the interrupts for the LSI SATA controller)

If I increase bs=6M then dd reports 130MB/s ...


>> Currently, there are no LVM snapshots at all, the raid array is in sync, operating normally:
>> md1 : active raid5 sdd1[7] sdb1[11] sdc1[10] sdf1[9] sdg1[5] sde1[8] sda1[6]
>>        2813087616 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
>>
>> mdadm --detail /dev/md1
>> /dev/md1:
>>          Version : 1.2
>>    Creation Time : Wed Aug 22 00:47:03 2012
>>       Raid Level : raid5
>>       Array Size : 2813087616 (2682.77 GiB 2880.60 GB)
>>    Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
>>     Raid Devices : 7
>>    Total Devices : 7
>>      Persistence : Superblock is persistent
>>
>>      Update Time : Tue Mar 25 23:55:42 2014
>>            State : active
>>   Active Devices : 7
>> Working Devices : 7
>>   Failed Devices : 0
>>    Spare Devices : 0
>>
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>>
>>             Name : san1:1  (local to host san1)
>>             UUID : 707957c0:b7195438:06da5bc4:485d301c
>>           Events : 1713337
>>
>>      Number   Major   Minor   RaidDevice State
>>         7       8       49        0      active sync   /dev/sdd1
>>         6       8        1        1      active sync   /dev/sda1
>>         8       8       65        2      active sync   /dev/sde1
>>         5       8       97        3      active sync   /dev/sdg1
>>         9       8       81        4      active sync   /dev/sdf1
>>        10       8       33        5      active sync   /dev/sdc1
>>        11       8       17        6      active sync   /dev/sdb1
>>
>>
>> Also, the DRBD is disconnected:
>>   2: cs:WFConnection ro:Primary/Unknown ds:UpToDate/DUnknown C r-----
>>      ns:79767379 nr:0 dw:137515806 dr:388623024 al:37206 bm:6688 lo:0 pe:0 ua:0 ap:0 ep:1 wo:f oos:58639192
> According to your iostat output above, drbd2 was indeed still engaged.  And eating over 59.6% and 91.6% of a core.
Nope, definitely not connected, however, it is still part of the IO 
path, because the LV sits on drbd. So it isn't talking to it's partner, 
but it still does it's own "work" in between LVM and MD.

>> So, I know dd isn't the ideal performance testing tool or metric, but I'd really like to know why I can't get more than 40MB/s. There is no networking, no iscsi, just a fairly simple raid5, drbd, and lvm.
> You can get much more than 40MB/s, but you must know your tools, and gain a better understanding of the Linux IO subsystem.

Apologies, it was a second late night in a row, and I wasn't doing very 
well, I should have remembered my previous lessons about this!

>> So, am I crazy? What totally retarded thing have I done here?
> No, not crazy.  Not totally retarded.  You simply shoved a gazillion 512 byte IOs through the block layer.  Even with SSDs that's going to be slow due to the extra work the kernel threads must perform on all those tiny IOs, and all the memory bandwidth consumed by buffered IO and stripe cache operations.
>
> The problem with your dd run here is the same problem you had before I taught you how to use FIO a year ago.  If you recall you were testing back then with a single dd process.  As I explained then, dd is a serial application.  It submits blocks one at a time with no overlap, and thus can't keep the request pipeline full.  With FIO and an appropriate job file, we kept the request pipeline full using parallel requests, and we used large IOs to keep overhead to a minimum.  The only way to increase dd throughput is to use large blocks and O_DIRECT to eliminate the RAM bandwidth of two unneeded memcpy's.
>
> You've simply forgotten that lesson, apparently.  Which is a shame, as I spent so much time teaching you the how and why of Linux IO performance...

OK, so thinking this through... We should expect really poor performance 
if we are not using O_DIRECT, and not doing large requests in parallel. 
I think the parallel part of the workload should be fine in real world 
use, since each user and machine will be generating some random load, 
which should be delivered in parallel to the stack (LVM/DRBD/MD). 
However, in 'real world' use, we don't determine the request size, only 
the application or client OS, or perhaps iscsi will determine that.

My concern is that while I can get fantastical numbers from specific 
tests (such as highly parallel, large block size requests) I don't need 
that type of I/O, so my system isn't tuned to my needs.

After working with linbit (DRBD) I've found out some more useful 
information, which puts me right back to the beginning I think, but with 
a lot more experience and knowledge.
It seems that DRBD keeps it's own "journal", so every write is written 
to the journal, then it's bitmap is marked, then the journal is written 
to the data area, then the bitmap updated again, and then start over for 
the next write. This means it is doing lots and lots of small writes to 
the same areas of the disk ie, 4k blocks.

Anyway, I was advised to re-organise the stack from:
RAID5 -> DRBD -> LVM -> iSCSI
To:
RAID5 -> LVM -> DRBD -> iSCSI
This means each DRBD device is smaller, and so the "working set" is 
smaller, and should be more efficient. So, now I am easily able to do 
tests completely excluding drbd by targeting the LV itself. Which means 
just RAID5 + LVM layers to worry about.

When I use this fio job:
[global]
filename=/dev/vg0/testing
zero_buffers
numjobs=16
thread
group_reporting
blocksize=4k
ioengine=libaio
iodepth=16
direct=1
runtime=60
size=16g

[read]
rw=randread
stonewall

[write]
rw=randwrite
stonewall

Then I get these results:
read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
2.0.8
Starting 32 threads

read: (groupid=0, jobs=16): err= 0: pid=36459
   read : io=74697MB, bw=1244.1MB/s, iops=318691 , runt= 60003msec
     slat (usec): min=0 , max=999873 , avg= 5.90, stdev=529.35
     clat (usec): min=0 , max=1002.4K, avg=795.43, stdev=5201.15
      lat (usec): min=0 , max=1002.4K, avg=801.56, stdev=5233.38
     clat percentiles (usec):
      |  1.00th=[    0],  5.00th=[  213], 10.00th=[  286], 20.00th=[ 366],
      | 30.00th=[  438], 40.00th=[  516], 50.00th=[  604], 60.00th=[ 708],
      | 70.00th=[  860], 80.00th=[ 1096], 90.00th=[ 1544], 95.00th=[ 1928],
      | 99.00th=[ 2608], 99.50th=[ 2800], 99.90th=[ 3536], 99.95th=[ 4128],
      | 99.99th=[15424]
     bw (KB/s)  : min=22158, max=245376, per=6.39%, avg=81462.59, 
stdev=22339.85
     lat (usec) : 2=3.34%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (usec) : 100=0.01%, 250=3.67%, 500=31.43%, 750=24.55%, 1000=13.33%
     lat (msec) : 2=19.37%, 4=4.25%, 10=0.04%, 20=0.01%, 50=0.01%
     lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%
   cpu          : usr=30.27%, sys=236.67%, ctx=239859018, majf=0, minf=64588
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=19122474/w=0/d=0, short=r=0/w=0/d=0
write: (groupid=1, jobs=16): err= 0: pid=38376
   write: io=13885MB, bw=236914KB/s, iops=59228 , runt= 60016msec
     slat (usec): min=2 , max=25554K, avg=25.74, stdev=17219.99
     clat (usec): min=122 , max=43459K, avg=4294.06, stdev=100111.47
      lat (usec): min=129 , max=43459K, avg=4319.92, stdev=101581.66
     clat percentiles (usec):
      |  1.00th=[  482],  5.00th=[  628], 10.00th=[  748], 20.00th=[ 996],
      | 30.00th=[ 1320], 40.00th=[ 1784], 50.00th=[ 2352], 60.00th=[ 3056],
      | 70.00th=[ 4192], 80.00th=[ 5920], 90.00th=[ 8384], 95.00th=[10816],
      | 99.00th=[17536], 99.50th=[20096], 99.90th=[57088], 99.95th=[67072],
      | 99.99th=[123392]
     bw (KB/s)  : min=   98, max=25256, per=6.74%, avg=15959.71, 
stdev=2969.06
     lat (usec) : 250=0.01%, 500=1.25%, 750=8.72%, 1000=10.13%
     lat (msec) : 2=23.87%, 4=24.78%, 10=24.87%, 20=5.85%, 50=0.39%
     lat (msec) : 100=0.11%, 250=0.01%, 750=0.01%, 2000=0.01%, >=2000=0.01%
   cpu          : usr=5.47%, sys=39.74%, ctx=54762279, majf=0, minf=62375
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=0/w=3554662/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
    READ: io=74697MB, aggrb=1244.1MB/s, minb=1244.1MB/s, 
maxb=1244.1MB/s, mint=60003msec, maxt=60003msec

Run status group 1 (all jobs):
   WRITE: io=13885MB, aggrb=236914KB/s, minb=236914KB/s, 
maxb=236914KB/s, mint=60016msec, maxt=60016msec

So, a maximum of 237MB/s write. Once DRBD takes that and adds it's 
overhead, I'm getting approx 10% of that performance (some of the time, 
other times I'm getting even less, but that is probably yet another issue).

Now, 237MB/s is pretty poor, and when you try and share that between a 
dozen VM's, with some of those VM's trying to work on 2+ GB files 
(outlook users), then I suspect that is why there are so many issues. 
The question is, what can I do to improve this? Should I use RAID5 with 
a smaller stripe size? Should I use RAID10 or RAID1+linear? Could the 
issue be from LVM? LVM is using 4MB Physical Extents, from reading 
though, nobody seems to worry about the PE size related to performance 
(only LVM1 had a limit on the number of PE's... which meant a larger LV 
required larger PE's).

Here is the current md array:
/dev/md1:
         Version : 1.2
   Creation Time : Wed Aug 22 00:47:03 2012
      Raid Level : raid5
      Array Size : 2813087616 (2682.77 GiB 2880.60 GB)
   Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
    Raid Devices : 7
   Total Devices : 7
     Persistence : Superblock is persistent

     Update Time : Sun Apr  6 05:19:14 2014
           State : clean
  Active Devices : 7
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : san1:1  (local to host san1)
            UUID : 707957c0:b7195438:06da5bc4:485d301c
          Events : 1713347

     Number   Major   Minor   RaidDevice State
        7       8       49        0      active sync   /dev/sdd1
        6       8        1        1      active sync   /dev/sda1
        8       8       65        2      active sync   /dev/sde1
        5       8       97        3      active sync   /dev/sdg1
        9       8       81        4      active sync   /dev/sdf1
       10       8       33        5      active sync   /dev/sdc1
       11       8       17        6      active sync   /dev/sdb1

BTW, I've also split the domain controller to a win2008R2 server, and 
upgraded the file server to win2012R2.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
