From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 layouts and performance Re: md man page
Date: Wed, 9 Jul 2008 00:44:22 +0200
Message-ID: <20080708224422.GD7443@rap.rap.dk>
References: <20080701202231.GA24283@rap.rap.dk> <55918.192.168.1.70.1214947301.squirrel@neil.brown.name> <20080702001739.GA26832@rap.rap.dk> <18546.42692.577082.770926@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18546.42692.577082.770926@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 08, 2008 at 09:29:08AM +1000, Neil Brown wrote:
Content-Description: message body text
> 
> (Adding linux-raid - I hope that's OK Keld?)

Yeah, that is fine:-)

> On Wednesday July 2, keld@dkuug.dk wrote:
> > 
> >        When 'offset' replicas are chosen, the multiple copies of a given chunk
> >        are  laid out on consecutive drives and at consecutive offsets.  Effec-
> >        tively each stripe is duplicated and  the  copies  are  offset  by  one
> >        device.    This  should give similar read characteristics to 'far' if a
> >        suitably large chunk size is used, but  without  as  much  seeking  for
> >        writes.
> > 
> > A number of benchmarks have shown that 'offset' layout does not have 
> > similar read characteristics as the 'far' layout. Also a number of benchmarks have
> > shown that seeking is similar in 'far' and 'offset' layouts. So I suggest to
> > remove the last sentence.
> 
> If I have done any such benchmarks, it was too long ago to remember,
> so I decided to do some simple tests and graph them.  I like graphs
> and I like this one so I've decided to share it.

I like graphs too! May I use your graph on the wiki?

> The X axis is chunk size, ranging from 4k to 4096k - it is
> logarithmic.
> The Y axis is throughput in MB/s measured by 'dd' to the raw device -
> average of 5 runs.
> This was with a 2-drive raid with each of the possible layout: n2, f2,
> o2.
> 
> f2-read is strikingly faster than anything else.  It is clearly
> reading from both drives as once, as you would expect it to.
> f2-write is slower then anything else (except at 4K chunk size, which is
> an extreme case).

Yes, in your test. Is this done with dd on the raw array?

My tests indicate that writing is almost the same for raid10,n2 and
raid10,f2, when using the ext3 fs. I think the elevator comes into play
here. And I actually think this is important. You do not use an array
without a fs on top of it. And for the user, it is really the resulting
performance of the raid and the fs that is interesting. The raw array is
not that interesting.

> o2-read is fairly steady for most of the chunk sizes, but peaks up at
> 2M and only drops a little at 4M.  This seems to suggest that it is
> around 2M that the time to seek over a chunk drops well below the time
> to read one chunk.  Possibly at smaller chunk sizes, it just reads to
> skip N sectors.  Maybe the cylinder size is about 2Meg - there no real
> gain from the offset layout until you can seek over whole cylinders.
> So the sentence:
>       This  should give similar read characteristics to 'far' if a
>       suitably large chunk size is used
> seems somewhat justified if the chunksize used is 2M.

Your graph indicates that raid10,o2 is something like 20 % under the
performance of raid10,f2, in the best case. In the worst case it is
about 30 % under. To me this is not "similar". To me that is better
described as a performance of 20 - 30 % under that of raid10,f2.

> It might be interesting to implement non-power-of-2 chunksizes and try
> a range of sizes between 1M and 4M to see what the graph looks like...
> maybe we could find the actual cylinder size.
> 
> o2-write is very close to n2-write and is measurably (8%-14%) higher
> than f2-write.  This seems to support the sentence
>       but without as much seeking for writes.
> 
> It is not that there are fewer seeks, but that the seeks are shorter.

This is most likely compensated by the elevator, as described above.

> So while I don't want to just remove that last sentence, I agree that
> it could be improved, possibly by giving a ball-park figure for what a
> "suitably large chunk size" is.  Also the second half could be
> "but without the long seeks being required for sequential writes".
> 
> It would probably be good to do some measurements with random IO as
> well to see how they compare.
> 
> Anyone else have some measurements they would like to share?

There is something like more than a handful in the wiki at
http://linux-raid.osdl.org/index.php/Performance

This includes some tests for random IO.

> Thanks for your suggestions.

you are welcome!

In my quest for updated documentation for linux raid, I find that mdadm
documentation is also very outdated. The mdadm man page that is reported
by google, and on wikipedia for mdadm, do not include any info on
raid10! 

Is there a page that we could reference, which has the current mdadm man
page? And which is maintained?

I note that our raid wiki is now nbr 3 on google, That is a lot better
than number 121 which was the place about half a year ago:-)


