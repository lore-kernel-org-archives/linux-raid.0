From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Fw: Raid1 questions (devel)
Date: Thu, 16 Sep 2004 08:49:16 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16712.50924.483830.802259@cse.unsw.edu.au>
References: <001601c49b69$e4e809e0$6400a8c0@alex>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex on Thursday September 16
To: Alex <alexcos@nights.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 16, alexcos@nights.ro wrote:
> > > Hello..
> > >
> > > I'm not sure if you are still developing the raid1 module for linux
> kernel , but I'll give a shot.
> > >
> > > Checking the source code of linux.2.6.8.1 , in raid1.c , at line 411 I
> found this:
> > >     "Don't change to another disk for sequential reads"
> > >
> > > Well , my question is this:
> > >
> > >     If there is a sequential read , but there are other disks in the
> array which are idle , isn't it a better way to read in chunks from all the
> disks ?  I think the transfer rate will be much improved from reading from
> more disks , rather the using only one  (altough is sequential read)

You may be right.

Why don't you try changing the code to do different things, and test
each variation and see what works the fastest for you.  If it is fast
for other people as well, your change will probably be accepted.

NeilBrown
