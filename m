From: "Max Waterman" <davidmaxwaterman@fastmail.co.uk>
Subject: OT:backup
Date: Wed, 15 Oct 2008 09:35:34 +0300
Message-ID: <d5fe39840810142335m38807321o58c749aeffad9e3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Perhaps not *completely* unrelated, but anyway...

I have an MD RAID1 over two disks - works just fine. This provides
some protection against disk failure.

I am now wondering about protection against stupidity such as 'rm -rf;
oops'. I'm going to ignore other risks (eg fire) for now.

In this vain,  I've bought an external 500GB USB/FW drive and I plan
to use rdiff-backup <http://www.nongnu.org/rdiff-backup/> to back up
the contents of the RAID1 to that. I think this buys me some
protection.

My question is - what is the best way to ensure that, in future, I can
easily expand the filesystem on the external drive, so that it is
transparent to the host and doesn't require any copying/etc? My first
thoughts (from experience on MythTv) go to logical volumes - is this
what I should be looking at?

Thanks,

Max.
