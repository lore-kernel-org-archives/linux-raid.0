From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Software RAID1 problem (bad superblock?)
Date: 28 Jan 2003 19:06:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yq1el6wvmyf.fsf@austin.mkp.net>
References: <Pine.SOL.4.33.0301281038380.24659-100000@acmez.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.SOL.4.33.0301281038380.24659-100000@acmez.gatech.edu>
To: Eric Drew Hollins <gte275e@mail.gatech.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Eric" == Eric Drew Hollins <gte275e@mail.gatech.edu> writes:

Eric> /dev/md0: THe filesystem size (according to the superblock) is
Eric> 14658328 blocks.  THe physical size of the device is 14658304
Eric> blocks.  

Creating a filesystem on a partition and then making it part of a
mirror won't work.  MD will put its superblock at the end of the
partition and shrink the space visible to the filesystem a bit.

If you are creating a new filesystem and know you are going to mirror
it later, you can specify how many blocks the filesystem should occupy
on the mkfs command line. Leave some space for the MD superblock at
the end.

Or - if you have an existing filesystem - use resize2fs to chop off a
few blocks before making the partition an MD component.

-- 
Martin K. Petersen	Wild Open Source, Inc.
mkp@wildopensource.com	http://www.wildopensource.com/

