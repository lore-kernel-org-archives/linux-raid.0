From: "John Stoffel" <john@stoffel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 14:33:21 -0500
Message-ID: <22121.54145.780249.40226@quad.stoffel.home>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<22121.38606.101474.41382@quad.stoffel.home>
	<CAE9DZUTO-Muvgp+ofAkoKD1KcunnZ821UeSJch4216iWYL61cQ@mail.gmail.com>
	<CAK2H+ed+fe5Wr0B=h5AzK5_=ougQtW_6cJcUG_S_cg+WfzDb=Q@mail.gmail.com>
	<CAE9DZUQsNmsuk=7PjFwvADNj6KdifWt_5qArbhme3f5EmViqyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQsNmsuk=7PjFwvADNj6KdifWt_5qArbhme3f5EmViqyA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>, John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:

Dallas> I tried a more extreme case.

Dallas> Device          Start        End    Sectors   Size Type
Dallas> /dev/sda1        2048 6999998464 6999996417   3.3T Linux filesystem
Dallas> /dev/sda2  7000000512 7814037134  814036623 388.2G Linux filesystem

Dallas> Now I'm seeing quite a bit more difference between inner and outer.

Dallas> [root@localhost ~]# dd if=/dev/zero of=/dev/sda1 bs=2048k count=1000
Dallas> 1000+0 records in
Dallas> 1000+0 records out
Dallas> 2097152000 bytes (2.1 GB) copied, 13.4422 s, 156 MB/s

Dallas> [root@localhost ~]# dd if=/dev/zero of=/dev/sda2 bs=2048k count=1000
Dallas> 1000+0 records in
Dallas> 1000+0 records out
Dallas> 2097152000 bytes (2.1 GB) copied, 21.9703 s, 95.5 MB/s


This is actually one of the tricks people used to do before there was
ready availability of SSDs.  They would buy a bunch of disks and then
only use the outer tracks, while striping data across a whole bunch of
disks to get up the IOPs when they were IOP but not space limited.
Think databases with lots and lots of transactions.

Now it's simpler to just A) buy lots and lots of memory, B) bunches of
SSDs, C) both, D) beat the developers until they learn to write better
SQL.

Sorry, D) never happens.  :-)
