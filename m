From: Ankur Bose <ankur.bose@oracle.com>
Subject: Write intent bitmap algorithm
Date: Fri, 20 May 2016 00:03:03 -0700 (PDT)
Message-ID: <cd14f4dd-a88a-4089-9b07-f16a221e003c@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

     We are doing performance analysis of MD raid1 and wanted to know the flow/algorithm of the writes with write intent bitmap.
As per "man md" below lines gives the algo 

"Before  any write  request is honored, md will make sure that the corresponding bit in the log is set.  After a period of time with no writes to an area of the array, the corresponding bit will be cleared."

Here we wanted to know after what period of time and what is the logic to calculate this period of time which MD does ?

I see a function "void bitmap_daemon_work(struct mddev *mddev)" in bitmap.c file but trying to figure out the logic how it is used.

Thanks,
ankur.
