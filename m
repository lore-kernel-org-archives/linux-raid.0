From: Bruce Dubbs <bruce.dubbs@gmail.com>
Subject: Re: mdadm-3.4 regression tests
Date: Tue, 16 Feb 2016 12:24:30 -0600
Message-ID: <56C3695E.5030508@gmail.com>
References: <56C2AC87.7000500@gmail.com> <wrfjio1oczlj.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjio1oczlj.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jes Sorensen wrote:
> Bruce Dubbs <bruce.dubbs@gmail.com> writes:
>> I have a problem when trying to document madam-3.4 for the Linux From
>> Scratch project.  The package builds fine:
>>
>> tar -xf mdadm-3.4.tar.xz
>> cd mdadm-3.4
>> make
>> make test
>>
>> Then when I run:
>>
>> sudo ./test --keep-going --logdir=test-logs --save-logs
>>
>> Some tests fail and one hangs forever.  I can post logs if needed.
>>
>> Please run './test' as root
>> Testing on linux-4.4.1-lfs-7.9-rc1 kernel
>> Saving logs to test-logs
>> tests/00linear... succeeded
>> tests/00multipath... succeeded
>> tests/00names... succeeded
>> tests/00raid0... succeeded
>> tests/00raid1... FAILED - see test-logs/log-00raid1 for details
>> cp: cannot stat '/var/tmp/log': No such file or directory
>
> Do you have a proper /var/tmp on that system?

I'm not sure what you mean by 'proper', but I have

$ ls -ld /var/tmp
drwxrwxrwt 2 root root 4096 Feb 15 22:45 /var/tmp

I'm not concerned about the missing '/var/tmp/log' because I think the 
failure triggers a mv to test-logs/log-00raid1 and the message is the 
result of a subsequent mv command at the end of the test execution loop.

'/var/tmp/log' does exist while the test is running.

>> tests/00raid10... succeeded
>> tests/00raid4... succeeded
>> tests/00raid5... succeeded
>> tests/00raid6... succeeded
>> tests/01r1fail... succeeded
>> tests/01r5fail... succeeded
>> tests/01r5integ... succeeded
>> tests/01raid6integ... succeeded
>> tests/01replace...
>>
>> The failure says:
>>
>> ++ case $* in
>> ++ udevadm settle
>> +++ cat /proc/sys/dev/raid/speed_limit_max
>> ++ p=2000
>> ++ echo 20000
>> ++ case $* in
>> ++ /tmp/mdadm/mdadm-3.4/mdadm --quiet -S /dev/md0
>> ++ rv=1
>> ++ case $* in
>> ++ udevadm settle
>> ++ echo 2000
>> ++ cat /var/tmp/stderr
>> ++ return 1
>> ++ mdadm -B /dev/md0 -l 1 --assume-clean -n2 /dev/loop0 /dev/loop1
>> ++ rm -f /var/tmp/stderr
>> ++ case $* in
>> ++ case $* in
>> ++ /tmp/mdadm/mdadm-3.4/mdadm --quiet -B /dev/md0 -l 1 --assume-clean
>> -n2 /dev/loop0 /dev/loop1
>> ++ rv=1
>>
>> ...
>>
>> The bigger problem is that 01replace hangs forever.  Looking at my
>> process list:
>> root     16064     2  0 22:45 ?        00:00:00 [md0_raid1]
>> root     16093 16049  0 22:45 pts/1    00:00:00
>> /tmp/mdadm/mdadm-3.4/mdadm --quiet /dev/md0 --remove /dev/loop1
>>
>> The --remove operation never completes.
>>
>> $ cat /proc/mdstat
>> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] [linear] [raid0]
>> md0 : active raid1 loop5[5] loop4[4](S) loop3[3] loop2[2] loop1[1](F) loop0[0]
>>        19968 blocks super 1.2 [4/4] [UUUU]
>>
>> Can someone help me figure out why the regression tests give these
>> problems.  kernel issue?  test program issue?  internal issue?
>>
>> The kernel was built with:
>>
>> CONFIG_MD_AUTODETECT=y
>> CONFIG_MD_LINEAR=m
>> CONFIG_MD_RAID0=m
>> CONFIG_MD_RAID1=y
>> CONFIG_MD_RAID10=y
>> CONFIG_MD_RAID456=y
>> # CONFIG_MD_MULTIPATH is not set
>> # CONFIG_MD_FAULTY is not set
>>
>> Are there other options needed?
>>
>> Thanks for any help.
>
> Nobody here have a clue what kernel you are running - giving us a
> snippet of the .config and no detail about the kernel version is rather
> useless.

I guess you just missed it.  The log above says:

Testing on linux-4.4.1-lfs-7.9-rc1 kernel

The full config is at:

http://anduin.linuxfromscratch.org/~bdubbs/files/config-lfs-7.9-rc1

Thanks for responding.

   -- Bruce




