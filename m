From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID5 rebuild difficulties
Date: Thu, 21 Aug 2003 14:08:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16196.17856.566945.807140@gargle.gargle.HOWL>
References: <200308201453.38427.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eric BENARD / Free on Wednesday August 20
To: Eric BENARD / Free <ebenard@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 20, ebenard@free.fr wrote:
> Hi,
> 
> I'm having some troubles to rebuild a software RAID5 after several power 
> failures.
> Does anyone have an idea on how I could resync superblock of 4 partitions in 
> order to rebuild the raid without loosing data ?
> 
> Many thanks and best regards
> Eric
> 
> [root@serv root]# mdadm -Eb /dev/hde8
> ARRAY /dev/md5 level=raid5 num-devices=3 
> UUID=adecf616:84cf5266:30d2b689:ec3729e7
>    devices=/dev/hde8
> [root@serv root]# mdadm -Eb /dev/hdf6
> ARRAY /dev/md5 level=raid5 num-devices=3 
> UUID=adecf616:84cf5266:30d2b689:ec3729e7
>    devices=/dev/hdf6
> [root@serv root]# mdadm -Eb /dev/hdg8
> ARRAY /dev/md5 level=raid5 num-devices=3 
> UUID=adecf616:84cf5266:310000c4:ec3729e7
>    devices=/dev/hdg8
> [root@serv root]# mdadm -Eb /dev/hdh6
> ARRAY /dev/md5 level=raid5 num-devices=3 
> UUID=adecf616:84cf5266:30d2b689:003729e7
>    devices=/dev/hdh6
> 
> [root@serv root]# mdadm -Af /dev/md5 /dev/hde8 /dev/hdf6 /dev/hdg8 /dev/hdh6
> mdadm: superblock on /dev/hdg8 doesn't match others - assembly
> aborted

Try leaving out /dev/hdg8:

  madm -Af /dev/md5 /dev/hde8 /dev/hdf6 /dev/hdg8 /dev/hdh6

hdg8 seem to have a different UUID anyway - are you sure it is part of
the same array.

NeilBrown

> 
> [root@serv root]# mdadm -V
> mdadm - v1.3.0 - 29 Jul 2003
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
