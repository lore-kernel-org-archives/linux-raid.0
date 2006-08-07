From: Neil Brown <neilb@suse.de>
Subject: Re: raid5/lvm setup questions
Date: Tue, 8 Aug 2006 09:29:29 +1000
Message-ID: <17623.52441.692673.160830@cse.unsw.edu.au>
References: <20060805165358.GA29177@cm.nu>
	<44D4D5F9.9080201@dgreaves.com>
	<20060805175908.GA31024@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Shane on Saturday August 5
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 5, shane@cm.nu wrote:
> On Sat, Aug 05, 2006 at 06:31:37PM +0100, David Greaves wrote:
> > > Say going from 300gbx4 to 500gbx4.  Can one replace them
> > > one at a time, going through fail/rebuild as appropriate
> > > and then expand the array into the unused space
> > Yes.
> 
> I didn't see anything in the mdadm manual on this.  Would
> one just do a --grow /dev/md0 once the disks were changed
> out?  It looks like --grow is used to change the number of
> devices in the array but not the device size itself.

It does both (and more).

 mdadm --grow /dev/md0 --raid-disk=5
changes the number of drives to 5.

 mdadm --grow /dev/md0 --size=max

changes the used-size of each drive to the maximum available.

 mdadm --grow /dev/md0 --bitmap=internal
adds an internal write-intent bitmap

 mdadm --grow /dev/md0 --chunksize=128
might change the chunksize to 128k.. but doesn't yet.  
Maybe one day :-)

NeilBrown
