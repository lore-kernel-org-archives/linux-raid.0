From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Concatenation with redundancy
Date: Tue, 7 Sep 2004 15:09:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409071909.i87J9N321438@watkins-home.com>
References: <56EE8176-00EE-11D9-94CF-0005023722B8@ubb.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56EE8176-00EE-11D9-94CF-0005023722B8@ubb.ca>
To: 'Tony Mantler' <nicoya@ubb.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can see how this would be useful.
Being able to add disks over time, and of different sizes.
The parity disk would be the biggest.
Disks tend to get larger over time.  So, when you add a disk it will tend to
be larger than any of the others.  The current parity would be re-used to
extend the size, and the new disk would become the new parity.

What would happen when you replace a failed disk with a new larger disk?
Just waste the extra space?

The performance would not be too good.  Like raid5 on a real real bad day!

I don't like concatenated disks.  You can't balance the load on the drives.
I would never use this feature if it did exist.  But, some would love it I
bet.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tony Mantler
Sent: Tuesday, September 07, 2004 12:53 PM
To: linux-raid@vger.kernel.org
Subject: Concatenation with redundancy

Hello,

Recently I've seen a growing trend in creating very ad-hoc storage 
arrays for storing large quantities of media files (videos, music, 
etc). These arrays are usually initially created with a small number of 
concatenated drives, say 2 or 3, but over time can easily grow to span 
6 or 8 drives as personal budgets allow.

Obviously as time goes by the exposure to a single drive failure taking 
down the whole filesystem increases considerably, and I've seen this 
happen a number of times. Due to the size (frequently 1-2tb) and nature 
of data on the array, backup is usually impractical.

It would seem that the current options for combining redundancy with 
flexible expansion capability leave a little to be desired. RAID 10 
presents far too much wasted space for this type of application, and 
RAID 50 offers much less flexibility than is desired, and is still too 
inefficient for the number of drives in question.

Thus the idea came to me for creating a somewhat new RAID level, which 
would be a concatenation with dedicated parity. Call it RAID 4C maybe, 
as in "RAID 4, but concatenated rather than striped".

Thus, the data would appear as thus:

drive 1   drive 2   .. parity drive
block 1 ~ block N+1 .. = parity 1
block 2 ~ block N+2 .. = parity 2
..
block N ~ block N+M .. = parity N

This would allow for inserting new drives without mangling the block 
order, thus preserving the data on the array. Ideally it would also be 
possible to create a heterogeneous array by ensuring that the parity 
drive was equal to or larger than the largest data drive, and assuming 
zeroed blocks for all non-present sectors.


So, am I smoking crack here? Does anyone think this would be worth 
implementing? Has this already been implemented and I just haven't seen 
it?


Cheers - Tony 'Nicoya' Mantler :)

--
Tony 'Nicoya' Mantler -- Master of Code-fu -- nicoya@ubb.ca
--  http://nicoya.feline.pp.se/  --  http://www.ubb.ca/  --

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

