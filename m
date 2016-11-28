From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 09:28:18 +0200
Message-ID: <9ce71838-0a1d-e4d8-5786-9ab0422688af@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <CAJCQCtR+PnJXq9k37V1pXVO4UmW0dbhvAZYo=Pius2eCz9X_kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtR+PnJXq9k37V1pXVO4UmW0dbhvAZYo=Pius2eCz9X_kg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2016 06:11 AM, Chris Murphy wrote:
> On Sun, Nov 27, 2016 at 8:24 AM, Avi Kivity <avi@scylladb.com> wrote:
>> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large disk
>> that supports TRIM/DISCARD (erase whichever is inappropriate)
> Trim is the appropriate term. Term discard refers to a specific mount
> time implementation of FITRIM ioctl, and fstrim refers to a user space
> tool that does the same and can be scheduled or issued manually.

That's good to know.

>
>
>    That is
>> because mkfs issues a TRIM/DISCARD (erase whichever is inappropriate) for
>> the entire partition. As far as I can tell, md converts the large
>> TRIM/DISCARD (erase whichever is inappropriate) into a large number of
>> TRIM/DISCARD (erase whichever is inappropriate) requests, one per chunk-size
>> worth of disk, and issues them to the RAID components individually.
> You could strace the mkfs command.

I did, and saw that it was running a single syscall for the entire run.  
I verified in the sources that mkfs.xfs issues a single BLKDISCARD (?!) 
ioctl spanning the entire device.

> Each filesystem is doing it a
> little differently the last time I compared mkfs.xfs and mkfs.btrfs;
> but I can't qualify the differences relative to how the device is
> going to react to those commands.
>
> It's also possible to enable block device tracing and see the actual
> SCSI or ATA commands sent to a drive.

I did, and saw a ton of half-megabyte TRIMs.  It's an NVMe device so not 
SCSI or SATA.


Here's a sample (I only blktraced one of the members):

259,1   10     1090     0.379688898  4801  Q   D 3238067200 + 1024 
[mkfs.xfs]
259,1   10     1091     0.379689222  4801  G   D 3238067200 + 1024 
[mkfs.xfs]
259,1   10     1092     0.379690304  4801  I   D 3238067200 + 1024 
[mkfs.xfs]
259,1   10     1093     0.379703110  2307  D   D 3238067200 + 1024 
[kworker/10:1H]
259,1    1      589     0.379718918     0  C   D 3231849472 + 1024 [0]
259,1   10     1094     0.379735215  4801  Q   D 3238068224 + 1024 
[mkfs.xfs]
259,1   10     1095     0.379735548  4801  G   D 3238068224 + 1024 
[mkfs.xfs]
259,1   10     1096     0.379736598  4801  I   D 3238068224 + 1024 
[mkfs.xfs]
259,1   10     1097     0.379753077  2307  D   D 3238068224 + 1024 
[kworker/10:1H]
259,1    1      590     0.379782139     0  C   D 3231850496 + 1024 [0]
259,1   10     1098     0.379785399  4801  Q   D 3238069248 + 1024 
[mkfs.xfs]
259,1   10     1099     0.379785657  4801  G   D 3238069248 + 1024 
[mkfs.xfs]
259,1   10     1100     0.379786562  4801  I   D 3238069248 + 1024 
[mkfs.xfs]
259,1   10     1101     0.379800116  2307  D   D 3238069248 + 1024 
[kworker/10:1H]
259,1   10     1102     0.379829822  4801  Q   D 3238070272 + 1024 
[mkfs.xfs]
259,1   10     1103     0.379830156  4801  G   D 3238070272 + 1024 
[mkfs.xfs]
259,1   10     1104     0.379831015  4801  I   D 3238070272 + 1024 
[mkfs.xfs]
259,1   10     1105     0.379844120  2307  D   D 3238070272 + 1024 
[kworker/10:1H]
259,1   10     1106     0.379877825  4801  Q   D 3238071296 + 1024 
[mkfs.xfs]
259,1   10     1107     0.379878173  4801  G   D 3238071296 + 1024 
[mkfs.xfs]
259,1   10     1108     0.379879028  4801  I   D 3238071296 + 1024 
[mkfs.xfs]
259,1    1      591     0.379886451     0  C   D 3231851520 + 1024 [0]
259,1   10     1109     0.379898178  2307  D   D 3238071296 + 1024 
[kworker/10:1H]
259,1   10     1110     0.379923982  4801  Q   D 3238072320 + 1024 
[mkfs.xfs]
259,1   10     1111     0.379924229  4801  G   D 3238072320 + 1024 
[mkfs.xfs]
259,1   10     1112     0.379925054  4801  I   D 3238072320 + 1024 
[mkfs.xfs]
259,1   10     1113     0.379937716  2307  D   D 3238072320 + 1024 
[kworker/10:1H]
259,1    1      592     0.379954380     0  C   D 3231852544 + 1024 [0]
259,1   10     1114     0.379970091  4801  Q   D 3238073344 + 1024 
[mkfs.xfs]
259,1   10     1115     0.379970341  4801  G   D 3238073344 + 1024 
[mkfs.xfs]
259,1   10     1116     0.379971260  4801  I   D 3238073344 + 1024 
[mkfs.xfs]
259,1   10     1117     0.379984303  2307  D   D 3238073344 + 1024 
[kworker/10:1H]
259,1   10     1118     0.380014754  4801  Q   D 3238074368 + 1024 
[mkfs.xfs]
259,1   10     1119     0.380015075  4801  G   D 3238074368 + 1024 
[mkfs.xfs]
259,1   10     1120     0.380015903  4801  I   D 3238074368 + 1024 
[mkfs.xfs]
259,1   10     1121     0.380028655  2307  D   D 3238074368 + 1024 
[kworker/10:1H]
259,1    2      170     0.380054279     0  C   D 3218706432 + 1024 [0]
259,1   10     1122     0.380060773  4801  Q   D 3238075392 + 1024 
[mkfs.xfs]
259,1   10     1123     0.380061024  4801  G   D 3238075392 + 1024 
[mkfs.xfs]
259,1   10     1124     0.380062093  4801  I   D 3238075392 + 1024 
[mkfs.xfs]
259,1   10     1125     0.380072940  2307  D   D 3238075392 + 1024 
[kworker/10:1H]
259,1   10     1126     0.380107437  4801  Q   D 3238076416 + 1024 
[mkfs.xfs]
259,1   10     1127     0.380107882  4801  G   D 3238076416 + 1024 
[mkfs.xfs]
259,1   10     1128     0.380109258  4801  I   D 3238076416 + 1024 
[mkfs.xfs]
259,1   10     1129     0.380123914  2307  D   D 3238076416 + 1024 
[kworker/10:1H]
259,1    2      171     0.380130823     0  C   D 3218707456 + 1024 [0]
259,1   10     1130     0.380156971  4801  Q   D 3238077440 + 1024 
[mkfs.xfs]
259,1   10     1131     0.380157308  4801  G   D 3238077440 + 1024 
[mkfs.xfs]
259,1   10     1132     0.380158354  4801  I   D 3238077440 + 1024 
[mkfs.xfs]
259,1   10     1133     0.380168948  2307  D   D 3238077440 + 1024 
[kworker/10:1H]
259,1    2      172     0.380186647     0  C   D 3218708480 + 1024 [0]
259,1   10     1134     0.380197495  4801  Q   D 3238078464 + 1024 
[mkfs.xfs]
259,1   10     1135     0.380197848  4801  G   D 3238078464 + 1024 
[mkfs.xfs]
259,1   10     1136     0.380198724  4801  I   D 3238078464 + 1024 
[mkfs.xfs]
259,1   10     1137     0.380202964  2307  D   D 3238078464 + 1024 
[kworker/10:1H]
259,1   10     1138     0.380237133  4801  Q   D 3238079488 + 1024 
[mkfs.xfs]
259,1   10     1139     0.380237393  4801  G   D 3238079488 + 1024 
[mkfs.xfs]
259,1   10     1140     0.380238333  4801  I   D 3238079488 + 1024 
[mkfs.xfs]
259,1   10     1141     0.380252580  2307  D   D 3238079488 + 1024 
[kworker/10:1H]
259,1    2      173     0.380260605     0  C   D 3218709504 + 1024 [0]
259,1   10     1142     0.380283800  4801  Q   D 3238080512 + 1024 
[mkfs.xfs]
259,1   10     1143     0.380284158  4801  G   D 3238080512 + 1024 
[mkfs.xfs]
259,1   10     1144     0.380285150  4801  I   D 3238080512 + 1024 
[mkfs.xfs]
259,1   10     1145     0.380297127  2307  D   D 3238080512 + 1024 
[kworker/10:1H]
259,1   10     1146     0.380324340  4801  Q   D 3238081536 + 1024 
[mkfs.xfs]
259,1   10     1147     0.380324648  4801  G   D 3238081536 + 1024 
[mkfs.xfs]
259,1   10     1148     0.380325663  4801  I   D 3238081536 + 1024 
[mkfs.xfs]
259,1    2      174     0.380328083     0  C   D 3218710528 + 1024 [0]


So we see these one-megabyte requests; moreover, they are issued 
sequentially.


> There's a metric f tonne of bugs in this area so before anything I'd
> consider researching if there's a firmware update for your hardware
> and applying that and retesting.

I don't have access to that machine any more (I could get some with a 
bit of trouble).  But I think it's clear from the traces that the 
problem is in the RAID layer?

>   And then also after testing your
> ideal deployed version, use something much close to upstream (Arch or
> Fedora) and see if the problem is reproducible.

I'm hoping the RAID maintainers can confirm at a glance whether the 
problem exists or not, it doesn't look like a minor glitch but simply 
that this code path doesn't take the issue into account.

