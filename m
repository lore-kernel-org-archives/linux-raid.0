From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: making new device names with mknod
Date: Wed, 11 Sep 2002 09:00:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15742.31103.899153.146439@notabene.cse.unsw.edu.au>
References: <3D7E6020.8030402@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Norman Schmidt on Tuesday September 10
To: schmidt@naa.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 10, norman.schmidt@ratnet.stw.uni-erlangen.de wrote:
> Hi!
> 
> Can somebody tell me how to make new device names in /dev?
> I have installed two additional ide controllers and want to make md
> devices out of partitions on devices /dev/hde, /dev/hdg, /dev/hdi and
> /dev/hdk. In /dev, there are only devices up to hdh. In addition to
> that, I would need to make the /dev entries for the partitions.
> 
> Is it possible to use more than 16 md devices, how can I make /dev/md16
> and so on?
> 
> I am using Debian Woody, so no makedev, only mknod is available.

/dev/MAKEDEV ide4 ide5

should make hd[ijkl]....

MAKEDEV doesn't seem to know about md devices > 15.
If you changed

        md)
                major=`Major md 9` || continue
                for part in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
                do
                        makedev md$part b $major $part $disk
                done
                ;;

to

        md)
                major=`Major md 9` || continue
                for part in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 \
                       17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
                do
                        makedev md$part b $major $part $disk
                done
                ;;

then 
  /dev/MAKEDEV md

should make you 31 md devices.

NeilBrown
