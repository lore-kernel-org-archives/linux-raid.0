From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid 5 on linux --againnnn (sorryy it's big)
Date: Fri, 25 Jul 2003 16:52:42 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16160.54202.936629.967811@gargle.gargle.HOWL>
References: <16160.50236.215350.204806@gargle.gargle.HOWL>
	<47392.202.158.96.2.1059113497.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from c4c3m@oke.net.id on Friday July 25
To: c4c3m@oke.net.id
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 25, c4c3m@oke.net.id wrote:
> I'm following your way to recover my lost partition.
> when i try
> mdadm.static -Af /dev/md6 /dev/sda11
> mdadm.static -Af /dev/md6 /dev/sdb11
> mdadm.static -Af /dev/md6 /dev/sdc11

That isn't at all what I said to do.
This:

> >   mdadm -Af /dev/md1 /dev/sd[abc]6
> >   mdadm -Af /dev/md3 /dev/sd[abc]8
> >   mdadm -Af /dev/md4 /dev/sd[abc]9
> >   mdadm -Af /dev/md5 /dev/sd[abc]10
> >   mdadm -Af /dev/md6 /dev/sd[abc]11


is what I said to do.  This is a totally different command.

NeilBrown
