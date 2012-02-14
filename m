From: Robert Woodworth <robertjwoodworth@gmail.com>
Subject: SES Enclosure Management.
Date: Tue, 14 Feb 2012 10:30:37 -0700
Message-ID: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Has anyone ever thought of integrating SES managed enclosures into the
kernel RAID system?  I briefly looked through the archives and have
not found anything on the topic.

Some HW based RAID controllers do this flawlessly now, there is no
reason why the kernel RAID cannot also.  (LSI MegaRAID)

1) When a drive is part if a managed enclosure, the RAID system should
address it by location instead of by enumerated device node.  The SES
device in the enclosure can map the physical slot to a physical drive.
 The RAID admin (mdamd) should be able to add/fail/identify devices
based on slot.

2) If the RAID system fails a drive, it should notify the SES
management and turn on the fail bit and the fail LED.

3) The RAID system should be able to turn on the 'identify' bit and
LEDs for an array or a single drive.

I'm currently doing firmware on a managed enclosure.  Although my
vendor only supports LSI MegaRAID, there is no reason why my
enclosures cannot work in the same manner on a kernel RAID system.



Request for comments...
