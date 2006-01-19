From: "Filipe Maia" <fmaia@gmx.net>
Subject: Handling of read errors in raid6
Date: Thu, 19 Jan 2006 13:02:36 +0100
Message-ID: <op.s3mjqms2i22er4@xray.bmc.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is it easy to port the "readerrors rewrite" patch to RAID6?

Are there any plans to do it?

If there are are they short or long term?

(I have some stuff in a RAID6 that has more than 2 disks with
bad sectors and i would like to see if it would be possible to
recover them without going through all the dd stuff).

Thanks for the help.


-- 
All generalizations are false, including this one.
          -- Mark Twain
