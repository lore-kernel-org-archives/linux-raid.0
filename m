From: Christoph Hellwig <hch@infradead.org>
Subject: Re: md-RAID5/6 stripe_cache_size default value vs performance vs
	memory footprint
Date: Thu, 26 Dec 2013 00:55:10 -0800
Message-ID: <20131226085510.GB32660@infradead.org>
References: <52B102FF.8040404@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>
	<52B41B67.9030308@pzystorm.de> <201312202343.47895.arekm@maven.pl>
	<52B57912.5080000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <52B57912.5080000@hardwarefreak.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Sat, Dec 21, 2013 at 05:18:42AM -0600, Stan Hoeppner wrote:
> The powers that be, Linus in particular, are not fond of default
> settings that create a lot of kernel memory structures.  The default
> md-RAID5/6 stripe_cache-size yields 1MB consumed per member device.

The default sizing is stupid as it basically makes RAID unusable out
of the box, I always have to fix that up, as well as a somewhat
reasonable chunk size for parity RAID to make it usable.  I'm also
pretty sure I complained about it at least once a while ago, but never
got a reply.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
