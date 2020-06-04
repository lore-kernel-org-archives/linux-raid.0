From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Thu, 4 Jun 2020 15:58:57 +0200
Message-ID: <775d2d2d-1064-9659-92dc-ec41c4f80443@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW51u6KWLvUntMXPU7stu7oSA+d-yT6zf7G0zCETzLWwiA@mail.gmail.com>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/4/20 12:07 AM, Song Liu wrote:
> 
> The hang happens at expected place.
> 
>> [Jun 3 09:02] INFO: task mdadm:2858 blocked for more than 120 seconds.
>> [  +0.060545]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
>> [  +0.062932] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
> Could you please try disable the timeout message with
> 
> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
> 
> And during this wait (after message
> "r5c_recovery_flush_data_only_stripes before wait_event"),
> checks whether the raid disks (not the journal disk) are taking IOs
> (using tools like iostat).
> 

Will report tommorow (machine was restarted, so gotta wait 19+ hours 
again until r5c_recovery_flush_log / processing gets its part of the job 
completed).

Non-assembling raid issue aside - any idea why is it so inhumanly slow ? 
It's not really much of an use in a production scenario in this state.

Following as every-10 seconds stats from journal device after the 
assembly of the main raid started.

Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
md125             3.00      3072.00         0.00      30720          0
md125             2.80      2867.20         0.00      28672          0
md125             2.10      2150.40         0.00      21504          0
md125             1.90      1945.60         0.00      19456          0
md125             2.00      1920.40         0.00      19204          0
md125             1.30      1331.20         0.00      13312          0
md125             1.50      1536.00         0.00      15360          0
