From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Wed, 01 Apr 2009 20:06:25 +0200
Message-ID: <87tz58b65a.fsf@frosties.localdomain>
References: <439371.59188.qm@web51306.mail.re2.yahoo.com>
	<87myb1ieoq.fsf@frosties.localdomain>
	<1238597796.4604.6.camel@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1238597796.4604.6.camel@cichlid.com> (Andrew Burgess's message
	of "Wed, 01 Apr 2009 07:56:36 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Burgess <aab@cichlid.com> writes:

>> >> > Hey guys, How do you know if your machine can handle
>> >> adding some more drives to it? How can you check that there
>> >> is enough BUS IO to handle extra sata cards and also that
>> >> the machine is powerful enough to support say an 8 drive
>> >> raid 5...
>
> Look at it from the viewpoint of raid performance rather than disk
> performance. How can the throughput be less with more disks?
>
> So what if your bus bandwidth is saturated now? Then it will be
> saturated with more disks too, but the raid bandwidth should not change,
> it's still the saturation bandwidth.
>
> And if it's not saturated now then the raid throughput will increase
> assuming you can get more disks operating in parallel.
>
> I'm sure there are corner cases we can nitpick but isn't this correct in
> general?

To show a worstcase say you have a 5 disk raid5 with 64k chunk
size. Further say your application writes chunks of 256k to disk at
random offsets (but aligned to 256k). Each write is a nice full
stripe, the parity is calculated and 320k are written.

Now think about the same with 6 disk raid5. Suddenly you have partial
stripes. And the alignment on stripe boundaries is gone too. So now
you need to read 384k (I think) of data, compute or delta (whichever
requires less reads) the parity and write back 384k in 4 out of 6
cases and read 64k and write back 320k otherwise. So on average you
read 277.33k and write 362.66k (= 640k combined). That is twice the
previous bandwidth not to mention the delay for reading.

So by adding a drive your throughput is suddenly halfed. Reading in
degraded mode suffers a slowdown too. CPU goes up too.


The performance of a raid is so much dependent on its access pattern
that imho one can not talk about a general case. But note that the
more drives you have the bigger a stripe becomes and you need larger
sequential writes to avoid reads.

MfG
        Goswin
