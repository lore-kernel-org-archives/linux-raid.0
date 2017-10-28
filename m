From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Sat, 28 Oct 2017 12:31:00 -0700
Message-ID: <CAK2H+efan_JOna02sd-EO75ZPadkYWEdRNz2keKp9CWXZxSeGA@mail.gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <CAK2H+efGBYmnPUL2gKqAQ=RRkFBZmBUw8fBcr0efgyb+L7YORA@mail.gmail.com>
 <CAA4aoFY=AK5SMasoRGJEzK=kAVuyJjqQeDu0Fm2mk28juCVXVw@mail.gmail.com> <CAA4aoFZxAidceW2duxf-C1nTw429ZOW76WD-UneUSS6e4MPJYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA4aoFZxAidceW2duxf-C1nTw429ZOW76WD-UneUSS6e4MPJYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 28, 2017 at 12:10 PM, Jun-Kai Teoh <kai.teoh@gmail.com> wrote:
> The array did have data in it when I added a new drive to it, it
> wasn't a blank/empty array. I was trying to expand its size when my
> computer went down. I'm really hoping it can be rescued. =/
>
<SNIP>
I understand that the array had data. However, RAID5 can suffer 1 drive
being out of the array and still appear to be working.

1) Prior to adding the drive did you look at

cat /proc/mdstat

and note status of the original 7 drives?

2) Do you scrub your RAID routinely, as in a crontab entry or some
other method?

3) What kind of drives are these. smartctl output will help, ala:

c2RAID6 ~ # smartctl -a /dev/sda
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.12.12-gentoo] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD30EFRX-68EUZN0

Provide all smartctl output for all 8 drives

Just giving guidance to get you setup for a faster response when folks
come back after the weekend. I am not a RAID expert and won't
supply commands to get it working. At this time do NOT do anything
to force the array back together. More people seem to cause problems
trying to do that before getting input. Better that you wait.

Good luck,
Mark
