From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Useful benchmarking tools for RAID
Date: Tue, 18 Mar 2008 09:48:19 +1300
Message-ID: <47DED913.6030301@sauce.co.nz>
References: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu>	<18393.37268.150207.688089@tree.ty.sabi.co.uk>	<1205449115.30451.214.camel@atlantis.cc.ndsu.nodak.edu> <18397.44980.946243.573835@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18397.44980.946243.573835@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:

> However, if you move to smaller files ReiserFS seems better, if
> you keep mbox JFS is nicer, and if the mboxes are largish
> perhaps XFS is better.

Testing might be the best option. This Intel authored pdf (slightly 
dated) suggests XFS may be the best choice for maildir based storage and 
  ext3 for mbox.

http://www.valhenson.org/review/choosing.pdf


> bmesich> I was under the assumption that batteries on the
> bmesich> controllers are a must when using write-caching
> bmesich> sensibly.
> 
> Well, yes and no. In general the Linux cache is enough for
> caching and the disk cache is enough for buffering.
> 
> The host adapter cache is most useful for RAID5, as a stripe
> buffer: to keep in memory writes that do not cover a full stripe
> hoping that sooner or later the rest of the stripe will be
> written and thus a RMW cycle will be avoided. In your case
> that may be a vain hope.

If using XFS, keeping the battery backed controller would be sensible - 
see the "Write Back Cache" section of the FAQ at SGI:

http://oss.sgi.com/projects/xfs/faq.html#wcache


> However IBM have stopped actively developing JFS, much as SGI
> have stopped actively developing XFS, and RedHat have stopped
> actively developing 'ext3'.
> 
> The main difference is in reactiveness to bug fixing: for JFS
> it is up to the general kernel development community, while for
> ReiserFS, XFS and 'ext3' there is a sponsor who cares (somewhat)
> about that.

Although SGI may have "stopped actively developing XFS", in the sense 
that SGI has EOL'ed IRIX, SGI staff are actively adding new features and 
fixing bugs to the Linux implementation. See

http://oss.sgi.com/projects/xfs/

and an active mailing list:

http://marc.info/?l=linux-xfs

Regards,

Richard
