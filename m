From: Luca Berra <bluca@comedia.it>
Subject: Re: Suggestion needed for fixing RAID6
Date: Fri, 23 Apr 2010 08:51:43 +0200
Message-ID: <20100423065143.GA17743@maude.comedia.it>
References: <626601cae203$dae35030$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <626601cae203$dae35030$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 22, 2010 at 12:09:08PM +0200, Janos Haar wrote:
> Hello Neil, list,
>
> I am trying to fix one RAID6 array wich have 12x1.5TB (samsung) drives.
> Actually the array have 1 missing drive, and 3 wich have some bad sectors!
> Genearlly because it is RAID6 there is no data lost, because the bad 
> sectors are not in one address line, but i can't rebuild the missing drive, 
> because the kernel drops out the bad sector-drives one by one during the 
> rebuild process.

I would seriously consider moving the data out of that array and dumping
all drives from that batch, and this is gonna be painful because you
must watch drives being dropped and add them back, and yes you need the
resources to store the data.

ddrescue won't obviously work, since it will mask read errors and turn
those into data corruption

the raid 1 trick wont work, as you noted

another option could be using the device mapper snapshot-merge target
(writable snapshot), which iirc is a 2.6.33+ feature
look at
http://smorgasbord.gavagai.nl/2010/03/online-merging-of-cow-volumes-with-dm-snapshot/
for hints.
btw i have no clue how the scsi error will travel thru the dm layer.
L.

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
