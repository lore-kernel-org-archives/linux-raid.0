From: Phil Turmel <philip@turmel.org>
Subject: Re: failed RAID 5 array
Date: Thu, 13 Nov 2014 17:56:53 -0500
Message-ID: <54653735.90007@turmel.org>
References: <1415807882.4241.36.camel@lappy.neofreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1415807882.4241.36.camel@lappy.neofreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: DeadManMoving <sequel@neofreak.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/12/2014 10:58 AM, DeadManMoving wrote:
> Hi list,
> 
> I have a failed RAID 5 array, composed of 4 x 2TB drives without hot
> spare. On the fail array, it looks like there is one drive out of sync
> (the one with a lower Events counts) and another drive with a missing or
> corrupted superblock (dmesg is reporting "does not have a valid v1.2
> superblock, not importing!" and i have a : Checksum : 5608a55a -
> expected 4108a55a).
> 
> All drives seems good though, the problem was probably triggered by a a
> broken communication between the external eSATA expansion card and
> external drive enclosure (card, cable or backplane in the enclosure i
> guess...).
> 
> I am now in the process of making exact copies of the drives with dd to
> other drives.
> 
> I have an idea on how to try to get my data back but i would be happy if
> someone could help/validate with the steps i intent to follow to get
> there.

--create is almost always a bad idea.

Just use "mdadm -vv --assemble --force /dev/mdX /dev/sd[abcd]"

One drive will be left behind (the bad superblock), but the stale one
will be revived and you'll be able to start.

If that doesn't work, show the output of the above command.  Do NOT do
an mdadm --create.

Phil

