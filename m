From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Using LVM for RAID 1+0
Date: Tue, 18 Apr 2006 19:20:39 -0500
Message-ID: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Had though of setting up several disks as a RAID-5 array, but for some
reason one of the disks would keep failing when I tried to build the
array. The same disk, however, would format just fine with EXT3, and
is quite happy about being put in a RAID-1 array with another disk.
Given that strangeness, I'm thinking a better way to go is to pair off
my disks into several RAID-1 arrays, and then use LVM to setup
striping across all of them to effectively give me a RAID 1+0 setup.
Since one pair of disks is a different size than the other pairs, I
presumed this would be better than actually creating a RAID-0 across
all the RAID-1 arrays. Is that correct?
