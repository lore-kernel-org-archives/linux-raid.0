From: Neil Brown <neilb@suse.de>
Subject: Re: Expanding RAID array?
Date: Tue, 17 Jan 2006 11:52:32 +1100
Message-ID: <17356.16336.104087.303806@cse.unsw.edu.au>
References: <1137424449.3953.38.camel@kenny>
	<17356.8228.325002.652805@cse.unsw.edu.au>
	<024201c61af4$dec2ab40$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org, rowe@excc.ex.ac.uk
List-Id: linux-raid.ids

On Tuesday January 17, djani22@dynamicweb.hu wrote:
> >
> > - add disks to increase size of raid5
> >     Possible offline with raidreconfig
> >     Possible online with alpha-quality patches that I am
> >       working on today. Will publish for experimentation/testing
> >       later this week.  Hopefully stable by late Feb.
> 
> This patch will can do also chunksize conversion? :-)

Not currently, but it shouldn't be too hard to add.

> And / or converting from N disk to N disk with different chunksize?

No.  This is impossible to do both efficiently and safely with NVRAM.
Even if you give up "efficiently" you need some temporary storage space.

You would need to 
  copy a stripe to some temporary storage
  Update the metadata to record that the stripe has moved
  copy the stripe back with the new geometry 
  Update the metadata to record the movement
 repeat

It certainly could be done, but I doubt the demand would be high
enough to justify it.

The situation is similar for raid5-raid6 or raid0-raid5 conversions
that done increase the size of the array (i.e. only add one device).
They require update-in-place which is hard to do in a way that still
protects your data if there is a power failure.

NeilBrown
