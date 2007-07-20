From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: pata_via with software raid1: "attempt to access beyond end of
 device"
Date: Thu, 19 Jul 2007 23:32:41 -0300
Message-ID: <9fj5n4-uh5.ln1@tux.abusar.org>
References: <dju2n4-lcf.ln1@tux.abusar.org>
	<18078.57482.951240.250360@notabene.brown>
	<mpm4n4-dr3.ln1@tux.abusar.org>
	<18080.6791.774446.512592@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 20 Jul 2007 12:14:31 +1000
Neil Brown <neilb@suse.de> wrote:

> What does
>       od -D -j 65536 -N 4 /dev/md1
> show.  This is the size the reiserfs thinks it is using.  Multiply by
> 4 and you should get 77642048 or maybe a little less.  If you get
> more, then reiserfs think the device is bigger than it is.  If don't
> then I have no idea what the problem is.

	The output is:

0200000   19410528
0200004

	so...

19410528 x 4 = 77642112

	The difference (77642048 - 77642112) is 64.

	Does it help? What could I do now? Thanks!

-- 
Linux 2.6.22: Holy Dancing Manatees, Batman!
http://www.lastfm.pt/user/danielfraga
http://u-br.net
Exodus - "I Am Abomination" (Shovel Headed Kill Machine - 2005)

