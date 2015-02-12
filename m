From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: RE: RAID 1 metadata - keep separate from mirror disks ?
Date: Thu, 12 Feb 2015 03:42:18 -0800 (PST)
Message-ID: <879b697f-44ad-4e4e-9255-3919837812b1@default>
References: <79c7cd53-bb6c-4058-95ad-7ebd56cf1056@default>
 <54DB6BF0.3040309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DB6BF0.3040309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Phil . This helps.

/Suresh


-----Original Message-----
From: Phil Turmel [mailto:philip@turmel.org] 
Sent: Wednesday, February 11, 2015 8:19 PM
To: Suresh Babu Kandukuru; linux-raid@vger.kernel.org
Subject: Re: RAID 1 metadata - keep separate from mirror disks ?

Good morning Suresh,

On 02/11/2015 07:14 AM, Suresh Babu Kandukuru wrote:
> Hi There,
> 
> On the RAID 1  metadata: is there  any way to keep the metadata 
> separate from the mirror disks?  Could you  guide us on this ?, 
> please. In general, we need to keep all metadata off the device 
> itself, leaving all the device available for user data. This is 
> particularly important in the migration case, where we want to take an 
> existing LUN and add a second leg to it to create the mirror device 
> without changing any of the data or metadata on the LUN.

If you look at "man 4 md" you'll see some options.  If a legacy array type meets your needs, you can operate without metadata at all.  Use "mdadm --build" to assemble your raid at each boot.

Or, if your storage server can insert a leg ahead of you current LUN, you can then create the array with an explicit data offset matching the size of the inserted leg.  Create it degraded with the existing LUN, then add (a) LUN(s) to start mirroring.  This process will leave you the option to resize with more legs later.

Or you can add a leg to the end and create your array with version 1.0 metadata, which is placed at the end of the device.

Finally, you could write your own metadata container service for use with mdmon.  (That's a bit beyond my ability, sorry.)

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
