From: Ronny Plattner <ronny_p@gmx.net>
Subject: Re: sw_raid5-failed_disc(s)-2
Date: Sat, 12 Mar 2005 14:36:34 +0100
Message-ID: <d0ur31$ud$1@sea.gmane.org>
References: <d0t31v$89o$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
In-Reply-To: <d0t31v$89o$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

Today i tried following:

-snip-
server:~# mdadm --assemble --run --force /dev/md2 /dev/hdi1 /dev/hdk1
missing /dev/hdo1
mdadm: cannot open device missing: No such file or directory
mdadm: missing has no superblock - assembly aborted

server:~# cat /var/log/messages
Mar 12 14:27:49 server kernel: md: md2 stopped.
Mar 12 14:28:05 server kernel: md: md2 stopped.
-snap-


Maybe this information is useful.

Regards
Ronny

