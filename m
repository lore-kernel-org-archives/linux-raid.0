From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: 6-drive RAID 10 failed, cannot reactivate, need help
Date: Mon, 2 May 2011 11:17:10 -0700
Message-ID: <BANLkTinz6bkqM+z7ddXZTOXFqjFHsEfEHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I have an Ubuntu Hardy 64-bit system with mdadm 2.6.9.

I have a 6-drive RAID 10 named md1. Unfortunately, there was some
power outage and when the system came back up, it showed 2 drives as
failed and 4 as active. I removed the two failed drives from the array
using -r, and then added them back in using --add and --force. The
array will not rebuild though. It simply shows now these two drives as
spares.

I doubt the data is actually lost since it was a sudden outage. What
can I do from here to get mdadm to activate this array and kick off
rebuild if needed? I'm really stuck. Thanks in advance for any help.

Best regards,
Tommy
