From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 16:37:58 +0100
Message-ID: <4C067AD6.7040700@anonymous.org.uk>
References: <87k4qho723.fsf@uwo.ca>	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry> <876321o3lm.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <876321o3lm.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/06/2010 16:29, Dan Christensen wrote:
[...]
> Do the stats below support the theory that these are timeouts due to
> media errors?  Does anyone know if Samsung Spinpoint drives can be
> tweaked to not try so hard to retrieve data?  Or is it possible to make
> the kernel more tolerant of such timeouts?

My Samsung Spinpoint F1's can have TLER enabled using a more recent 
smartctl. It's not appeared as part of a formal release yet but a patch 
went in to r3065 in SVN: 
http://sourceforge.net/apps/trac/smartmontools/log/trunk/smartmontools

Cheers,

John.

