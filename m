From: Matthew Mitchell <matthew@geodev.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 13:03:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE76EDA.1060000@geodev.com>
References: <3EE74472.9010505@geodev.com> <1055350640.1929.28.camel@langvan.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1055350640.1929.28.camel@langvan.austin.ibm.com>
To: Mike Tran <mhtran@us.ibm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Tran wrote:
> On Wed, 2003-06-11 at 10:02, Matthew Mitchell wrote:
> 
>>Hello everyone,
>>
>>In the interest of keeping around some otherwise-functional Sparcs, I 
>>was asked if it would be possible to move a linux md raid set from an 
>>Intel box to a Sun box.  I said, "Sure," and then immediately wondered 
>>about byte ordering -- will this work?  Take the SCSI box off of the 
>>intel, plug it into the sparc, and try to run the array...
>>
>>Then my next thought was that someone here would know the answer. :)
>>
> 
> 
> It will not work. The on-disk MD superblock is written using cpu arch
> format.  Furthermore, let's say you are able to re-create the raid5
> array after moving it to the Sun box.  What about the filesystem and
> data?  At least you need a filesystem which manipulates its metadata in
> neutral format for this kind of "move" to work.

As I feared.

What _about_ the filesystem and data, though?  Some filesystems are 
certainly written in a known byte-order, like ISO 9660.  Are there any 
of (ext3, XFS, JFS, reiserfs) that this is true for?  Or are they all 
written in cpu native byte-order?

-- 
Matthew Mitchell
Systems Programmer/Administrator            matthew@geodev.com
Geophysical Development Corporation         phone 713 782 1234
1 Riverway Suite 2100, Houston, TX  77056     fax 713 782 1829

