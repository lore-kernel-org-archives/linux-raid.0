From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Resize RAID-0?
Date: Thu, 11 Mar 2010 19:39:07 -0800
Message-ID: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From reading the documentation and source code, I gather "mdadm
--grow" is not supported for RAID-0 devices.

In my application, I am using md RAID-0 to stripe among several
(identical) hardware RAID-0 chassis.  I would like to extend my setup
by adding another chassis, but apparently, I cannot (?).

The next time I build a system like this, is there any way to get what
I want using Linux?  That is, striping among devices, no parity, but
with the ability to grow in the future?

Thanks!

 - Pat
