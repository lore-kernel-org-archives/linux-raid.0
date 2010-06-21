From: Neil Brown <neilb@suse.de>
Subject: Re: md lock issue, I suppose
Date: Tue, 22 Jun 2010 08:22:33 +1000
Message-ID: <20100622082233.2015caee@notabene.brown>
References: <20100621204208.GA29830@lazy.lzy>
	<4C1FD4CF.20109@stud.tu-ilmenau.de>
	<20100621212521.GA31833@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100621212521.GA31833@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: st0ff@npl.de, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 21 Jun 2010 23:25:21 +0200
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Any other suggestions or ideas?
> 

You cannot use the BLKRRPART ioctl while any partition of the device is open.
However you can use BLKPG_ADD_PARTITION to add a new partition providing it
doesn't overlap any existing partition.
Unfortunately parted doesn't use this ioctl, nor am I aware of anything which
does. (Google suggests something called DeviceKit does, but I know nothing
about that).
You could write a program which reads the the partition table and tries to
add each partition individually.  Some might fail but others might succeed.
... or maybe you don't need to- 'partx' in util-linux-ng seems to do what you
want.

NeilBrown
