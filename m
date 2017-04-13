From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: disk initialize priority
Date: Thu, 13 Apr 2017 11:09:11 +0200
Message-ID: <43e44c4b-37d6-9734-b323-5b432ef27d52@thelounge.net>
References: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: d tbsky <tbskyd@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 13.04.2017 um 10:13 schrieb d tbsky:
> Hi:
>       I just tried to install rhel 7.3 on a 4 disk raid6. it's a
> minimal install but took 3 hours to finish. I found the disk
> initialize speed is around 150MB/sec. in past the disk initialize
> speed will down to slow speed when there are other disk IO, but it
> seems not the case in rhel 7.3.
> 
>      I have check the below parameter:
>      cat /proc/sys/dev/raid/speed_limit_min  -> 1000
>      cat /proc/sys/dev/raid/speed_limit_max -> 200000
> 
>      when the system is idle, the init speed is also about 150M/sec, so
> the system is use all the power to init when there are other disk IO.
> 
>       is it normal? where should I check?

sysctl.conf:
dev.raid.speed_limit_min = 10000
dev.raid.speed_limit_max = 50000

sysctl -p

and it will adjust itself within seconds - the same works if that values 
are too low and raid-check would take forever
