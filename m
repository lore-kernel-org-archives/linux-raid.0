From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 1 metadata - keep separate from mirror disks ?
Date: Wed, 11 Feb 2015 09:49:20 -0500
Message-ID: <54DB6BF0.3040309@turmel.org>
References: <79c7cd53-bb6c-4058-95ad-7ebd56cf1056@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79c7cd53-bb6c-4058-95ad-7ebd56cf1056@default>
Sender: linux-raid-owner@vger.kernel.org
To: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Suresh,

On 02/11/2015 07:14 AM, Suresh Babu Kandukuru wrote:
> Hi There,
> 
> On the RAID 1  metadata: is there  any way to keep the metadata
> separate from the mirror disks?  Could you  guide us on this ?,
> please. In general, we need to keep all metadata off the device
> itself, leaving all the device available for user data. This is
> particularly important in the migration case, where we want to take
> an existing LUN and add a second leg to it to create the mirror
> device without changing any of the data or metadata on the LUN.

If you look at "man 4 md" you'll see some options.  If a legacy array
type meets your needs, you can operate without metadata at all.  Use
"mdadm --build" to assemble your raid at each boot.

Or, if your storage server can insert a leg ahead of you current LUN,
you can then create the array with an explicit data offset matching the
size of the inserted leg.  Create it degraded with the existing LUN,
then add (a) LUN(s) to start mirroring.  This process will leave you the
option to resize with more legs later.

Or you can add a leg to the end and create your array with version 1.0
metadata, which is placed at the end of the device.

Finally, you could write your own metadata container service for use
with mdmon.  (That's a bit beyond my ability, sorry.)

Phil
