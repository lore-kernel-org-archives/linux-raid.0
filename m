From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Invalid argument when creating a RAID-0 array
Date: Sun, 15 Jun 2003 09:02:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16107.43382.98190.258955@gargle.gargle.HOWL>
References: <3EEB36DA.6050407@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ari Pollak on Saturday June 14
To: Ari Pollak <ari@debian.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 14, ari@debian.org wrote:
> [Please CC me on replies]
> 
> I am currently trying to create a RAID-0 array using 5 SCSI drives with 
> raidtools2 on Debian but it is failing. Any input would be appreciated. 
> When I run 'mkraid /dev/md0', I get the following:
> 
....
>          chunk-size     4
....
> too small chunk_size: 4096 < 8192

Maybe use a bigger chunk size, 4K is rather small.
However I thought 4k would work.  Maybe you aren't using an i386, as
the minimum chunksize is currently connected with the system
pagesize.  What architecture are you using?

NeilBrown
