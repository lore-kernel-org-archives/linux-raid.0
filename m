From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID-6 with 3 missing disks
Date: Sat, 4 May 2013 18:08:04 +0200
Message-ID: <20130504160804.GA2242@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I know this was probably already discussed, but
maybe I need some refresh.

I've a 10 HDDs RAID-6 which, due to mishap (disks
were disconnected accidentaly), has now 3 missing
devices and cannot be assembled.
The data should be OK, since no writes were occurring
during the accident, so putting them together again
should work.

As far as I know, one option is to create, with
"mdadm -C" the array again, giving the disks in
the proper order.

Since all HDDs are readable, I guess "mdadm -E"
should return the role of each device.
Is this correct for the creation order?

Second question is about the "Data Offset", since
this array was created with an older version of
"mdadm" and the data offset is very close to the
superblock.
As far as I know, new mdadm creates the data a
bit far aways.
Is there any way to specifiy the proper offset?

Finally, is there an alternative to "mdadm -C"
or it is the only option?
Forcing assembly does not work, but maybe there
is another way to tell mdadm to really assemby
the array, taking into account the superblock
information, which are all readable.

Thanks a lot in advance,

bye,

-- 

piergiorgio
