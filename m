From: Jim Paris <jim@jtan.com>
Subject: Re: adding a disk smaller than the array size
Date: Wed, 13 Oct 2004 18:46:43 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041013224643.GA9601@jim.sh>
References: <dff3752704101313303d344fb8@mail.gmail.com> <200410132254.22483.maarten@ultratux.net> <dff375270410131406572e5ec8@mail.gmail.com> <200410140008.23084.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200410140008.23084.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> And failing everything, you could (maybe) clone the array-disk to the empty 
> smaller one, run fsck to fix the partition size (but I'm not totally sure it 
> does, so that remains doubtful), reverse the roles of the two disks and then 
> add the -now free- larger disk to the array. But that would be a last resort.
> I cannot vouch for how md copes with the few missing sectors, and neither how 
> the filesystem reacts, so you'd better not try that without good testing.

Or just do this same thing at the filesystem level.

Right now you have md0 with one missing disk.  Use your new disk to
create md1 with one missing disk.  Create filesystem on md1, and copy
files with e.g. tar, rsync, etc.  Then get rid of md0 and add that
drive to md1.

-jim
