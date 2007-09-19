From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Wed, 19 Sep 2007 16:31:37 -0700 (PDT)
Message-ID: <20070919233137.7D5B2102365@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
 <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
 <20070919014919.DF19D10215F@medulla.enet.sharplabs.com>
 <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>
 <20070919174956.9497310209D@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709191425440.27758@p34.internal.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.0709191425440.27758@p34.internal.lan> (message
	from Justin Piszcz on Wed, 19 Sep 2007 14:25:59 -0400 (EDT))
Sender: linux-raid-owner@vger.kernel.org
To: jpiszcz@lucidpixels.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Justin Piszcz wrote:
: Dean Messing wrote:
: > Jusin Piszcz wrote:
: > :
<snip>

: > I discovered your January correspondence to the list about this.  Yes,
: > the read-ahead length makes a dramtic difference---for sequential data
: > reading.  However, ...

<snip>

: > : Then re-benchmark.
: > 
: > Large Read-ahead nearly double the speed of 'hdparm -t'.  (So does
: > simply using the "--direct" flag.  Can you explain this?)  Also, in
: > your opinion, is it wise to use such large read-aheads for a RAID 5
: > intended for the use to which I plan to put it?
: 

: > Did you try increasing the readahead and benchmarking?  You can set it 
: > back to what it was when you are done.

Sorry if my earlier reply was not clear.

Yes, I did increase r.a. (to 16384 and 32768) and re-ran hdparm each time.
Result: 

r.a. =   512:  hdparm -t                -->  ~67 MB/s
 "   "    "    hdparm -t --direct       --> ~121 MB/s

r.a. =  4096:  hdparm -t                --> ~106 MB/s

r.a. =  8192:  hdparm -t                --> ~113 MB/s

r.a. = 16384:  hdparm -t                --> ~120 MB/s

r.a. = 32768:  hdparm -t                --> ~121 MB/s


As I said:  it nearly doubled the speed give by 'hdparm -t'

But (as I said) so did using the "--direct" flag, which inhibits
"page cache" whatever that is.

Also (as I asked) what is the downside?  From what I have read,
random access reads will take a hit.  Is this correct?

Thanks very much for your help!

Dean


