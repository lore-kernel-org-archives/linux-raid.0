From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 10:54:21 +1100
Message-ID: <17358.54573.969464.886120@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43CCA80B.4020603@tls.msk.ru>
	<20060117095019.GA27262@localhost.localdomain>
	<43CCD453.9070900@tls.msk.ru>
	<20060117160829.GA16606@lug.udel.edu>
	<43CD3388.9050107@tls.msk.ru>
	<20060118081407.GC18945@localhost.localdomain>
	<43CE3898.7090207@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Hendrikx on Wednesday January 18
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 18, hjohn@xs4all.nl wrote:
> 
> I agree with the original poster though, I'd really love to see Linux 
> Raid take special action on sector read failures.  It happens about 5-6 
> times a year here that a disk gets kicked out of the array for a simple 
> read failure.  A rebuild of the array will fix it without a trace, but a 
> rebuild takes about 3 hours :)

See 2.6.15 (for raid5) or 2.6.16-rc1 (for raid1).  You'll love it!

NeilBrown
