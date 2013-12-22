From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md-RAID5/6 stripe_cache_size default value vs performance vs
	memory footprint
Date: Sat, 21 Dec 2013 19:41:37 -0600
Message-ID: <52B64351.4040806@hardwarefreak.com>
References: <52B102FF.8040404@pzystorm.de>	<52B2FE9E.50307@hardwarefreak.com>	<52B41B67.9030308@pzystorm.de>	<201312202343.47895.arekm@maven.pl>
	<52B57912.5080000@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
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
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>
Cc: linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On 12/21/2013 5:18 AM, Stan Hoeppner wrote:
...
> For example, I assisted a user with 5x Intel SSDs back in January and
> his system required 4096, or 80MB of RAM for stripe cache, to reach
> maximum write throughput of the devices.  This yielded 600MB/s or 60%
> greater throughput than 2048, or 40MB RAM for cache.  In his case 60MB
> more RAM than the default was well worth the increase as the machine was
> an iSCSI target server with 8GB RAM.

Correction here.  I said above that 80MB was 60MB greater than the
default for his 5 drives.  This should have said 75MB greater than the
default which is 1MB per member device, or 5MB for 5 drives.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
