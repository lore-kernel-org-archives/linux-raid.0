From: Neil Brown <neilb@suse.de>
Subject: raid10 layouts and performance Re: md man page
Date: Tue, 8 Jul 2008 09:32:45 +1000
Message-ID: <18546.42909.593639.301693@notabene.brown>
References: <20080701202231.GA24283@rap.rap.dk>
	<55918.192.168.1.70.1214947301.squirrel@neil.brown.name>
	<20080702001739.GA26832@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="p/kb/uj0Nd"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Wednesday July 2
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--p/kb/uj0Nd
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit


(Adding linux-raid - I hope that's OK Keld?)

On Wednesday July 2, keld@dkuug.dk wrote:
> 
>        When 'offset' replicas are chosen, the multiple copies of a given chunk
>        are  laid out on consecutive drives and at consecutive offsets.  Effec-
>        tively each stripe is duplicated and  the  copies  are  offset  by  one
>        device.    This  should give similar read characteristics to 'far' if a
>        suitably large chunk size is used, but  without  as  much  seeking  for
>        writes.
> 
> A number of benchmarks have shown that 'offset' layout does not have 
> similar read characteristics as the 'far' layout. Also a number of benchmarks have
> shown that seeking is similar in 'far' and 'offset' layouts. So I suggest to
> remove the last sentence.

If I have done any such benchmarks, it was too long ago to remember,
so I decided to do some simple tests and graph them.  I like graphs
and I like this one so I've decided to share it.

The X axis is chunk size, ranging from 4k to 4096k - it is
logarithmic.
The Y axis is throughput in MB/s measured by 'dd' to the raw device -
average of 5 runs.
This was with a 2-drive raid with each of the possible layout: n2, f2,
o2.

f2-read is strikingly faster than anything else.  It is clearly
reading from both drives as once, as you would expect it to.
f2-write is slower then anything else (except at 4K chunk size, which is
an extreme case).

o2-read is fairly steady for most of the chunk sizes, but peaks up at
2M and only drops a little at 4M.  This seems to suggest that it is
around 2M that the time to seek over a chunk drops well below the time
to read one chunk.  Possibly at smaller chunk sizes, it just reads to
skip N sectors.  Maybe the cylinder size is about 2Meg - there no real
gain from the offset layout until you can seek over whole cylinders.
So the sentence:
      This  should give similar read characteristics to 'far' if a
      suitably large chunk size is used
seems somewhat justified if the chunksize used is 2M.
It might be interesting to implement non-power-of-2 chunksizes and try
a range of sizes between 1M and 4M to see what the graph looks like...
maybe we could find the actual cylinder size.

o2-write is very close to n2-write and is measurably (8%-14%) higher
than f2-write.  This seems to support the sentence
      but without as much seeking for writes.

It is not that there are fewer seeks, but that the seeks are shorter.

So while I don't want to just remove that last sentence, I agree that
it could be improved, possibly by giving a ball-park figure for what a
"suitably large chunk size" is.  Also the second half could be
"but without the long seeks being required for sequential writes".

It would probably be good to do some measurements with random IO as
well to see how they compare.

Anyone else have some measurements they would like to share?


Thanks for your suggestions.

NeilBrown



--p/kb/uj0Nd
Content-Type: image/png
Content-Disposition: inline;
	filename="10f2.png"
Content-Transfer-Encoding: base64

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
--p/kb/uj0Nd--
