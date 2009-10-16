From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.31: xfs or md/raid1 bug in 2.6.31?
Date: Fri, 16 Oct 2009 08:37:03 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0910160832290.31450@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Hi all,

Does anyone recall if there was a serious xfs bug in 2.6.31?

I saw xfsbufd/pdflush etc locked up and local file system access hung 
whenever I tried to write a file to the filesystem, I ran a sysrq-t but 
could not capture the output nor did I see anything obvious.

System runs a md/raid1+xfs.

Upgraded to 2.6.31.4, will have to see if it happens again.

Was curious though if anyone recalled problems with this kernel 
release/combination?

Thanks,

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
