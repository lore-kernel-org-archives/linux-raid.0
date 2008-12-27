From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Date: Sat, 27 Dec 2008 08:38:24 -0500
Message-ID: <20081227133824.GH6284@josefsipek.net>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
	<495410F4.5010508@ziu.info>
	<alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Thu, Dec 25, 2008 at 06:46:37PM -0500, Justin Piszcz wrote:
> On Fri, 26 Dec 2008, Michal Soltys wrote:
> >> I am not worried about the filesystem as the defaults usually get it right 
> >> but with parted, this is the first time I had to use it for home use and 
> >> with RAID-6 I am noticing slower performance with 15 disks (1 is a spare) 
> >> in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10 
> >> raptor150s in RAID-6 (but I had used fdisk there).
> >> 
> >> Justin.
> >> 
> >
> > For best effect - partition should start at 1920th sector (stripe width
> > boundary), and su/sw should be appropriately set - su=64k,sw=13 in your
> > case. Parted shows the values normally - from the beginning of the volume, 0 
> > based.
> >
> >
> > ps.
> >
> > I dropped some of CCs.
> 
> Thanks.

It looks like you made why big partition. Why bother with partitioning at
all? If you just use the whole device, you _will_ be aligned properly if you
tell mkfs.xfs about the stripe unit/width.

Josef 'Jeff' Sipek.

-- 
All science is either physics or stamp collecting.
		- Ernest Rutherford

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
