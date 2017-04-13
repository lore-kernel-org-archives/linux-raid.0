From: d tbsky <tbskyd@gmail.com>
Subject: disk initialize priority
Date: Thu, 13 Apr 2017 16:13:41 +0800
Message-ID: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi:
     I just tried to install rhel 7.3 on a 4 disk raid6. it's a
minimal install but took 3 hours to finish. I found the disk
initialize speed is around 150MB/sec. in past the disk initialize
speed will down to slow speed when there are other disk IO, but it
seems not the case in rhel 7.3.

    I have check the below parameter:
    cat /proc/sys/dev/raid/speed_limit_min  -> 1000
    cat /proc/sys/dev/raid/speed_limit_max -> 200000

    when the system is idle, the init speed is also about 150M/sec, so
the system is use all the power to init when there are other disk IO.

     is it normal? where should I check?

     thanks a lot for help!!


Regards,
tbskyd
