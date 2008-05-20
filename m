From: "David Lethe" <david@santools.com>
Subject: RE:  Re:  Re: Two Drive Failure on RAID-5
Date: Tue, 20 May 2008 15:09:04 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C71AE0B@34093-C3-EVS3.exchange.rackspace.com>
References: <loom.20080519T224713-779@post.gmane.org> <48327FC2.1010901@dgreaves.com> A<loom.20080520T145950-804@post.gmane.org> <A20315AE59B5C34585629E258D76A97C71AC52@34093-C3-EVS3.exchange.rackspace.com> A<loom.20080520T184705-265@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: A<loom.20080520T184705-265@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is a good analogy that puts this in perspective.  I haven't seen
anybody equate the two yet, so get the name right if you quote this ;)

Disk drives are like light bulbs. You can buy the server class (similar
to CFLs), or desktop (incandescent).  If you don't mind the dark,
replace them as they fail, and buy spares as they go on sale.
Conversely, if you have to maintain a vaulted ceiling chandelier, and
are afraid of heights, then spending twice as much for never having to
deal with *THAT* again will seem like a bargain.

- David Lethe



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Cry
Sent: Tuesday, May 20, 2008 2:01 PM
To: linux-raid@vger.kernel.org
Subject: Re: Re: Two Drive Failure on RAID-5

David Lethe <david <at> santools.com> writes:

> Cry wrote:
>> By the way, I'm thinking about buying five of these:
>> 
>> Seagate Barracuda 7200.11 1TB ST31000340AS SATA-II 32MB Cache
>> 
>> and one of these:
>> 
>> Supermicro SUPERMICRO CSE-M35T-1 Hot-Swapable SATA HDD Enclosure
>> 
>>
http://www.supermicro.com/products/accessories/mobilerack/CSE-M35T-1.cfm
>>
>> Any feedback on the above?  Is there a suggestion on an
>> inexpensive controller to give more SATA ports that is very software
>> raid compatible?
> 
> Respectfully .. are you nuts??? 

Probably, thats why I asked for a sanity check.

I had originally gotten a batch of six extremely inexpensive WD 500GB
drives.  I
have now had 4 of those six drives go tango uniform since May of 07.
None of
the replacement drives I've purchased (samsung, hitachi) have reported
even a
single SMART error.  For my personal systems these are the first drives
I've had
crash in 20 years.

> Don't buy the 7200.11 disks.   You bought a bunch of desktop class
> drives, and they crapped out on you, and you are about to make the
same
> mistake again.  Get the server class disk that is designed to run 24x7
> duty cycle, which in your case would be the 'cuda ES.2

If I go with the 'cuda ES.2 is that enough risk management to stick with
a
raid-5 arrangement?  I am doing this on my own dime so if I can go with
four
drives now instead of five it would pay for the increased drive grade.  

> Sorry about the soapbox, but it never ceases to amaze me how people
try
> to save by buying disk drives architected with lowest possible cost in
> mind, and don't investigate the higher-quality disks that are designed
> for extended reliability and data integrity.

That is the RAID meme.  If you have the redundancy why spend money on
the fancy
drives?  On the other hand, four drives crashing has cost me about $500
dollars
in replacement drives and lots of time.

Always looking for an angle ;-)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


