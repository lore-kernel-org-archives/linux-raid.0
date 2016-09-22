From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with
 xfs filesystem by accident
Date: Thu, 22 Sep 2016 11:56:13 +0200
Message-ID: <20160922095613.GA3608@metamorpher.de>
References: <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de>
 <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de>
 <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
 <20160921190035.GA6949@metamorpher.de>
 <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
 <CAKA=zHoKE69Q01oEVOCpKWzp6gQ7zO8rvY=NzuD0YoqLJdgTTQ@mail.gmail.com>
 <CAJCQCtSE1m4k_zpQxa59fZ8CK6biFSX0AUPkKCTUkNLT5y+MSA@mail.gmail.com>
 <CAKA=zHr-dwudU5bENHF_3QSG9vYi4Tib8Sg2Jq_rfqOjuF7vew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKA=zHr-dwudU5bENHF_3QSG9vYi4Tib8Sg2Jq_rfqOjuF7vew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 21, 2016 at 11:30:02PM +0200, Simon Becks wrote:
> I tried all possible orders but xfs_repair found in no round instantly
> a superblock or did the repair with flying colors.

You could also transfer the first 512K chunk of your removed disk over, 
or use the removed disk as first disk, just to see if that changes any.

You could also use only two disks (third disk missing) in case one of 
the disks had more data overwritten than the others.

But photorec not finding anything, there are two possibilities, 
one is the RAID is wrong, the other is that too much was overwritten.

You could run a mdadm check and see the number in mismatch_cnt. 
There should be some since parts were overwritten, but if the data 
were mostly intact there should not be too many.

But if it was zeroed there won't be mismatches either so you should 
probably check raw data itself too...

Regards
Andreas Klauer
