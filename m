From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [PATCH] md: fix device size calculation with non-persistent
 superblock
Date: Tue, 24 Feb 2004 10:27:55 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403B6D7B.29A4B2A0@SteelEye.com>
References: <20040223024124.GA1590@psilocybus>
		<16441.33071.218049.163976@notabene.cse.unsw.edu.au>
		<403A30F9.D54AAC68@SteelEye.com> <16442.42303.445148.394516@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> On Monday February 23, Paul.Clements@SteelEye.com wrote:
> > Neil,
> >
> > Currently, the device size calculation is not correct when hot-adding
> > devices to arrays with non-persistent superblocks. Device size is always
> > calculated as if there were a physical superblock on every device. The
> > attached simple change to hot_add_disk() fixes the problem.
> 
> Hmm.. I had always assumed that non-persistent superblocks only worked
> for linear and raid0.  I'm not sure I would trust any other
> configuration.
> 
> Are you seriously using raid1 with non-persistent superblocks?  

Yes, and this works fine in 2.4, as well. We opted for non-persistent
superblocks in order to support creation of raid1 mirrors over
partitions that already had filesystems or other data present (and yes,
we calculate the size of the new md device to make sure the existing
data will fit).


> How do you ensure reliable re-assembly after a device failure followed by
> shutdown?

There is a user-level clustering framework that sets up, monitors, and
takes down the mirror. Disk failures and other events are handled by
this framework.

--
Paul
