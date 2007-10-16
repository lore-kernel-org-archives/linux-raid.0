From: Neil Brown <neilb@suse.de>
Subject: Re: Partitionable raid array... How to create devices ?
Date: Tue, 16 Oct 2007 19:49:09 +1000
Message-ID: <18196.35093.226685.234130@notabene.brown>
References: <471474D6.5090704@systella.fr>
	<18196.34718.434070.857620@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Tuesday October 16
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 16, neilb@suse.de wrote:
> However what you used should work.  I'll get that fixed for the next
> release.

This is the patch that will fix it.  I plan to release 2.6.4 late this
week or early next.

NeilBrown



### Diffstat output
 ./mdopen.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/mdopen.c ./mdopen.c
--- .prev/mdopen.c	2007-10-16 19:47:14.000000000 +1000
+++ ./mdopen.c	2007-10-16 19:47:25.000000000 +1000
@@ -161,6 +161,7 @@ int open_mddev(char *dev, int autof)
 				"not compatable with device named %s\n", dev);
 				return -1;
 			}
+			major_num = get_mdp_major();
 			break;
 		case 5: /* default to md if not standard */
 			break;
