From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 10:48:39 +0100
Message-ID: <4DDA2D77.1050604@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <BANLkTi=az3ny5m7Mf20t5fnFj79CsowJWg@mail.gmail.com> <4DD97C83.4050907@truschnigg.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD97C83.4050907@truschnigg.info>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: Tobias McNulty <tobias@caktusgroup.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/05/2011 22:13, Johannes Truschnigg wrote:
> On 05/22/2011 10:57 PM, Tobias McNulty wrote:
>> Case in point: I have 4 of these 2TB Green drives in a RAID5 array.  I
>> assembled them from the raw devices (no partition table) without any
>> special precautions.  Am I in trouble?  The array seems to be working
>> fine...
> 
> No, you aren't. If you don't create a partition table in the first
> place, there's no possibility for partition boundaries to be mis-aligned
> in regard to the physical sector or erase block size of the underlying
> blockdevice. You could probably still get it wrong if you chose (if

Pardon what is probably a very ignorant question, but someone earlier in
this thread claimed that some adaptors report the size of the disk
slightly differently?  Wouldn't this potentially cause problems if you
needed to move the disks to a different controller?

Additionally if you needed to replace the disk then some new batch might
be some few sectors smaller?  This seems to be the biggest reason for
wanting to add a partition table and then deliberately partition some
10s MB smaller? (Think I saw this exact problem come up several times in
the last few weeks alone?)

Cheers

Ed W
