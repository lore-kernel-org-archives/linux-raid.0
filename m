From: Zhilong Liu <zlliu@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Fri, 1 Sep 2017 17:49:07 +0800
Message-ID: <f5b52479-6191-3552-faa4-f36a79dd5b8f@suse.com>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com>
 <87y3q3gq8g.fsf@notabene.neil.brown.name>
 <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
 <87mv6jgj8z.fsf@notabene.neil.brown.name>
 <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com>
 <87k21mhcqw.fsf@notabene.neil.brown.name>
 <73429dce-a22d-149e-656a-13af228c093f@suse.com>
 <87r2vsfuom.fsf@notabene.neil.brown.name>
 <2d737c2f-69f4-672f-2b7c-4a279f70c3c3@suse.com>
 <87efrsfm7c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efrsfm7c.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/31/2017 11:30 AM, NeilBrown wrote:
> On Thu, Aug 31 2017, Zhilong Liu wrote:
>
>> On 08/31/2017 08:27 AM, NeilBrown wrote:
>>> On Wed, Aug 30 2017, Zhilong Liu wrote:
>>>
>>>> On 08/29/2017 06:47 PM, NeilBrown wrote:
>>>>> Thanks.  I see what I missed. Please try this patch instead.
>>>> Hi, Neil;
>>>>        I have tested the following patch, I still got the call-trace after
>>>> I built with it.
>>>> If you need other infos, I would append.
>>> Thanks for testing.
>>> I looked more completely and I think it is easiest just to disable the
>>> functionality rather than try to fix it.
>>> Resizing the file in the kernel is extra complexity that I don't
>>> want to get in to.
>>> We could adjust the bitmap chunk size so that the file doesn't
>>> need to grow, but it started getting more complicated than I really
>>> wanted to deal with.
>>> If there is anyone actually using file-backed bitmaps who wants to
>>> be able to resize the array without removing the bitmap first, then
>>> we can look at the problem again.  For now I've sent a patch which
>>> just returns an error instead of crashing when someone tries to resize
>>> an array with a file-backed bitmap.
>> Hi, Neil;
>>       Shall update the "SIZE CHANGES" under "GROW MODE" of man-page for
>> resize like following after kernel patch merged?
> Good idea, but it isn't just "--grow --size".  It is anything that
> changes the size of the array, which includes changing the number of
> devices in a RAID5 etc.  So a more general statement would be better.

I have tested the changing number of devices within your patch. Here are 
my steps,
and all works well.

1. create one raid1 with same size disks, loop[0-2], 2 active and 1 spare.
2. grow array to raid5.
3. "grow and add" new same size devices into raid5.
4. continue the step 3.
5. "grow and add" new lager size device into raid5.
6. continue step 5.
7. "manage and set failure" smaller disk in raid5.
8. "manage and remove" the failure disk from raid5.

Sorry for the long logs.

Thanks,
-Zhilong

linux-apta:~/mdadm-test # lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop1    7:1    0 19.5M  0 loop
loop13   7:13   0   64M  0 loop
loop11   7:11   0   64M  0 loop
loop8    7:8    0   64M  0 loop
loop6    7:6    0 19.5M  0 loop
loop4    7:4    0 19.5M  0 loop
loop2    7:2    0 19.5M  0 loop
loop0    7:0    0 19.5M  0 loop
loop12   7:12   0   64M  0 loop
loop9    7:9    0   64M  0 loop
loop10   7:10   0   64M  0 loop
sda      8:0    0   45G  0 disk
├─sda2   8:2    0   43G  0 part /
└─sda1   8:1    0    2G  0 part [SWAP]
loop7    7:7    0 19.5M  0 loop
loop5    7:5    0 19.5M  0 loop
loop3    7:3    0 19.5M  0 loop

linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1 
/dev/loop[0-2] --force
mdadm: /dev/loop0 appears to contain an ext2fs file system
        size=38912K  mtime=Wed Dec 31 19:00:00 1969
mdadm: Note: this array has metadata at the start and
     may not be suitable as a boot device.  If you plan to
     store '/boot' on this device please ensure that
     your boot-loader understands md/v1.x metadata, or use
     --metadata=0.90
mdadm: /dev/loop1 appears to contain an ext2fs file system
        size=19968K  mtime=Wed Dec 31 19:00:00 1969
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
       18944 blocks super 1.2 [2/2] [UU]
       bitmap: 2/3 pages [8KB], 4KB chunk, file: /mnt/3

unused devices: <none>

linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size max
mdadm: Cannot set device size for /dev/md0: Invalid argument
linux-apta:~/mdadm-test # dmesg
[ 2218.652119] md: md0: resync done.
[ 2235.258392] md: cannot resize file-based bitmap
[ 2235.325163] md: couldn't update array info. -22

linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 -l5
mdadm: level of /dev/md0 changed to raid5
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop0[0] loop2[2](S) loop1[1]
       18944 blocks super 1.2 level 5, 64k chunk, algorithm 2 [2/2] [UU]
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>


linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 -n3 -a /dev/loop3
mdadm: added /dev/loop3
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop3[3] loop0[0] loop2[2](S) loop1[1]
       18944 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       [======>..............]  reshape = 31.5% (6528/18944) 
finish=0.0min speed=3264K/sec
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>

linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop3[3] loop0[0] loop2[2](S) loop1[1]
       37888 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>

linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 -n4 -a /dev/loop4
mdadm: added /dev/loop4
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop4[4] loop3[3] loop0[0] loop2[2](S) loop1[1]
       37888 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
       [======>..............]  reshape = 31.5% (6272/18944) 
finish=0.1min speed=2090K/sec
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop4[4] loop3[3] loop0[0] loop2[2](S) loop1[1]
       56832 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>

linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 -n5 -a /dev/loop10
mdadm: added /dev/loop10
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop10[5] loop0[0] loop2[2](S) loop4[4] loop3[3] loop1[1]
       56832 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
       [==========>..........]  reshape = 52.6% (10240/18944) 
finish=0.0min speed=2560K/sec
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>

linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop10[5] loop0[0] loop2[2](S) loop4[4] loop3[3] loop1[1]
       75776 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>

linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 -n6 -a /dev/loop11
mdadm: added /dev/loop11
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop11[6] loop10[5] loop0[0] loop2[2](S) loop4[4] 
loop3[3] loop1[1]
       75776 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       [=====>...............]  reshape = 26.3% (5248/18944) 
finish=0.0min speed=2624K/sec
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>


linux-apta:~/mdadm-test # ./mdadm --manage /dev/md0 -f /dev/loop11
mdadm: set /dev/loop11 faulty in /dev/md0
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop11[6](F) loop10[5] loop0[0] loop2[2] loop4[4] 
loop3[3] loop1[1]
       94720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]
       [====>................]  recovery = 23.6% (4752/18944) 
finish=0.0min speed=2376K/sec
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop11[6](F) loop10[5] loop0[0] loop2[2] loop4[4] 
loop3[3] loop1[1]
       94720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # ./mdadm --manage /dev/md0 -r /dev/loop11
mdadm: hot removed /dev/loop11 from /dev/md0
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 loop10[5] loop0[0] loop2[2] loop4[4] loop3[3] loop1[1]
       94720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       bitmap: 0/3 pages [0KB], 4KB chunk, file: /mnt/3

unused devices: <none>


>
> NeilBrown
>
>> Thanks,
>> -Zhilong
>>
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index e0747fb..f0fd1fc 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -2758,6 +2758,11 @@ Also the size of an array cannot be changed while
>> it has an active
>>    bitmap.  If an array has a bitmap, it must be removed before the size
>>    can be changed. Once the change is complete a new bitmap can be created.
>>
>> +.PP
>> +Note:
>> +.B "--grow --size"
>> +is not yet supported for external file bitmap.
>> +
>>    .SS RAID\-DEVICES CHANGES
>>
>>    A RAID1 array can work with any number of devices from 1 upwards
>>
>>> Thanks,
>>> NeilBrown

