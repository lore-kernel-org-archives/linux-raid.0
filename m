From: Iustin Pop <iusty@k1024.org>
Subject: Re: Fw: Why does one get mismatches?
Date: Mon, 25 Jan 2010 20:32:58 +0100
Message-ID: <20100125193257.GA11920@teal.hq.k1024.org>
References: <87y6jmxygf.fsf@frosties.localdomain>
 <957236.22933.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <957236.22933.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 25, 2010 at 02:52:58AM -0800, Jon Hardcastle wrote:
> This is going to be a time consuming process as i'll have to remove
> and read from the array each drive 1 at a time then resync. 
> 
> Thanks for the link, but could a similar result be achieved with the
> -w option for badblocks? or perhaps a dd if=/dev/urandom? hmm scratch
> that the urandom wont work as you need to read AND write.
> 
> Just a worry as i clearly have mismatches and therefore corrupted
> data.

Just a comment from the 'benches' here: looking at all the tests you
have done, my personal opinion is that this is *not* HW problems of any
kind, but indeed some MD software issue. I've never seen such high
percentage of consistent and silent corruption in the hardware, and to
me it seems corruption in the software, *if at all*.

I would run a counter-test, to see at least if the 'check' test is
right:

- run your array until 'check' returns mismatches
- shutdown the array
- check that the contents of the drives is indeed different using
  something else than 'check' (e.g. checksum each 1MB block on the
  drives independently, and compare the checksum lists)
- if indeed there are diffs, start the array, run a repair (but no other
  traffic to the array)
- shutdown the array and re-run the external diff test

The above tests should tell you if: check is right, and if repair indeed
fixes the differences.

And another side-note: it would be really good if md had a debug option
to actually show the checksums for the differing blocks and their
offsets, to at least see if the same areas of the drive show differences
(it would be really funny if the diffs are, for example, in the MD
metadata :) (or does md already have something like this? I've stopped
using md a year or so ago).

regards,
iustin
