From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Creating degraded more arrays with mdadm?
Date: Sat, 14 Dec 2002 17:27:19 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021214222719.GA22527@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey everyone,

	I started building a new array today to give some failover
capabilities to an aging Maxtor 17G drive and an IBM Deathstar 20G.  The
Maxtor had data on it, so I went about my usual routine of creating an
array in with a failed disk.

	I'm trying to convert to using mdadm for everything, but I
couldn't really figure out how to do this.  I thought I figured it out
with

# mdadm --create /dev/md0 --level=1 --raid-disks=1 /dev/hde2
... copy data
# mdadm --add /dev/md0 /dev/hdg2

But I knew something didn't work as expected when there was no sync
required.  I realized only after stopping and restating the array I
created a one disk mirror with one hot spare.  Doh!

Given that I have /dev/hde2 with data, and /dev/hdg1 and I want to put
them into an array, how do I use mdadm to make a degraded mode md device
like I used to with raidtools2?

(btw - have I asked this before?  I'm having a small case of deja vu,
but google and MARC couldn't corroborate my feeling...)

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
