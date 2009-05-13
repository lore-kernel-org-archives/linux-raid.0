From: Neil Brown <neilb@suse.de>
Subject: Re: Change Chunk Size on Array?
Date: Wed, 13 May 2009 14:45:47 +1000
Message-ID: <18954.20603.952706.467047@notabene.brown>
References: <16137381.post@talk.nabble.com>
	<23514897.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Tuesday May 12
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 12, sandeepksinha@gmail.com wrote:
> 
> 
> 
> crshman wrote:
> > 
> > Hello All,
> > 
> > I wanted to know if it were possible to change the chunk size on an array
> > after it has been created. I have a software raid 5 comprised of 7 drives
> > with a chunk size of 64k. I wanted to up that to 1024k, would this be
> > possible without losing any data? This isn't mission critical so it is ok
> > if i need to stop the array first, however I'd rather not lose any data.
> > 
> It is possible to change the chunksize but for the same you would need to
> offline your array.

Is it?  How?

Online changing of chunk size for raid5 is very close to being
implemented.
All the kernel side support will be in 2.6.30.
I just need to spend some time getting mdadm to make it work.
Because data is being rearranged in-place, and because you don't want
to lose everything if your systems crashes, mdadm will have to work in
tandem with the kernel making a backup copy of a section of the array,
allowing the kernel to reshape that section, and then moving on to the
next section.  It will be slow, but it will be reliable.

NeilBrown
