From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: faulty mdstat
Date: Fri, 8 Aug 2003 10:54:49 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16178.62681.889354.965188@gargle.gargle.HOWL>
References: <200308071420.20993.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eric BENARD / Free on Thursday August 7
To: Eric BENARD / Free <ebenard@free.fr>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday August 7, ebenard@free.fr wrote:
> Hi,
> 
> here is what /proc/mdstat gives to me after a crash of the server.
> 2 drives (one on md1 and one on md4 have de (F).
> 
> This means they are faulty.
> 
> Should I do :
> mdadm /dev/md1 -a /dev/ide/host2/bus0/target0/lun0/part5
> mdadm /dev/md4 -a /dev/ide/host2/bus0/target0/lun0/part7
> 
> or is there an other way to solve the problem ?

Depends.  If the drive is really faulty, you want to replace it.
However it is was a transient error you need to remove and then re-add
the devices:

 mdadm /dev/md1 -r /dev/ide/host2/bus0/target0/lun0/part5
 mdadm /dev/md4 -r /dev/ide/host2/bus0/target0/lun0/part7

 mdadm /dev/md1 -a /dev/ide/host2/bus0/target0/lun0/part5
 mdadm /dev/md4 -a /dev/ide/host2/bus0/target0/lun0/part7

> 
> Concerning md5 (raid 5), 3 drives are used. I assume the one marked [3] is not 
> used. What can it be used for ?

Hot spare.

NeilBrown
