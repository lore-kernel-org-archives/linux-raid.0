From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: recorvery from Raid5 multiple disk failture
Date: Fri, 16 Dec 2005 07:40:18 -0600
Message-ID: <1134740418.17084.39.camel@star2.austin.ibm.com>
References: <200512161345.33159.hn75@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200512161345.33159.hn75@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: hn75@gmx.d
List-Id: linux-raid.ids

On Fri, 2005-12-16 at 06:45, Hendrik Naumann wrote:
> Hi
> 
> I have a Linux-Software-Raid5 consisting of three partitions (hda2,
> hde2 and hdf2). After a failure of hdf I replaced the disk and added
> hdf2 into the raid again. During the resynchronization process hda
> broke down. 
> 
> I am not completely shure how much of the synchronization
> was already done, but I think it was quite at the end, because the 
> gzipped dd-image of hdf2 and hde2 have very similar sizes. 
> 
> mdadm shows hde2 as a active, clean disk within the raid and hdf2 as a
> clean spare disk. In the Software-Raid-Howto it was stated that
> rewriting the superblocks (I suspect hdf2 to clean active) could be a
> possibility to regain some data from the Raid. 
> 
> How is this possible with mdadm? Or is there some other tool for
> manipulation the superblocks?
> 
> Many thanks in advance
> 
> Hendrik Naummann 
> 
> PS. Please add a CC hn75@gmx.de because up to now I am no subscriber 
> to this list.

Since the recovery did not finish, I would do the followings:

mdadm --examine /dev/hde2 to display the raid5 configuration and note
the chunksize, parity layout, disks order,..
Recreate the array using mdadm -C with "missing" keyword
Mount the raid5 array read-only (hope that it will mount :)

--
Mike T.

