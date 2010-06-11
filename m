From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 15:08:11 +1000
Message-ID: <20100611150811.3c3f03bb@notabene.brown>
References: <4C1128C2.4020105@meetinghouse.net>
 <20100611005743.43664e5b@natsu>
 <4C11578B.8010202@meetinghouse.net>
 <20100611034108.6a2cdbc4@natsu>
 <4C1169CB.1030903@meetinghouse.net>
 <20100611085112.5f33b06f@natsu>
 <4C11BFB7.7050907@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C11BFB7.7050907@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Jun 2010 00:46:47 -0400
Miles Fidelman <mfidelman@meetinghouse.net> wrote:

> Roman Mamedov wrote:
> > On Thu, 10 Jun 2010 18:40:11 -0400
> > Miles Fidelman<mfidelman@meetinghouse.net>  wrote:
> >
> >    
> >> Yes... went with internal.
> >>
> >> I'll keep an eye on write performance.  Do you happen to know, off hand,
> >> a magic incantation to change the bitmap-chunk size? (Do I need to
> >> remove the bitmap I just set up and reinstall one with the larger chunk
> >> size?)
> >>      
> > Remove (--bitmap=none) then add again with new --bitmap-chunk.
> >
> >    
> Looks like my original --bitmap internal creation set a very large chunk 
> size initially
> 
> md3 : active raid6 sda4[0] sdd4[3] sdc4[2] sdb4[1]
>        947417088 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>        bitmap: 6/226 pages [24KB], 1024KB chunk
> 
> unless that --bitmap-chunk=131072 recommendation is translates to 
> 131072KB (if so, are you really running 131MB chunks?)

Yes, and 131MB (128MiB) is probably a little on the large side, but not
excessively so and may well be a very good number.

My current rule-of-thumb is that the bitmap chunk size should be about the
amount of data that can be written sequentially in 1 second. 131MB is maybe 2
seconds with today's technology, so it is close enough.

The idea is that normally if your filesystems provides fairly good locality,
you should not have very many bits in the bitmap set.  Probably 10s, possible
100s.

If this is the case, and each takes 1 second to resync, then resync time is
limited to a few minutes.

Smaller chunks might reduce this to less than a minute, but that probably
isn't worth it.  Conversely smaller chunks will tend to mean more updates to
the bitmap, so slower writes all the time.

On a 1TB drive there are 7500 131MB chunks.  So assuming a relatively small
number of bits set at a time, this will reduce resync time by a factor of
somewhere between 200 and 1000.  Hours become fewer minutes.  This is
probably enough for most situations.

I would be really interested to find out if my assumption of small numbers of
bits set is valid.   You can find out the number of bits set at any instant
with  "mdadm -X" run on some component of the array.

If anyone is able to report some samples of that number along with array
size / level / layout / number of devices etc and some guide to the workload,
it might be helpful in validating my rule-of-thumb.

Thanks,
NeilBrown
