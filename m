From: Kev Dorman <kdorman036@gmail.com>
Subject: Re: Start reshape failed
Date: Wed, 16 Dec 2015 02:47:18 -0500
Message-ID: <CAN4XXPD2bmrJKRBMm+3Rz4_pegBK4Qp37cn2O-TvEZZ8ww1bFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Xiao Ni posted back in September about a problem where mdadm --grow fails with:

mdadm: Failed to initiate reshape!

I'm seeing the same problem, with mdadm 3.3.4, Kernel 4.3.0.  I can
reproduce this reliably
when adding a device to a 2-device raid0 array.  Instead of switching
to raid4 for the
reshape, then switching back to raid0 when done, it ends up in raid4
in recovery mode.

I tried the suggested change of adding a call to md_check_recovery()
in action_store(),
and that does seem to help most of the time.

I was curious if there is a better solution, and/or if this or another
change will show up in
4.3.x soon.

Thanks.

Kev
