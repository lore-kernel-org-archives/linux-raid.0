From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm -A -s and a mirror of two stripes
Date: Tue, 4 May 2004 12:30:03 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16535.43.304725.835518@cse.unsw.edu.au>
References: <Pine.LNX.4.58.0404170145320.7026@potato.cts.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Stromsoe on Saturday April 17
To: Chris Stromsoe <cbs@cts.ucla.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 17, cbs@cts.ucla.edu wrote:
> I've got two stripes that were set up as
> 
> mdadm -C /dev/md1 --level=stripe -n 5 \
>     /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> mdadm -C /dev/md2 --level=stripe -n 5 \
>     /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
> 
> and a mirror that was set up by doing
> 
> mdadm -C /dev/md0 --level=mirror -n 2 /dev/md1 /dev/md2
> 
> 
> My /etc/mdadm/mdadm.conf reads
> 
> DEVICE /dev/sd[abcdefghij]1 /dev/md[12]
> ARRAY /dev/md1 level=raid0 num-devices=5 UUID=75892ebc:b52333a4:b77cbdca:9d50c65d devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1
> ARRAY /dev/md2 level=raid0 num-devices=5 UUID=c7547e18:48952f89:49893143:e477c407 devices=/dev/sdf1,/dev/sdg1,/dev/sdh1,/dev/sdi1,/dev/sdj1
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=26e3111e:90a3407d:341ed800:1f431f24 devices=/dev/md1,/dev/md2
> 
> 
> mdadm -A -s starts md1, then md2, but doesn't start md0.  I have to run it
> a second time to get md0 to start.  The first run prints out:
> 
> mdadm: /dev/md1 has been started with 5 drives.
> mdadm: /dev/md2 has been started with 5 drives.
> mdadm: no devices found for /dev/md0
> 
> Is that a bug or a feature?  mdadm is v1.4.0.

Probably a bug.  I'll put it on my todo list.

You would be better off with the setup the other way up.
i.e. make raid1 arrays of a and f, g and b etc.  Then stripe them all
together.
That way if a drive fails, only one drive needs to be rebuild, not 5.
Also, if (e.g.) a and i both fail, you don't lose all your data.

NeilBrown
