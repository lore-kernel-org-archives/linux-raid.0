From: Ninti Systems <office@ninti.com.au>
Subject: Re: fd filesystem and RAID1
Date: 05 Apr 2004 18:38:41 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1081156121.2301.55.camel@localhost>
References: <1080948756.999.10.camel@localhost>
	 <87oeq7me9d.fsf@enki.rimspace.net>  <1081152016.2301.40.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1081152016.2301.40.camel@localhost>
To: Daniel Pittman <daniel@rimspace.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> > 
> > The kernel auto-discovery will only probe a partition that has type
> > 'fd', so if you want both parts of the mirror to work, both need to be
> > type 'fd'.

I tried doing this to partitions on both IDE devices pre-install
(Slackware saw them all as md devices, install impossible), and I also
tried changing the original install disk's partitions over to 'fd' type
after copying their content to the md device (the second disk also all
'fd' type).

But whatever I do the arrays never have usable superblocks, are always
degraded and always want to resync on boot.

Thanks for all your help, but I'm starting to get over this RAID on
Slackware thing. I think I'll reconsider my distro (RedHat) or my backup
strategy (rsync).

Thanks again

