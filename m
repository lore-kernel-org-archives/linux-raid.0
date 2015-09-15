From: Alex <mysqlstudent@gmail.com>
Subject: Re: Recommendations for RAID setup needed
Date: Tue, 15 Sep 2015 14:44:58 -0400
Message-ID: <CAB1R3sj3fA3rJA+hQRJcTvL6HmNium+T2RRfdvF9YhpLA=q2Vg@mail.gmail.com>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
	<55F85E9F.1070100@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F85E9F.1070100@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

>> I have a fedora22 system and would like to build a backup server. I
>> have four 3TB SATA disks and would like to build a RAID5 array. I
>> understand rebuild times can be extensive, possibility creating a
>> scenario where another disk fails during that rebuild time, but I'm
>> not sure I want to lose the extra space with creating a RAID6 array. I
>> believe RAID5 also has faster write speeds?
>
> What disks are you using? Are they proper raid disks? A 12TB array can
> have a soft read error every complete pass, and still be within the
> disk-manufacturer's specs. If your disks are not raid-compliant, this
> will stop your array from rebuilding, ever!

All four are WD30EFRX-68EUZN0. They're not the cheapest WD disks, but
they're also not the ones with the 5yr warranty. The last array I
built using disks with 5yr warranty exceeded their capacity before the
warranty expired.

> (Chances are, your disks are above spec and won't give a problem. Do you
> want to take the risk?)

There's always going to be some kind of risk, but I'm hoping someone
with the technical understanding about disk failure rates can tell me
if it's a prudent decision or not.

>> Is a 9TB RAID5 partition too risky in terms of rebuild time?
>>
>> What's the preferred filesystem for a backup server these days? Should
>> I use XFS or ext4?
>
> Throwing something completely different into the mix, how about
> considering btrfs? It's not 100% solid yet, so you need to be careful
> with it, but if you back up with rsync and the "in place" option, it'll
> give you full backups for the cost of incremental.

I'm not sure I'm ready for something so experimental.

I am in fact using the hard-link function of rsync to perform backups,
though. We have a pretty robust perl script that's evolved over time.
I was also thinking of implementing bacula, but not sure I have the
time to figure it out right now.

Thanks,
Alex
