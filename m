From: kclair <kclair@gmail.com>
Subject: Re: adding a disk smaller than the array size
Date: Thu, 14 Oct 2004 16:29:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <dff3752704101413296326ff89@mail.gmail.com>
References: <dff3752704101313303d344fb8@mail.gmail.com>
	 <200410132254.22483.maarten@ultratux.net>
	 <dff375270410131406572e5ec8@mail.gmail.com>
	 <200410140008.23084.maarten@ultratux.net>
	 <20041013224643.GA9601@jim.sh>
Reply-To: kclair <kclair@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041013224643.GA9601@jim.sh>
To: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Oct 2004 18:46:43 -0400, Jim Paris <jim@jtan.com> wrote:
> > And failing everything, you could (maybe) clone the array-disk to the empty
> > smaller one, run fsck to fix the partition size (but I'm not totally sure it
> > does, so that remains doubtful), reverse the roles of the two disks and then
> > add the -now free- larger disk to the array. But that would be a last resort.
> > I cannot vouch for how md copes with the few missing sectors, and neither how
> > the filesystem reacts, so you'd better not try that without good testing.
> 
> Or just do this same thing at the filesystem level.
> 
> Right now you have md0 with one missing disk.  Use your new disk to
> create md1 with one missing disk.  Create filesystem on md1, and copy
> files with e.g. tar, rsync, etc.  Then get rid of md0 and add that
> drive to md1.
> 
> -jim
> 

Thanks for all the info and the suggestions.  The key factor here was
that I could not just build an array with one disk containing the data
and one unformatted disk and hope they would sync up.  I followed
Jim's advice successfully ... except that mdadm reports that the new
array is State: dirty.
But at least the data is accessible once again!

Kristina
