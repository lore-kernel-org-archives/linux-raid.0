From: Neil Brown <neilb@suse.de>
Subject: RE: Two-disk RAID5?
Date: Thu, 27 Apr 2006 08:53:21 +1000
Message-ID: <17487.63969.767902.768109@cse.unsw.edu.au>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com>
	<Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Lewis on Wednesday April 26
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: "Jansen, Frank" <fjansen@egenera.com>, Tuomas Leikola <tuomas.leikola@gmail.com>, John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 26, jlewis@lewis.org wrote:
> 
> I suspect I should have just kept out of this, and waited for someone like 
> Neil to answer authoratatively.
> 
> So...Neil, what's the right answer to Tuomas's 2 disk RAID5 question? :)
> 

.. and a deep resounding voice from on-high spoke and in it's infinite
wisdom it said....
 
   "yeh, whatever"


The data layout on a 2disk raid5 and a 2 disk raid1 is identical (if
you ignore chunksize issues (raid1 doesn't need one) and the
superblock (which isn't part of the data)).  Each drive contains
identical data(*).

Write throughput to a the r5 would be a bit slower because data is
always copied in memory first, then written.
Read through put would be largely the same if the r5 chunk size was
fairly large, but much poorer for r5 if the chunksize was small.

Converting a raid1 to a raid5 while offline would be quite straight
forward except for the chunksize issue.  If the r1 wasn't a multiple
of the chunksize you chose for r5, then you would lose the last
fraction of a chunk.  So if you are planning to do this, set the size
of your r1 to something that is nice and round (e.g. a multiple of
128k).

Converting a raid1 to a raid5 while online is something I have been
thinking about, but it is not likely to happen any time soon.

I think that answers all the issues.

NeilBrown

(*) The term 'mirror' for raid1 has always bothered me because a
mirror presents a reflected image, while raid1 copies the data without
any transformation.

With a 2drive raid5, one drive gets the original data, and the other
drive gets the data after it has been 'reflected' through an XOR
operation, so maybe a 2drive raid5 is really a 'mirrored' pair....
Except that the data is still the same as XOR with 0 produces no
change.
So, if we made a tiny change to raid5 and got the xor operation to
start with 0xff in every byte, then the XOR would "reflect" each byte
in a reasonable meaningful way, and we might actually get a "mirrored
pair"!!!  

But I don't think that would provide any real value :-)
