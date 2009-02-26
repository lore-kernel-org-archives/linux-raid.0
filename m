From: Chris Webb <chris@arachsys.com>
Subject: Re: Assume-clean for md grow
Date: Thu, 26 Feb 2009 16:03:01 +0000
Message-ID: <20090226160301.GN17577@arachsys.com>
References: <20090225142229.GI32722@arachsys.com> <c5fe66de938d528320cf21d8ca3c7a83.squirrel@neil.brown.name> <20090226145442.GH17577@arachsys.com> <20090226155743.GM17577@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090226155743.GM17577@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Webb <chris@arachsys.com> writes:

> I just tried growing the slots up from 1G to 3G, then
> 
>   echo $((2097136 + 2*1024*1024*2)) >/sys/block/md127/md/resync_start
>   mdadm --grow 3145720
> 
> but this gives me
> 
>   md127 : active raid1 dm-3[1] dm-2[0]
>         3145720 blocks super 1.1 [2/2] [UU]
>           resync=PENDING
> 
> in /proc/mdstat, which is presumably not right?

Rewriting the original value of 18446744073709551615 back to
/sys/block/md127/md/resync_start removes this, although it looks like any
value lower than this gives a PENDING state. Presumably this means that:-

  echo 18446744073709551614 >/sys/block/md127/md/resync_start
  mdadm --grow --size=... /dev/md127
  echo 18446744073709551615 >/sys/block/md127/md/resync_start

is a generic recipe for growing an array 'assume-clean' without needing to know
anything more about the eventual size of the array other than the parameter
passed to --size= (max or component size).
