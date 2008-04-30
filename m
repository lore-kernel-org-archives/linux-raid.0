From: "Greg Cormier" <gcormier@gmail.com>
Subject: Sleeping hard drives in an array?
Date: Wed, 30 Apr 2008 11:02:31 -0400
Message-ID: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is it possible to sleep hard drives in an array?

I have a HTPC at home that's on 24x7. It does all my torrenting as
well, and is mainly a media server.

Can I sleep the drives in my RAID5 array while it's not being used?
It's an XFS partition.

I have each drive set as

hdparm -S240 /dev/sdX

But I'm fairly sure they are not spinning down :( Is there some
activity mdadm is doing in the background?

These things are probably idle 22 hours of the day.


Thanks,
Greg
