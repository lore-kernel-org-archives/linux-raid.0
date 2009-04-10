From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: RAID 10 Disk remove failing.
Date: Fri, 10 Apr 2009 12:07:37 +0100
Message-ID: <49DF2879.2020406@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am experiencing an intermittent issue on RAID 10 which causes a 
component from an active RAID 10 to refuse being --remove by mdadm after 
the component was hot unplugged.

The test was as follow:

First of all, some configuration information:

Platform: PPC
Kernel: 2.6.26.3
mdadm: ./mdadm --version
mdadm - v2.6.7 - 6th June 2008

Disks are all 10* Fujitsu SAS 36Gb in a SAS enclosure connected to the 
system using a 1068e LSI HBA.

The test details are below:

* create a RAID 10 array as follow:

./mdadm --create -vvv --force --run --metadata=1.2 /dev/md/d0 --level=10 
--size=9413632 --chunk=64 --name=1561369 -n5 --bitmap=internal 
--bitmap-chunk=4096 /dev/sde2 /dev/sdc2 /dev/sdh2 /dev/sda2 /dev/sdd2

* Run read/write IOs on the array, whichever IO size or type 
(read/write) does not seem to matter.

* Pull a disk from the enclosure where the disks are residing.

* The disk is offlined in linux (DID_NO_CONNECT):

(dmesg trace)
"[ 2617.988807] ioc0: Event = f, IOCLogInfo = 31120101
[ 2617.993598] ioc0 Event: 0xf
[ 2618.777669] ioc0 Event: SAS_DISCOVERY
[ 2618.783977] ioc0: Phy 4 Handle a is now offline
[ 2619.482674] ioc0 Event: SAS_DISCOVERY
[ 2623.110586] ioc0 Event: 0xf
[ 2623.121965] sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK,SUGGEST_OK
[ 2623.130519] end_request: I/O error, dev sda, sector 36297553
[ 2623.136169] raid10: sda2: rescheduling sector 145126912"

* After 14 of these DID_NO_CONNECT messages from the sd layer, the HBA 
driver (LSI MPT Fusion in this case) deletes the device's port in the 
driver and cleans it up, at which point the sd layer initiates a 
"synchronize cache" command:

(dmesg trace)
"sd 0:0:0:0: [sda] Synchronizing SCSI cache"

immediately followed by a:

(dmesg trace)
"raid10: Disk failure on sda2, disabling device.
raid10: Operation continuing on 7 devices."

This is where it is odd. When I get the above message, any:

mdadm --remove -vvv /dev/md/d0 /dev/sda2 command I issue fails with the 
following message in dmesg:

(dmesg trace)
"md: cannot remove active disk sda2 from md_d0 ..."

After which I get a Call Trace letting me know that something hung in MD 
layer:

(dmesg trace)
"[ 2754.151343] INFO: task md_d0_raid10:1006 blocked for more than 120 
seconds.
[ 2754.158305] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 2754.166108] md_d0_raid10  D 00000000     0  1006      2
[ 2754.171350] Call Trace:
[ 2754.173792] [e9645dc0] [00000010] 0x10 (unreliable)
[ 2754.178699] [e9645e80] [b0008758] __switch_to+0x40/0x60
[ 2754.183953] [e9645ea0] [b02eb57c] schedule+0x180/0x37c
[ 2754.189110] [e9645ef0] [b023b424] raid10d+0x9bc/0xb48
[ 2754.194182] [e9645f90] [b024ae00] md_thread+0x58/0x120
[ 2754.199343] [e9645fd0] [b00319e8] kthread+0x84/0x8c
[ 2754.204248] [e9645ff0] [b0003ab8] kernel_thread+0x44/0x60"

However, when the process is working fine (and the disk can be 
hotRemoved from the md layer), I get the following trace:

(dmesg trace)
"
[61268.363295] sd 0:0:17:0: [sdd] Synchronizing SCSI cache
[61269.155285] RAID10 conf printout:
[61269.158613]  --- wd:4 rd:5
[61269.161316]  disk 0, wo:0, o:1, dev:sdm2
[61269.165227]  disk 1, wo:0, o:1, dev:sdj2
[61269.169141]  disk 2, wo:0, o:1, dev:sdi2
[61269.173054]  disk 3, wo:0, o:1, dev:sdn2
[61269.176968]  disk 4, wo:1, o:0, dev:sdd2
[61269.192699] RAID10 conf printout:
[61269.196007]  --- wd:4 rd:5
[61269.198710]  disk 0, wo:0, o:1, dev:sdm2
[61269.202621]  disk 1, wo:0, o:1, dev:sdj2
[61269.206534]  disk 2, wo:0, o:1, dev:sdi2
[61269.210448]  disk 3, wo:0, o:1, dev:sdn2
[61269.271745] md: unbind<sdd2>
[61269.276962] md: export_rdev(sdd2)
[61269.282844]  target0:0:17: mptsas: ioc0: delete device: fw_channel 0, 
fw_id 1
3, phy 8, sas_addr 0x500000e012b089c2"

and it carries on fine, and the disk can then be removed from the array 
using m,dadm:

mdadm --remove -vvv /dev/md/d0 /dev/sdd2"

I only experience this with RAID level 10, never with any other RAID 
levels I would frequently use (0, 5, 6).

I understand that the RAID level 10 is still marked as experimental and 
I am absolutely not complaining or demanding for a fix, but would rather 
be interested if anyone else had experienced the same issue, and knew or 
had an opinion on where this issue originates, and so that I can try to 
fix it in the MD layer and post it if successful.

Many thanks in advance for any reply or experiences that anybody would have.

Thanks,
Ben.
