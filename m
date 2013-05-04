From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Failed during rebuild (raid5)
Date: Sat, 4 May 2013 06:14:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305040606250.24367@uplift.swm.pp.se>
References: <51839E4F.7050102@midgaard.us> <5183A1C7.5000905@mpstor.com> <20130503124023.GB27548@cthulhu.home.robinhill.me.uk> <20867.49429.400548.184315@quad.stoffel.home> <alpine.DEB.2.00.1305031826270.24367@uplift.swm.pp.se>
 <20868.4128.968574.378273@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20868.4128.968574.378273@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 3 May 2013, John Stoffel wrote:

> 200T?  Isn't that a little big?  *grin* Actually I think the warning 
> should be based on both number of devices in the array and the size of 
> members and the speed of the individual devices.

Yeah, I meant GB.

> Makeing a RADI5 with 10 RAM disks that are 10Gb each in size and can 
> write at 500MB/s might not that bad a thing to do.  I'm being a little 
> silly here, but I think the idea is right.  We need to account for all 
> three factors of a RAID5 array:  number of devices, size, and speed of 
> each devices.

Well, yes, 3 devices might be ok for RAID5, but for 4 devices or more I 
would like the operator to read a page and make a really informed 
decision, warning them about the consequences of RAID5 on large drives.

This page could also inform users about the mismatched SATA timeout (or we 
actually get the SATA layer default changed from 30 to 180 seconds), 
because right now I'd say 30 seconds isn't good for anything. RAID drives 
have 7 seconds default before reporting an error, making 30 seconds too 
long, and consumer drives have 120 seconds (?) making 30 seconds way too 
short.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
