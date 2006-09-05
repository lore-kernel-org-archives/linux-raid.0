From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Tue, 5 Sep 2006 18:49:27 +0200
Message-ID: <20060905164927.GA17634@percy.comedia.it>
References: <1155987607.7207.23.camel@localhost.localdomain> <17641.25141.373827.77279@cse.unsw.edu.au> <1156200453.19051.13.camel@fc6.xsintricity.com> <44FC68A8.4010002@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44FC68A8.4010002@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 04, 2006 at 01:55:52PM -0400, Bill Davidsen wrote:
>Doug Ledford wrote:
>>It's the mount program collecting possible LABEL= data on the partitions
>>listed in /proc/partitions, of which sde3 is outside the valid range for
>>the drive.
>>
>May I belatedly say that this is sort-of a kernel issue, since 
>/proc/partitions reflects invalid data? Perhaps a boot option like 
>nopart=sda,sdb or similar would be in order?
>
i would move partition detection code to user space completely, so it
could be ran selectively on the drives that do happen to have a patition
table.

a compromise could be having mdadm (or the script that starts mdadm at
boot time, issue an ioctl(fd,BLKPG,...) to make kernel forget about any
eventual partition table it might have misdetected
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
