From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Mon, 04 Mar 2013 04:32:01 +1100
Message-ID: <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5131C338.8010402@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> 1) Make sure stripe_cache_size is as least 8192.  If not:
>> ~$ echo 8192 > /sys/block/md0/md/stripe_cache_size
>> Currently using default 256.

Done now

>> 2) Disable HT on the SAN1, retest write performance for single
>threaded
>> write issue.
>> top -b -n 60 -d 0.25|grep Cpu|sort -n > /some.dir/some.file

Done now

There seems to be only one row from the top output which is interesting:
Cpu0 : 3.6%us, 71.4%sy, 0.0%ni, 0.0%id, 10.7%wa, 0.0%hi, 14.3%si, 0.0%,st

Every other line had a high value for %id, or %wa, with lower values for %sy. This was during the second 'stage' of the fio run, earlier in the fio run there was no entry even close to showing the CPU as busy.

>> 3) fio tests should use this test config:

Sorry about the brief output, but I'm retyping it manually :(
READ: io=131072MB, aggrb=2506MB/s, minb=2566MB/s, maxb=2566MB/s, mint=52303msec, maxt=52303msec
WRITE: io=131072MB, aggrb=1262MB/s, minb=1292MB/s, maxb=1292MB/s, mint=103882msec, maxt=103882msec

Is this what I should be expecting now?
To me, it looks like it is close enough, but if you think I should be able to get even faster, then I will certainly investigate further.

>> 4) Try to connect the SSD's direct to the HBA, bypassing the hotswap
>> device in case this is limiting to SATA II or similar.
>You don't have to touch the hardware.  Simply do:
>~$ dmesg|grep "link up"
>ata3: SATA link up 6.0 Gbps (SStatus 113 SControl 310)
>
>This tells you the current data rate of each SAS/SATA link on all
>controllers.  With a boot SSD on mobo and 5 on the LSI, you should see
>6 at 6.0 Gbps and 1 at 3.0 Gbps.  Maybe another one if you have a DVD on
>SATA.

Actually, the motherboard has 2 x SATA3 ports and 4 x SATA2 ports, so I see one entry for the motherboard attached SSD at 6.0Gbps

However, all the drives connected to the LSI do not show this line.
I see the following entry though:
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
Perhaps that is related to the LSI ?
I also see lines like this:
scsi 0:0:0:0 SATA: handle(0x0009), sas_addr(0x4433221103000000), phy(3), device_name(0x0000000000000000)
scsi 0:0:0:0 SATA: enclosure_logical_id(0x500605b005b6b920), slot(0)

I had a poke around in /sys and the rest of the dmesg output, but couldn't see anything to clearly identify the speed they were connected at. My supplier suggests that the hot swap bay is just a physical connection, and that it shouldn't be doing any sort of "smarts" therefore it should not "reduce" it down to SATA2 etc... I'll leave this for now, but would still like to be sure that it is working properly at SATA3 speeds...

>> 5) Configure the user LAN switch to prioritise RDP traffic. If SMB
>> traffic is flooding the link, than we need the user to at least feel
>> happy that the screen is still updating.
>Can't hurt but only help.

Looked at this, but it gave me a headache... I'll have to come back to it, maybe discuss on the netgear forums to ensure I understand how all the different pieces fit together before I try and implement it.

>> 6) SAN1 - Get rid of the bond0 with 8 x 1G ports, and use 8 IP
>> addresses, (one on each port). Properly configure the clients to each
>> connect to a different pair of ports using MPIO.
>
>The connections are done with the iscsiadmin.  MPIO simply uses the
>resulting two local SCSI devices.  Remember the iscsiadm command line
>args to log each Xen client interface (IP) into only one san1 interface
>(IP).

Skipped, running out of time.... 

>> 7) Upgrade DRBD to 8.4.3
>> See https://blogs.linbit.com/p/469/843-random-writes-faster/
> Looks good

I can't seem to checkout 8.4.3, only 8.4.2 seems to work. I think I would be better to wait on this one as I don't really like to be on the bleeding edge. If everything else doesn't improve things, then I'll come back to this one.

>> 9) Check out the output of xm top
>> I presume this is to ensure the dom0 CPU is not too busy to keep up
>> with handling the iSCSI/ethernet traffic/etc.
>One of those AMD cores should be plenty for the hypervisor at peak IO
>load, as long as no VMs are allowed to run on it.  Giving a 2nd core to
>the DC VM may help though.
>
>> 10) Run benchmarks on a couple of LV's on the san1 machine, if these
>> pass the expected performance level, then re-run on the physical
>> machines (xen). If that passes, then run inside a VM.
>
>For getting at client VM performance, start testing there.  Only if you
>can't hit close to 100MB/s, then drill down through the layers.

I'll have to find some software to run benchmarks within the windows VM's, but at the moment, using fio with the above config (changing the size from 8g down to 2g), and running it on the xen physical machine (dom0) gives this result (only machine running):
READ: io=32768MB, aggrb=237288KB/s, minb=237288KB/s, maxb=237288KB/s, mint=141408msec, maxt=141408msec
WRITE: io=32768MB, aggrb=203307KB/s, minb=203307KB/s, maxb=203307KB/s, mint=165043msec, maxt=165043msec

So, 230MB/s read and 200MB/s write, using 2 x 1Gbps ethernet seems pretty good. 

>> 11) Collect the output from iostat -x 5 when the problem happens
>Not sure what this was for.  Given the link throughput numbers you
>posted the user complaints are not due to slow IO on the SAN server,
>but most likely a problem with the number of cores available to each 
>TS VM on the Xen boxen.

The TS VM's have dedicated 4 cores, and the physical machines have dedicated 2 cores. I don't think the TS are CPU limited, this was for me to watch this on the DC to ensure it's single CPU was not limiting performance

>> 13) Add at least a second virtual CPU (plus physical cpu) to the
>> windows DC. It is still single CPU due to the windows HAL version.
>> Prefer to provide a total of 4 CPU's to the VM, leaving 2 for the 
>> physical box, same as all the rest of the VM's and physicals.
>Probably won't help much but can't hurt.  Give it a low to-do priority.

Will do next time....

>> 14) Upgrade windows 2000 DC to windows 2003, potentially there was
>> some xen/windows issue with performance. Previously I had an issue
>> with Win2003 with no service packs, and it was resolved by upgrade to
>> service pack 4.
>Good idea.  W2K was around long before the virtual machine craze.

Running out of time, will try this another time. Can do it remotely anyway...

>> 15) "Make sure all LVs are aligned to the underlying md device

Should be done

>> 17) Consider upgrading the dual port network card on the DC box to a
>> 4port card, use 2 ports for iSCSI and 2 ports for the user lan.
>> Configure the user lan side as LACP, so it can provide up to 1G for
>> each of 2 SMB users simultaneously. Means total 2Gbps for iSCSI
>> and total 2Gbps for SMB, but only 1Gbps SMB for each user.
>Or simply add another single port $15 Realtek 8111/8168 PCIe x1 NIC,
>which matches the onboard ethernet, for user traffic--user traffic on
>Realtek, iSCSI on Intel.  This will allow the DC box to absorb sporadic
>large SMB transfers without slowing all other users' SMB traffic. 
>Given the cost per NIC you can easily do this on all Xen boxen so you still
>have SC migration ability across all Xen.

Good point, that is probably a smarter idea overall. However, I'll leave this until I run out of other options. 100MB/s *SHOULD* be enough considering it only had 100MB/s previously anyway.

>Any time.  I have one more suggestion that might make a world of
>difference to your users.
>
>You did not mention the virtual CPU configuration on the Xen TS boxen.
>Are you currently assigning 5 of 6 cores as vCPUs to both Windows TS
>instances?  If not you should be.  You should be able to assign a vCPU
>or an SMP group, to more than one guest, or vice versa.  Doing so will
>allow either guest to use all available cores when needed.  If you
>dedicate one to the hypervisor that leaves 5.  I'm not sure if Windows
>will run with an asymmetric CPU count.  If not, assign cores 1-4 to one
>guest and cores 2-5 to the other, assuming core 0 is dedicated to the
>hypervisor.  If Xen won't allow this, the create one SMP group of 4
>cores and assign it to both guests.  I've never used Xen so my
>terminology is likely off.  This is trivial to do with ESX.

I only run a single windows VM on each xen box (unless the xen boxes started failing, then I'd run multiple VM's on one xen box until it was repaired). As such, I have 2 CPU cores dedicated to the dom0 (xen, physical box) and 4 cores dedicated to the windows VM (domU). I can drop the physical box back to a single core and add an additional core to windows, but I don't think that will make much of a difference. I don't tend to see high CPU load on the TS boxes... Mostly I see high memory utilisation more than CPU, and that is one of the reasons to upgrade them to Win2008 64bit so I can allocate more RAM. I'm hoping that even with the virtualisation overhead, the modern CPU's are faster than the previous physical machines which were about 5 years old.

So, overall, I haven't achieved anywhere near as much as I had hoped... I've changed the stripe_cache_size, and disabled HT on san1.

Seems to be faster than before, so will see how it goes today/this week.

Regards,
Adam


Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
