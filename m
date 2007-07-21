From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: pata_via with software raid1: "attempt to access beyond end of
 device"
Date: Sat, 21 Jul 2007 18:18:35 -0300
Message-ID: <bq9an4-rm6.ln1@tux.abusar.org>
References: <dju2n4-lcf.ln1@tux.abusar.org>
	<18078.57482.951240.250360@notabene.brown>
	<mpm4n4-dr3.ln1@tux.abusar.org>
	<18080.6791.774446.512592@notabene.brown>
	<9fj5n4-uh5.ln1@tux.abusar.org>
	<18080.9501.524388.160581@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 20 Jul 2007 12:59:41 +1000
Neil Brown <neilb@suse.de> wrote:

> So reiserfs thinks the devices is 64K larger than it really is. I
> wonder how that happened.

>    resize_reiserfs -s -64K /dev/md1

	Neil, I discovered how the "64k larger" issue happened...

	It was my fault.. I created the Reiser filesystem *before* the
raid device. So when I create the raid device, it warns about a
existing reiserfs filesystem and if I want to continue. This way, the
underlying filesystem will be always 64k large than the raid device.

	If, instead, I use the correct method of creating the raid
device *before*, everything is ok, because then I can "mkreiserfs" the
raid device and the filesystem will have the correct size the raid
device expects.

	Sorry for my mistake and thanks again!

-- 
Linux 2.6.22: Holy Dancing Manatees, Batman!
http://www.lastfm.pt/user/danielfraga
http://u-br.net
Marilyn Manson - "Dried Up, Tied and Dead to the World" (Antichrist
Superstar - 1996)

