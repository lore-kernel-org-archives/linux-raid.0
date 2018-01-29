From: David Brown <david.brown@hesbynett.no>
Subject: Re: Implementing Global Parity Codes
Date: Mon, 29 Jan 2018 11:22:53 +0100
Message-ID: <bcd4cf40-dba6-1c52-ab8a-6884290215fa@hesbynett.no>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
 <5A6C3A43.6030701@youngman.org.uk>
 <CACm9mdWs0d+Fo32AQ3prMuJhfsmECK2jBw-0O7D-KR=LNWtyvw@mail.gmail.com>
 <5A6C972C.8070401@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A6C972C.8070401@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, mostafa kishani <mostafa.kishani@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 27/01/2018 16:13, Wols Lists wrote:
> On 27/01/18 14:29, mostafa kishani wrote:
>> Thanks for your response Wol
>> Well, maybe I failed to illustrate what I'm going to implement. I try
>> to better clarify using your terminology:
>> In the normal RAID5 and RAID6 codes we have one/two parities per
>> stripe. Now consider sharing a redundant sector between say, 4
>> stripes, and assume that the redundant sector is saved in stripe4.
>> Assume the redundant sector is the parity of all sectors in stripe1,
>> stripe2, stripe3, and stripe4. Using this redundant sector you can
>> tolerate one sector failure across stripe1 to stripe4. We already have
>> the parity sectors of RAID5 and RAID6 and this redundant sector is
>> added to tolerate an extra sector failure. I call this redundant
>> sector "Global Parity".
>> I try to demonstrate this as follows, assuming each RAID5 stripe has 3
>> data sectors and one parity sector.
>> stripe1: DATA1 | DATA2 | DATA3 | PARITY1
>> stripe2: PARITY2 | DATA4 | DATA5 | DATA6
>> stripe3: DATA7 | PARITY3 | DATA8 | DATA9
>> stripe4: DATA10 | DATA11 | PARITY4 | GLOBAL PARITY
>>
>> and the Global Parity is taken across all data and parity as follows:
>> GLOBAL PARITY = DATA1 X DATA2 X DATA3 X DATA4 X DATA5 X DATA6 X DATA7
>> X DATA8 X DATA9 X DATA10 X DATA11 X PARITY1 X PARITY2 X PARITY3
>>
>> Where "X" stands for XOR operation.
>> I hope it was clear.
> 
> OWWW!!!!
> 
> Have you done and understood the maths!!!???

I have started looking at the paper (from the link in Mostafa's next 
post).  I have only read a few pages as yet, but it looks to me to have 
some fundamental misunderstandings about SSDs, how they work, and their 
typical failures, and to be massively mixing up the low-level structures 
visible inside the SSD firmware and the high-level view available to the 
kernel and the md layer.  At best, this "PMDS" idea with blocks might be 
an alternative or addition to ECC layers within the SSD - but not at the 
md layer.  I have not read the whole paper yet, so I could be missing 
something - but I am sceptical.


> 
> You may have noticed I said that while raid-6 was similar in principle
> to raid-5, it was very different in implementation. Because of the maths!

Yes, indeed.  The maths of raid 6 is a lot of fun, and very smart.

> 
> Going back to high-school algebra, if we have E *unique* equations, and
> U unknowns, then we can only solve the equations if E > U (I think I've
> got that right, it might be >=).

E >= U.  You can solve "2 * x - 4 = 0", which is one equation in one 
unknown.  But critically, the E equations need to be linearly 
independent (that is probably what you mean by "unique").

> 
> With raid-5, parity1 = data1 xor data2 xor data3. Now let's assume
> somebody thinks "let's add parity2" and defines parity2 = data1 xor
> data2 xor data3 xor parity1. THAT WON'T WORK. 

Correct - this is because the two equations are not linearly 
independent.  The second parity would always be 0 in this case.

> Raid-5 relies on the
> equation "if N is even, then parity2 is all ones, else parity2 is all
> zeroes", where N is the number of disks, so if we calculate parity2 we
> add absolutely nothing to our pre-existing E.
> 
> If you are planning to use XOR, I think you are falling into *exactly*
> that trap! Plus, it looks to me as if calculating your global parity is
> going to be a disk-hammering nightmare ...

Yes.

> 
> That's why raid-6 uses a *completely* *different* algorithm to calculate
> its parity1 and parity2.

It is not actually a completely different algorithm, if you view it in 
the correct way.  You can say the raid5 parity P is just the xor of the 
bits, while the raid6 parity Q is a polynomial over the GF(2^8) field - 
certainly they look completely different then.  But once you move to the 
GF(2^8) field, the equations become:

	P = d_0 + d_1 + d_2 + d_3 + d_4 + ...
	Q = d_0 + 2 . d_1 + 2^2 . d_2 + 2^3 . d_3 + 2^4 . d_4 + ...

(Note that none of this is "ordinary" maths - addition and 
multiplication is special in the GF field.)

It is even possible to extend it to a third parity in a similar way:

	R = d_0 + 4 . d_1 + 4^2 . d_2 + 4^3 . d_3 + 4^4 . d_4 + ...

There are other schemes that scale better beyond the third parity (this 
scheme can generate a fourth parity bit, but it is then only valid for 
up to 21 data disks).

> 
> I've updated a page on the wiki, because it's come up in other
> discussions as well, but it seems to me if you need extra parity, you
> really ought to be going for raid-60. Take a look ...
> 
> https://raid.wiki.kernel.org/index.php/What_is_RAID_and_why_should_you_want_it%3F#Which_raid_is_for_me.3F
> 
> and if anyone else wants to comment, too? ...
> 

Here are a few random comments:

Raid-10-far2 can be /faster/ than Raid0 on the same number of HDs, for 
read-only performance.  This is because the data for both stripes will 
be read from the first half of the disks - the outside half.  On many 
disks this gives higher read speeds, since the same angular rotation 
speed has higher linear velocity at the disk heads.  It also gives 
shorter seek times as the head does not have to move as far in or out to 
cover the whole range.  For SSDs, the layout for Raid-10 makes almost no 
difference (but it is still faster than plain Raid-1 for streamed reads).

For two drives, Raid-10 is a fine choice on read-heavy or streaming 
applications.

I think you could emphasise that there is little point in having Raid-5 
plus a spare - Raid-6 is better in every way.

You should make a clearer distinction that by "Raid-6+0" you mean a 
Raid-0 stripe of Raid-6 sets, rather than a Raid-6 set of Raid-0 stripes.

There are also many, many other ways to organise multi-layer raids. 
Striping at the high level (like Raid-6+0) makes sense only if you have 
massive streaming operations for single files, and massive bandwidth - 
it is poorer for operations involving a large number of parallel 
accesses.  A common arrangement for big arrays is a linear concatenation 
of Raid-1 pairs (or Raid-5 or Raid-6 sets) - combined with an 
appropriate file system (XFS comes out well here) you get massive 
scalability and very high parallel access speeds.

Other things to consider on big arrays are redundancy of controllers, or 
even servers (for SAN arrays).  Consider the pros and cons of spreading 
your redundancy across blocks.  For example, if your server has two 
controllers then you might want your low-level block to be Raid-1 pairs 
with one disk on each controller.  That could give you a better spread 
of bandwidths and give you resistance to a broken controller.

You could also talk about asymmetric raid setups, such as having a 
write-only redundant copy on a second server over a network, or as a 
cheap hard disk copy of your fast SSDs.

And you could also discuss strategies for disk replacement - after 
failures, or for growing the array.

It is also worth emphasising that RAID is /not/ a backup solution - that 
cannot be said often enough!

Discuss failure recovery - how to find and remove bad disks, how to deal 
with recovering disks from a different machine after the first one has 
died, etc.  Emphasise the importance of labelling disks in your machines 
and being sure you pull the right disk!



> Cheers,
> Wol
