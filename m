From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Force parity resync on raid5?
Date: Tue, 10 Aug 2004 22:39:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16664.49686.253255.828936@cse.unsw.edu.au>
References: <4118B9A8.2040102@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Philip Molter on Tuesday August 10
To: Philip Molter <philip@corp.texas.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 10, philip@corp.texas.net wrote:
> 
> Linux RAID *has* to have sort of way to force a parity resync.  If it
> doesn't have one, it needs one.  That's a glaring omission to make.

Well, you get what you pay for.....

The easiest way to force a resync would be to re-create the array.

 - Note the exact order of the drives in the array, and the chunk size.
 - Stop the array.
 - Create the array with mdadm using --force.  That bit is important.

    mdadm --create /dev/mdX --level=5 --force --disks=whatever \
       --chunksize=64k  /dev/sda1 /dev/sdb1 .....

 Remember the --force.  If you don't have it, you will get a recovery
 cycle that rebuilds one drive against the others rather than a resync
 that checks and corrects parity.

 This will recreate the array (almost) exactly as it currently is, but
 it will not be marked 'clean', so a parity check-and-correct will
 happen.

 It should be fairly easy to add a --update=dirty option to
    "mdadm --assemble"
 to make that a bit easier.  I might do that in a  day or two (though
 I might not).

 Ofcourse, it would be really nice if you could just tell md to run a
 resync pass.  It's on my todo list, but it isn't the only thing.
 Clean, well-designed, small patches gladly accepted.

NeilBrown

(don't forget the --force)
