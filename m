From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: sw_raid5-failed_disc(s)-2
Date: Sat, 12 Mar 2005 12:49:23 -0500
Message-ID: <200503121749.j2CHnT529953@www.watkins-home.com>
References: <d0ur31$ud$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <d0ur31$ud$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ronny Plattner' <ronny_p@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It seems like a trick question! :)
You don't use "missing" on assemble, it is a keyword for the create command.

For assemble. just don't list that device.
mdadm --assemble --run --force /dev/md2 /dev/hdi1 /dev/hdk1 /dev/hdo1

mdadm will know which disk is which.

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ronny Plattner
Sent: Saturday, March 12, 2005 8:37 AM
To: linux-raid@vger.kernel.org
Subject: Re: sw_raid5-failed_disc(s)-2

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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

