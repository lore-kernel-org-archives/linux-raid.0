From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: 11 Jun 2003 11:57:21 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1055350640.1929.28.camel@langvan.austin.ibm.com>
References: <3EE74472.9010505@geodev.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE74472.9010505@geodev.com>
To: Matthew Mitchell <matthew@geodev.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-06-11 at 10:02, Matthew Mitchell wrote:
> Hello everyone,
> 
> In the interest of keeping around some otherwise-functional Sparcs, I 
> was asked if it would be possible to move a linux md raid set from an 
> Intel box to a Sun box.  I said, "Sure," and then immediately wondered 
> about byte ordering -- will this work?  Take the SCSI box off of the 
> intel, plug it into the sparc, and try to run the array...
> 
> Then my next thought was that someone here would know the answer. :)
> 

It will not work. The on-disk MD superblock is written using cpu arch
format.  Furthermore, let's say you are able to re-create the raid5
array after moving it to the Sun box.  What about the filesystem and
data?  At least you need a filesystem which manipulates its metadata in
neutral format for this kind of "move" to work.

Regards,
Mike Tran

