From: maarten <maarten@ultratux.net>
Subject: Re: create raid5 with missing disk; not possible?
Date: Fri, 14 Jan 2005 22:15:01 +0100
Message-ID: <200501142215.01847.maarten@ultratux.net>
References: <41E82CF6.2080203@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E82CF6.2080203@avz.xs4all.nl>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 14 January 2005 21:35, Ferenc-Jan wrote:
> Hello,
>
> I tried to create a raid5 set with 3 partitions and one missing device:

That should work.

> mdadm -C /dev/md1 -R -l5 -n4 /dev/hda3 /dev/hdc3 /dev/hdd3 missing

Maybe it's in the syntax.  What is that -R doing here ?

> Later I want to add the fourth device with mdadm /dev/md1 -a /dev/hdb3.

I do 'mdadm -a  /dev/md1 /dev/hdb3'.  Maybe that makes a difference ?

> But this becomes a spare and I always end up with the missing drive in
> sync, mdadm -D /dev/md1:
>
> <snip>
> 3       0        0        0      sync
>
> I want to do this so I can use hdb to transfer data from an harddisk to
> the raid5 set. Maybe this is only possible with Raid 1 sets?

No, this should be possible.  Many people do this.  

P.S.: You _are_ aware of the dangers of using raid-5 on drives that share the 
same IDE cable ?  I see you use hda+hdb and hdc+hdd...
In practise this could mean that if one drive fails you could lose all your 
data (unless you manually repair / reassemble the array)

(Just making sure you don't make the same mistake I made...)

Maarten

