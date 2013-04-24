From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Thu, 25 Apr 2013 00:40:56 +0300
Message-ID: <51785168.8050200@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro> <51775078.3000500@hardwarefreak.com> <51779720.6040109@redhost.ro> <5177A1E7.8030701@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5177A1E7.8030701@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

1. free -m
root [~]# free -m
              total       used       free     shared    buffers cached
Mem:         15921      15542        379          0 1063      11870
-/+ buffers/cache:       2608      13313
Swap:         2046        100       1946

2. Yes, you understood correctly regarding the raid array (all 3 of them 
are raid 1):

root@gts6 [~]# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb2[1] sda2[0]
       204736 blocks super 1.0 [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       404750144 blocks super 1.0 [2/2] [UU]

md1 : active raid1 sdb1[1] sda1[0]
       2096064 blocks super 1.1 [2/2] [UU]

unused devices: <none>

md0 is boot.
md1 is swap.
md2 is /

3. df

root@gts6 [~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md2              380G  246G  116G  68% /
tmpfs                 7.8G     0  7.8G   0% /dev/shm
/dev/md0              194M   47M  137M  26% /boot
/usr/tmpDSK           3.6G  1.2G  2.2G  36% /tmp

4. pvs

root [~]# pvs -a
   PV         VG   Fmt Attr PSize PFree
   /dev/loop0          ---     0     0
   /dev/md0            ---     0     0
   /dev/md1            ---     0     0
   /dev/ram0           ---     0     0
   /dev/ram1           ---     0     0
   /dev/ram10          ---     0     0
   /dev/ram11          ---     0     0
   /dev/ram12          ---     0     0
   /dev/ram13          ---     0     0
   /dev/ram14          ---     0     0
   /dev/ram15          ---     0     0
   /dev/ram2           ---     0     0
   /dev/ram3           ---     0     0
   /dev/ram4           ---     0     0
   /dev/ram5           ---     0     0
   /dev/ram6           ---     0     0
   /dev/ram7           ---     0     0
   /dev/ram8           ---     0     0
   /dev/ram9           ---     0     0
   /dev/root           ---     0     0

5. lvs (No volume groups).

Thanks!

On 24/04/2013 12:12 PM, Adam Goryachev wrote:
> On 24/04/13 18:26, Andrei Banu wrote:
>> Hello,
>>
>> I am sorry for the irrelevant feedback. Where I misunderstood your
>> request, I filled in the blanks (poorly).
>>
>> 1. SWAP
>> root [~]# blkid | grep cef1d19d-2578-43db-9ffc-b6b70e227bfa
>> /dev/md1: UUID="cef1d19d-2578-43db-9ffc-b6b70e227bfa" TYPE="swap"
>>
>> So yes, swap is on md1. This *md1 has a size of 2GB*. Isn't this way
>> too low for a system with 16GB of memory?
>>
> Provide the output of "free", if there is RAM available, then it isn't
> too small (that is my personal opinion, but at least it won't affect
> performance/operations until you are using most of that swap space).
>
>> 3. root [~]# fdisk -lu /dev/sd*
>>
> My mistake, I should have said:
> fdisk -lu /dev/sd?
>
> In any case, all of the relevant information was included, so no harm done.
>> Disk /dev/sda: 512.1 GB, 512110190592 bytes
>> 255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00026d59
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1            2048     4196351     2097152   fd  Linux raid
>> autodetect
>> Partition 1 does not end on cylinder boundary.
>> /dev/sda2   *     4196352     4605951      204800   fd  Linux raid
>> autodetect
>> Partition 2 does not end on cylinder boundary.
>> /dev/sda3         4605952   814106623   404750336   fd  Linux raid
>> autodetect
>>
>> Disk /dev/sdb: 512.1 GB, 512110190592 bytes
>> 255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x0003dede
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1            2048     4196351     2097152   fd  Linux raid
>> autodetect
>> Partition 1 does not end on cylinder boundary.
>> /dev/sdb2   *     4196352     4605951      204800   fd  Linux raid
>> autodetect
>> Partition 2 does not end on cylinder boundary.
>> /dev/sdb3         4605952   814106623   404750336   fd  Linux raid
>> autodetect
>>
> I'm assuming from this you have three md RAID1 arrays where sda1/sdb1
> are a pair, sda2/sdb2 are a pair and sda3/sdb3 are a pair?
>
> Can you describe what is on each of these arrays?
> Output of
> cat /proc/mdstat
> df
> pvs
> lvs
>
> Might be helpful....
>
> Regards,
> Adam
>

