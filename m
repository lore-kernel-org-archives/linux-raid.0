From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.5.1 - A problem came up ...
Date: Sat, 17 Jun 2006 17:00:47 +1000
Message-ID: <17555.43167.774809.158823@cse.unsw.edu.au>
References: <17554.895.666628.776527@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606161855270.17622@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Friday June 16
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 16, babydr@baby-dragons.com wrote:
>  	Hello Neil ,  If I add any disk partition to end of the below command as
>  	man mdadm requests .  Ok ,  Now I get it ,  "partitions" or "none" are
>  	required .  But still ...
> 
>  	<Quote>
>  	mdadm --examine --brief --scan --config=partitions
>  	mdadm -Ebsc partitions
>  	Create  a list of devices by reading /proc/partitions, scan these for RAID superblocks, and printout a brief listing of all that was found.
>  	<\Quote>
> 
> root@privateers:~# mdadm -Ebsc
> mdadm: option requires an argument -- c

Yes, it requires an argument.  The argument in I gave in the example
was 'partitions'.


> Usage: mdadm --help
>    for help
> 
>  	Ok ,  But when I do a ...
> 
> root@privateers:~# mdadm -Ebsc --help
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=8d5cd2c7:42544200:d2bdaaad:ce1bab0c
> ARRAY /dev/md1 level=raid1 num-devices=2 UUID=e8a0caca:1e477715:f7f74d6b:88dd401c
> ARRAY /dev/md3 level=raid1 num-devices=2 UUID=a87d5acf:17038a98:03577e48:76e31d5c
> ARRAY /dev/md2 level=raid1 num-devices=2 UUID=8f4b56fa:840ad5eb:0c28a667:6a46f759
> 
>  	I was expecting a help readout not the command to actually function .

Yes, maybe it should have complained that '--help' was not a valid
config file, which is what that command is suggesting.

Putting '--help' first leaves less room for confusion, not that it
would have helped much in this case. :-(

$ ./mdadm --help -Ebsc
./mdadm: option requires an argument -- c
Usage: mdadm --help
  for help


NeilBrown
