From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 14:28:24 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B207E14D1@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Mircea Ciocan <mirceac@interplus.ro>
Cc: Catalin BOIE <util@deuroconsult.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, the simplest thing would be to detach one of the mirror disks,
keep it as the backup, then insert a new one for the resync.  Is that
what you want?

Andy

-----Original Message-----
From: Mircea Ciocan [mailto:mirceac@interplus.ro] 
Sent: Wednesday, January 07, 2004 10:34 AM
To: Cress, Andrew R
Cc: Catalin BOIE; linux-raid@vger.kernel.org
Subject: Re: Please help with a special RAID 1 setup


Cress, Andrew R wrote:

>Note that RAID-1 will only ever have a maximum of 2 active disks.
>When you add the 3rd disk, it is added to the array as a spare, that's
>why it doesn't rebuild.
>
>Andy
>  
>
    Ouch, so is there really no posibility to obtain somehow what I 
explained in the previous mail ( a cvasi-realtime filesystem backup by 
attaching and detaching a device) :(((
Please tell me that there is a posibility, my world is shattered ;)
 
       Mircea

