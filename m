From: andyliebman@editshare.com
Subject: Still Need Help on mdadm and udev
Date: Wed, 9 Nov 2005 11:12:52 -0800 (PST)
Message-ID: <1200.146.115.27.35.1131563572.squirrel@webmail.editshare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay,

PLEASE somebody who knows answer the following:

1)  what is the difference between running

             mdadm -A -ayes 1/dev/md1--uuid=xxxxx /dev/sd*

    and

             mdadm -A -amd 1/dev/md1 --uuid=xxxxx /dev/sd*


    In other words, how do the "yes" and "md" options behave differently.


2)  If you create an array /dev/md0 with mdadm, is there any reason why
you shouldn't start it as /dev/md1?

The second option above (-amd 1) would NOT start an array that was created
as /dev/md0 (under an older mdadm -- 1.8.? ) whereas the first option
(-ayes /dev/md1) had no difficulty.

Thank you.
Andy Liebman





