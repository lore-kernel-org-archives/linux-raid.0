From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 08:52:43 +1000
Message-ID: <17109.39739.188032.769569@cse.unsw.edu.au>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
	<1121259126.5504.14.camel@localhost.localdomain>
	<87vf3eeqe2.fsf@uwo.ca>
	<42D5573A.6090801@dgreaves.com>
	<1121278451.5504.79.camel@localhost.localdomain>
	<42D58541.7000702@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Wednesday July 13
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: mingz@ele.uri.edu, Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 13, david@dgreaves.com wrote:
> I guess each raw device does some readahead, then the md0 does some
> readahead and then the lvm does some readahead. Theoretically the md0
> and lvm should overlap - but I guess that much of the raw device level
> readahead is discarded.

No.  Devices don't to readahead (well, modern drives may well
read-ahead into an on-drive buffer, but that is completely transparent
and separate from any readahead that linux does).

Each device just declares how much readahead it thinks is appropriate
for that devices.

The linux mm layer does read-ahead by requesting devices for blocks
that haven't actually been asked for by upper layers.  The amount of
readahead depends on the behaviour of the app doing the reads, and the
setting declared by the devices.

raid5 declares a read-ahead size of twice the stripe size.
i.e. chunks * (disks-1) * 2.

Possibly it should make it bigger if the underlying devices would all
be happy with that, however I haven't given the issue a lot of
thought, and it is tunable from userspace.

NeilBrown
