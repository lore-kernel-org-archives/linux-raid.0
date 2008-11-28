From: "NeilBrown" <neilb@suse.de>
Subject: Re: Uncorrectable errors: how do I fix it?
Date: Sat, 29 Nov 2008 08:53:23 +1100 (EST)
Message-ID: <f7aa19cbda5aee2fc3af5e24296b78f7.squirrel@neil.brown.name>
References: <493036A0.10707@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493036A0.10707@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, November 29, 2008 5:21 am, John Robinson wrote:
> One of the drives in my RAID-5 array is showing uncorrectable errors:
> Nov 28 17:52:36 beast smartd[8184]: Device: /dev/sdc, 1 Currently
> unreadable (pending) sectors
> Nov 28 17:52:36 beast smartd[8184]: Device: /dev/sdc, 1 Offline
> uncorrectable sectors
>
> And it fails a self-test:
> SMART Self-test log structure revision number 0
> Warning: ATA Specification requires self-test log structure revision
> number = 1
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Short offline       Completed: read failure       20%       931
>    1953520763
>
> Now that's not good but it's probably not bad enough to get the drive
> replaced. (Opinions?) Anyway, rewriting the sector ought to "cure" it,
> so how do I do that?
..
> I tried:
> [root@beast md]# mdadm /dev/md1 --fail /dev/sdc2
> mdadm: set /dev/sdc2 faulty in /dev/md1
> [root@beast md]# mdadm /dev/md1 --remove /dev/sdc2
> mdadm: hot removed /dev/sdc2
> [root@beast md]# mdadm /dev/md1 --add /dev/sdc2
> mdadm: re-added /dev/sdc2
>
> but that finished instantly. I guess it would since the array has a
> write-intent bitmap and it's noticed that sdc2 is being re-added. I
> could tell the system to do a complete resync with:
> # echo repair > /sys/block/md1/md/sync_action
>
> but really I want to tell the system to rebuild entirely from sda2 and
> sdb2, onto sdc2. At least I think I do. I've a feeling the answer is to
> zero the superblock, but I'm not confident about doing that because I'm
> not sure if re-adding the thing without a superblock will either work or
> do the Right Thing[tm].

I would recommend the "echo repair" approach.  It won't write every block
on sdc, but you don't really need that.
And if you hit a bad block on some other drive, it will cope much better
than removing a drive and adding it back in.

However if you really want to write all of sdc and you are willing to
risk the possibility of a bad block on sda or sdb, then zeroing the
superblock on sdc before adding it back in will do what you expect.

The suggestion made by Justin of always having backups is, of course,
a good one.


NeilBrown


