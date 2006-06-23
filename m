From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 10:06:02 -0600
Message-ID: <20060623160602.GK5817@schatzie.adilger.int>
References: <449AEB7C.6040108@cjx.com> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com> <200606231701.44803.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200606231701.44803.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Jun 23, 2006  17:01 +0300, Al Boldi wrote:
> Chris Allen wrote:
> > Francois Barre wrote:
> > > 2006/6/23, PFC <lists@peufeu.com>:
> > >>         - ext3 is slow if you have many files in one directory, but
> > >> has more mature tools (resize, recovery etc)

Please use "mke2fs -O dir_index" or "tune2fs -O dir_index" when testing
ext3 performance for many-files-in-dir.  This is now the default in
e2fsprogs-1.39 and later.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

