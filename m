From: dong wu <dongwucs@gmail.com>
Subject: why is md/raid5 sequential write speed so slow?
Date: Fri, 8 Jan 2010 13:19:46 +0800
Message-ID: <6c394cc31001072119l2619d8aap627164d34eec6806@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have made a test in my server!
raid5 capacity:80G,  disks:9
IO type                        IOPS                   speed(M/s)
1024k seq write            40.67                   40.67
512k seq write              70.89                   39.45
256k seq write             36.02                    34.00
128k seq write             134.19                   16.77
64k seq write               232.26                   14.52
32k seq write              160.23                    5.01
16k seq write              148.48                    2.32
8k seq write                151.05                   1.18
4k seq write                151.39                   0.59
2k seq write                 290.90                  0.57
1k seq write                 526.21                  0.51
512B seq write             1076.60                0.53

I don't know why raid5 seq write is so slow.
Does delaying write cause this?


Best Regards
Dong Wu
