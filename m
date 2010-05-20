From: "Keith ." <lukano@gmail.com>
Subject: Shrink mdadm RAID5 from 6 disks to 5?
Date: Thu, 20 May 2010 07:45:23 -0600
Message-ID: <AANLkTimSxarJKmCxfOkJZJJULplm0z1pbVKyQpCG6nEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does mdadm 3.1.x not support shrinking the number of disks in a RAID5 array?

I have successfully converted my 6x1.5tb RAID6 array to a 6x1.5tb
RAID5 array.  The issue that I now face is that one of those 6 drives
is failed / removed, and as a result - the new RAID5 array is down
it's parity drive.

I knew I was short a disk when I started the process, but I was under
the assumption that mdadm now supported shrinking of RAID5/6 arrays.
Am I mistaken, or can anyone throw some suggestions at me so I can
give it a try?

Thanks,

- Keith
