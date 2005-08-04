From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: endianness of Linux kernel RAID
Date: Thu, 4 Aug 2005 15:14:07 +1000
Message-ID: <17137.42015.808716.889138@cse.unsw.edu.au>
References: <20050803120656.GA16696@anthropohedron.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="KNBy6Hk6XL"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Botsis <aaron@blight.com>, Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--KNBy6Hk6XL
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit


Oopps....
I meant to send the following in reply to a recent message from
Gregory Seidman, but inadvertently send it in reply to an earlier
message from Aaron Botsis (which I must have missed..)

Still, the offer is open to either, or anyone else.

NeilBrown


--KNBy6Hk6XL
Content-Type: message/rfc822
Content-Description: forwarded message
Content-Transfer-Encoding: 7bit

MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <17137.41713.860387.102586@cse.unsw.edu.au>
In-Reply-To: message from Aaron Botsis on Sunday June 19
References: <61C14314-53E9-4140-A4DB-3929A683FE67@blight.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
From: Neil Brown <neilb@cse.unsw.edu.au>
To: Aaron Botsis <aaron@blight.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: raid5 endian question....
Date: Thu, 4 Aug 2005 15:09:05 +1000

On Sunday June 19, aaron@blight.com wrote:
> Hello,
> 
> I'm attempting to move a raid5 array from a big endian ppc machine to  
> a little endian x86.
> Upon trying to import the array, I get:
> mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc,  
> got fc4e2ba9)
> 
> I assume this to be an endianess issue...
> Is this a bug? Is just the magic number whacked? or are the  
> superblock data structures too?
> 
> what's the best way to fix this?

As has been said, the original raid superblock (still the default)
uses host-endian data and so cannot be moved between machines.
The new version uses little-endian, but isn't in wide use yet.

It would not be too hard to get mdadm to re-write the superblocks when
assembling an array on a different machine.  However I am not in a
position to test it very well.

If you would be willing to help test some changes over the next
several days, I'd be happy to add this functionality to mdadm.
The risk of data-loss for you would be very remote.  However there
would be some risk of extended down-time while you wait for me to fix
some silly bug.

The change would involve:
  1/ Teaching "mdadm --examine" to recognise a wrong-endian superblock
     and display it with suitable swaps.
  2/ Teaching "mdadm --assemble" to accept "--update=endian" which
     would byte-swap all the superblocks and write them out again.

NeilBrown

 

--KNBy6Hk6XL--
