From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing a RAID-0 "internally"?
Date: Wed, 08 Jun 2011 19:50:21 -0500
Message-ID: <4DF018CD.80205@hardwarefreak.com>
References: <BANLkTi=kM_3Aadv7Y8ime2MGgPEJL_+7Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=kM_3Aadv7Y8ime2MGgPEJL_+7Yw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/8/2011 3:34 PM, Patrick J. LoPresti wrote:
> Hi.  I have a RAID-0 striped across two partitions; let's call them
> /dev/sda2 and /dev/sdb2 (equal size).  These partitions do not stretch
> to the end of the respective drives; that is, there is also a
> /dev/sda3 and /dev/sdb3 (also equal size).
> 
> I want to delete partitions sda3 and sdb3, resize sda2 and sdb2 to
> consume the additional space, and then grow my RAID-0 array to use it.
> 
> I know how to perform every step (e.g., modifying partition tables,
> resizing the file system) except for one:  How do I use mdadm to
> change the size of the drives inside the RAID-0 array?  Or is this not
> supported?

AFAIK you cannot currently grow (or shrink) an md RAID0 or RAID10.
According to 'man mdadm':

Grow

Grow (or shrink) an array, or otherwise reshape it in some way.
Currently supported growth options including changing the active size of
component devices in RAID level 1/4/5/6 and changing the number of
active devices in RAID1.

-- 
Stan
