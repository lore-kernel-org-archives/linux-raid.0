From: Tony Mantler <nicoya@ubb.ca>
Subject: Concatenation with redundancy
Date: Tue, 7 Sep 2004 11:52:44 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <56EE8176-00EE-11D9-94CF-0005023722B8@ubb.ca>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

