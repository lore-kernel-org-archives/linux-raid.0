From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Convert RAID 5 to RAID 6 while reducing array size
Date: Wed, 11 May 2011 16:49:45 +0100
Message-ID: <4DCAB019.3070508@anonymous.org.uk>
References: <34905057-B75E-4721-B6D2-7B9FA733BCA8@brillgene.com> <5D271CD8-AE79-441F-A6FA-AF0E5D481E4D@brillgene.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5D271CD8-AE79-441F-A6FA-AF0E5D481E4D@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman@brillgene.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/05/2011 20:50, Anshuman Aggarwal wrote:
> Hi,
> I'm trying to convert a 6 device raid5 into a raid6. The 6th device was added into the Raid 5 by mistake instead of a grow operation to convert it into a RAID 6. As such the md device is not being used beyond the size that it had when it was a 5 device raid5.
>
> Can this be done in a single grow step by specifying the reduced size (--array-size=xx) and new layout (l=6)?

Yes it can, with mdadm 3.1.x and a suitably recent kernel. You will need 
a backup file on another drive, the same as you did to reshape your 
RAID5 from 5 to 6 devices. If you have grown your filesystem, you will 
need to shrink it again BEFORE attempting the reshape.

Cheers,

John.

