From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Sat, 31 Dec 2011 15:53:23 +0000
Message-ID: <4EFF2FF3.1080204@anonymous.org.uk>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com> <4EFD5928.100@fnarfbargle.com> <4085BCC9-B901-4D96-B530-4D580A162D20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4085BCC9-B901-4D96-B530-4D580A162D20@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michele Codutti <codutti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/12/2011 21:04, Michele Codutti wrote:
[...]
> This is one of many similar outputs from iostat -x 5 from the initial rebuilding phase:
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             0.00    0.00   13.29    0.00    0.00   86.71
> Device: rrqm/s  wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz await r_await w_await svctm %util
> sda    6585.60    0.00 4439.20    0.00 44099.20     0.00    19.87     6.14  1.38    1.38    0.00  0.09 39.28
> sdb    6280.40    0.00 4746.60    0.00 44108.00     0.00    18.59     5.20  1.10    1.10    0.00  0.07 35.04
> sdc       0.00 9895.40    0.00 1120.80     0.00 44152.80    78.79    12.03 10.73    0.00   10.73  0.82 92.32
> I also build a RAID6 (with one drive missing): same results.

Hang on, are you saying you see the 40MB/s speeds during the initial 
rebuilding phase? Yes, you will get those results. You are seeing 
degraded mode performance in the RAID5 just as you are in the RAID6 with 
a missing drive. When the array is fully built, which may well take a 
day or two, you can expect better. Check /proc/mdstat for the progress 
of the initial build.

If you happen to know that your array is already in sync (which three 
brand new all-zero drives would be for RAID5), or want to test without 
waiting for a rebuild, you can use --assume-clean when creating the array.

Cheers,

John.

