From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: RAID1 Mirroring question.
Date: Tue, 06 Apr 2004 11:29:16 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87brm5nbbn.fsf@enki.rimspace.net>
References: <E1BAVLe-0001EM-00@intern.SerNet.DE> <Pine.LNX.4.44.0404051242480.13902-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 5 Apr 2004, Mark Hahn wrote:
>> We have a Linux Software RAID1 (mirroring). If there is a little
>> error on one of the disks (such a little error that the kernel dosn't
>> recognize it). There is a read request on the raid for a specific
>> file. The output of one of the disks differ from the output of the
>> other disk. (But there are no errors recognized by the kernel / fs /
>> raid-driver. Only one inverted bit for example) What is RAID/MD
>> doing? Are there checksums for the original file?

[...]

> then again, raid1 is a sort of ugly niche feature, IMO.  how many 
> systems can afford two but not three disks?  raid5 is not scary!

*blink*  Quite a few systems don't have the capacity for three-disk
rather than two-disk RAID.  My laptop, for example, could not add a
third disk at all.

Also, RAID-5 does not have *any* improvement over RAID-1 in terms of
detecting this sort of single-disk unreported error.

RAID-5 also has a higher cost in terms of CPU use - enough that it
presents problems in a number of embedded system scenarios where RAID-1
is fine.

Three disk RAID-1, on the other hand, does allow you to detect a single
device failure by a "two to one vote" detection system...

       Daniel

-- 
About the use of language: it is impossible to sharpen a pencil with a
blunt ax. It is equally vain to try to do it with ten blunt axes instead.
        -- Edsger Dijkstra

