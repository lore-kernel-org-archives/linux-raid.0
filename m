From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Wed, 27 Jul 2016 15:57:27 +0100
Message-ID: <22424.52183.725484.31671@tree.ty.sabi.co.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
	<22423.44287.974770.114127@tree.ty.sabi.co.uk>
	<5797C5CE.6020300@youngman.org.uk>
	<CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
	<22424.46474.87462.226497@tree.ty.sabi.co.uk>
	<5798BAA3.60108@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5798BAA3.60108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Wed, 27 Jul 2016 14:44:03 +0100, Wols Lists <antlists@youngman.org.uk> said:

> On 27/07/16 14:22, Peter Grandi wrote:
>> Also, if the data is just 4.5TB, why not go for just a 3x
>> RAID5 with the 3x 4TB drives, which a usable capacity of 8TB?
>> A degree of redundancy of 1-in-3 is not bad. It would have
>> less IOPS though.

> The problem is that one of the three new 4TB drives is
> currently part of the old - partly failed - array. So without
> buying a fourth 4TB drive, that option isn't on the table.

A and B are the 2TB drives, C, D and E the 4TB drives.

* Copy the 4.5TB if they can be compressed to drive E (it does
  not neet to be partitioned).
* Setup drives C and D as a degraded (3-1)x RAID5.
* Create a RAID0 of the 2x 2TB drives.
* Add the RAID0 as the 3rd member to the new RAID5.
* Copy the 4.5TB from drive E to the new RAID5.
* Wait for sync to finish.
* Stop the RAID5 set.
* Copy by 'dd' the RAID0 set's content to drive E.
* Stop the RAID0 set and '--zero' A and B.
* Start the RAID5.
* Reuse A and B for something else.
