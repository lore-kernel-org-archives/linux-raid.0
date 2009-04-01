From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Thu, 02 Apr 2009 07:57:00 +1300
Message-ID: <49D3B8FC.7050204@sauce.co.nz>
References: <439371.59188.qm@web51306.mail.re2.yahoo.com>	<87myb1ieoq.fsf@frosties.localdomain>	<1238597796.4604.6.camel@cichlid.com> <87tz58b65a.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tz58b65a.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Andrew Burgess <aab@cichlid.com>, linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:

> 
> Now think about the same with 6 disk raid5. Suddenly you have partial
> stripes. And the alignment on stripe boundaries is gone too. So now
> you need to read 384k (I think) of data, compute or delta (whichever
> requires less reads) the parity and write back 384k in 4 out of 6
> cases and read 64k and write back 320k otherwise. So on average you
> read 277.33k and write 362.66k (= 640k combined). That is twice the
> previous bandwidth not to mention the delay for reading.
> 
> So by adding a drive your throughput is suddenly halfed. Reading in
> degraded mode suffers a slowdown too. CPU goes up too.
> 
> 
> The performance of a raid is so much dependent on its access pattern
> that imho one can not talk about a general case. But note that the
> more drives you have the bigger a stripe becomes and you need larger
> sequential writes to avoid reads.

I take your point, but don't filesystems like XFS and ext4 play nice in 
this scenario by combining multiple sub-stripe writes into stripe sized 
writes out to disk?

Regards,

Richard
