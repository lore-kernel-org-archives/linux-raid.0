From: Brian Candler <B.Candler@pobox.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 17:15:09 +0000
Message-ID: <20120316171509.GD49365@nsrc.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
 <4F61803A.60009@hardwarefreak.com>
 <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
 <20321.63389.586851.689070@tree.ty.sabi.co.UK>
 <CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
 <20322.29849.917554.794740@tree.ty.sabi.co.UK>
 <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Fri, Mar 16, 2012 at 11:36:07AM +0800, Jessie Evangelista wrote:
> I'm still scouring the internet for a best practice recipe for
> implementing xfs/mdraid.
> I am open to writing one and including the inputs everyone is contributing here.
> In my search, I also saw some references of alignment issues for partitions.
> this is what I used to setup the partitions for the md device
> 
> sfdisk /dev/sdb <<EOF
> unit: sectors
> 
> 63,104872257,fd
> 0,0,0
> 0,0,0
> 0,0,0
> EOF
> 
> I've read a recommendation to start the partition on the 1MB mark.
> Does this make sense?

I would just make the raw disks members of the RAID array, e.g.
/dev/sdb, /dev/sdc etc and not partition them.
