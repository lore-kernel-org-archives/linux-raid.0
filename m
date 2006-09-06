From: John McMonagle <johnm@advocap.org>
Subject: Re: RAID-5 recovery
Date: Wed, 06 Sep 2006 16:13:35 -0500
Message-ID: <44FF39FF.3000007@advocap.org>
References: <200609031148.56910.clive@vacuumtube.org.uk>	<Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org> <17659.44517.186189.152370@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17659.44517.186189.152370@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday September 3, dean@arctic.org wrote:
> 
>>On Sun, 3 Sep 2006, Clive Messer wrote:
>>
>>
>>>This leads me to a question. I understand from reading the linux-raid archives 
>>>that the current behaviour when rebuilding with a single badblock on another 
>>>disk is for that disk to also be kicked from the array.
>>
>>that's not quite the current behaviour.  since 2.6.14 or .15 or so md will 
>>reconstruct bad blocks from other disks and try writing them.  it's only 
>>when this fails repeatedly that it knocks the disk out of the array.
> 
> 
> "when rebuild" md/raid5 cannot reconstruct bad blocks because the
> array is degraded, so a read error is immediately fatal.
> 
> NeilBrown
> 

Don't keep up as much as I should, but is there now an attempt to
automatically fix disk read errors?

If so what version of kernel and mdadm are required?
Also if true does this apply to other raid levels like 1, 6 and 10?

Thanks

John

