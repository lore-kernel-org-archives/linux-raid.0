From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Tue, 9 Jun 2020 11:36:12 +0200
Message-ID: <4df42e3d-ad2b-dfc2-3961-49ada4ea7eaf@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl>
 <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl>
 <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl>
 <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl>
 <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
 <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
 <1767d7aa-6c60-7efb-bf37-6506f9aaa8a2@yandex.pl>
 <CAPhsuW4oMKuCrHUU1ucsMKQbSfBQdsNEQWHA1SSbGR5nbvy21w@mail.gmail.com>
 <CAPhsuW4WBDGGLYc=f4xoThxtxuF5K74m3odJ-uA98DuPLJR4nw@mail.gmail.com>
 <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl>
 <CAPhsuW51u6KWLvUntMXPU7stu7oSA+d-yT6zf7G0zCETzLWwiA@mail.gmail.com>
 <49efa0d2-b44c-ec85-5e44-fb93a15001e7@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49efa0d2-b44c-ec85-5e44-fb93a15001e7@yandex.pl>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/5/20 2:26 PM, Michal Soltys wrote:
> On 6/4/20 12:07 AM, Song Liu wrote:
>>
>> The hang happens at expected place.
>>
>>> [Jun 3 09:02] INFO: task mdadm:2858 blocked for more than 120 seconds.
>>> [  +0.060545]       Tainted: G            E     
>>> 5.4.19-msl-00001-gbf39596faf12 #2
>>> [  +0.062932] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>> disables this message.
>>
>> Could you please try disable the timeout message with
>>
>> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
>>
>> And during this wait (after message
>> "r5c_recovery_flush_data_only_stripes before wait_event"),
>> checks whether the raid disks (not the journal disk) are taking IOs
>> (using tools like iostat).
>>
> 
> No activity on component drives.

To expand on that - while there is no i/o activity whatsoever at the component drives (as well as journal), the cpu is of course still fully loaded (5 days so far):

UID        PID  PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
root      8129  6755 15   740  1904  10 Jun04 pts/2    17:42:34 mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/sdj1 /dev/sdi1 /dev/sdg1 /dev/sdh1
root      8147     2 84     0     0  30 Jun04 ?        4-02:09:47 [md124_raid5]
