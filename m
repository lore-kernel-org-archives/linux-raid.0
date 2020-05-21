From: antlists <antlists@youngman.org.uk>
Subject: Re: disks & prices plus python (was "Re: failed disks, mapper, and
 "Invalid argument"")
Date: Thu, 21 May 2020 14:07:27 +0100
Message-ID: <326faa2c-ba38-6cd4-c09c-ea321779e339@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk> <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk> <20200521110103.GG1415@justpickone.org>
 <5EC66C2E.90901@youngman.org.uk> <20200521123059.GN1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200521123059.GN1415@justpickone.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/05/2020 13:30, David T-G wrote:
> % > %
> % > % Seagate Barracudas:-(
> % >
> % > Yep.  They were good "back in the day" ...
> %
> % Still are. Just not for raid..
> 
> Oh!  Well, that's nice to know.  Of course, I had been hoping to move
> these out to another system after upgrading to larger, but maybe that's
> not an option:-(   They are going to be worlds better than the existing
> crap drives in there now, though, so here's hoping I can put them to use.

General advice is don't use them for parity raid - ie 5 or 6! They're 
okay (but not adviseable) for mirrors.

So if you really want to use them in a raid array, I'd go for a 6TB 
raid-10. Okay, you've lost 3TB of disk space, but you've bought a 66% 
chance of surviving a 2-disk failure.

I'm not sure what I'm going to do with mine. I've bought an add-in eSATA 
card to go with my eSATA drive bay, so I may well use them as external 
backups.

Cheers,
Wol
