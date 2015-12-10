From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 13:26:42 -0600
Message-ID: <CAE9DZUQsNmsuk=7PjFwvADNj6KdifWt_5qArbhme3f5EmViqyA@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<22121.38606.101474.41382@quad.stoffel.home>
	<CAE9DZUTO-Muvgp+ofAkoKD1KcunnZ821UeSJch4216iWYL61cQ@mail.gmail.com>
	<CAK2H+ed+fe5Wr0B=h5AzK5_=ougQtW_6cJcUG_S_cg+WfzDb=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ed+fe5Wr0B=h5AzK5_=ougQtW_6cJcUG_S_cg+WfzDb=Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 12:54 PM, Mark Knecht <markknecht@gmail.com> wrote:
>
>
> On Thu, Dec 10, 2015 at 10:40 AM, Dallas Clement
> <dallas.a.clement@gmail.com> wrote:
>>
>> <SNIP>
>>
>> Hi John.  Thanks for the help.  I did what you recommended and created
>> two equal size partitions on my Hitachi 4TB 7200RPM SATA disks.
>>
>> Device          Start        End    Sectors  Size Type
>> /dev/sda1        2048 3907014656 3907012609  1.8T Linux filesystem
>> /dev/sda2  3907016704 7814037134 3907020431  1.8T Linux filesystem
>>
>
> If you're goal was to test the speed at the end of the drive it seems to me
> that sda2
> should have started near the end of the drive and not presumably in the
> middle?
>
> Probably has nothing to do with the missing 100MB/s though.
>
> - Mark

I tried a more extreme case.

Device          Start        End    Sectors   Size Type
/dev/sda1        2048 6999998464 6999996417   3.3T Linux filesystem
/dev/sda2  7000000512 7814037134  814036623 388.2G Linux filesystem

Now I'm seeing quite a bit more difference between inner and outer.

[root@localhost ~]# dd if=/dev/zero of=/dev/sda1 bs=2048k count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB) copied, 13.4422 s, 156 MB/s

[root@localhost ~]# dd if=/dev/zero of=/dev/sda2 bs=2048k count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB) copied, 21.9703 s, 95.5 MB/s

Using this this worst case inner speed my expected worst case write
speed is (12 - 2) * 95.5 MB/s / 2 = 477.5 MB/s.  So I guess if this
really is the worst case, then the 678 MB/s sequential write speed I
am seeing with RAID 6 on a large partition is not so bad.
