From: "John Stoffel" <john@stoffel.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 14:39:47 -0400
Message-ID: <18200.63987.514073.184865@stoffel.org>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
	<18200.56684.14194.630264@stoffel.org>
	<1192813877.1666.79.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192813877.1666.79.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Doug" == Doug Ledford <dledford@redhat.com> writes:

Doug> On Fri, 2007-10-19 at 12:38 -0400, John Stoffel wrote:
>> 1, 1.0, 1.1, 1.2
>> 
>> Use the new version-1 format superblock.  This has few restrictions.
>> The different sub-versions store the superblock at different locations
>> on the device, either at the end (for 1.0), at the start (for 1.1) or
>> 4K from the start (for 1.2).
>> 
>> 
>> It looks to me that the 1.1, combined with the 1.0 should be what we
>> use, with the 1.2 format nuked.  Maybe call it 1.3?  *grin*

Doug> You're somewhat misreading the man page. 

The man page is somewhat misleading then.  It's not clear from reading
it that the version 1 RAID superblock can be in one of three different
positions in the volume.  

Doug> You *can't* combine 1.0 with 1.1.  All of the above options: 1,
Doug> 1.0, 1.1, 1.2; specifically mean to use a version 1 superblock.
Doug> 1.0 means use a version 1 superblock at the end of the disk.
Doug> 1.1 means version 1 superblock at beginning of disk.  `1.2 means
Doug> version 1 at 4k offset from beginning of the disk.  There really
Doug> is no actual version 1.1, or 1.2, the .0, .1, and .2 part of the
Doug> version *only* means where to put the version 1 superblock on
Doug> the disk.  If you just say version 1, then it goes to the
Doug> default location for version 1 superblocks, and last I checked
Doug> that was the end of disk (aka, 1.0).

So why not get rid of (deprecate) the version 1.0 and version 1.2
blocks, and only support the 1.1 version?  

Why do we have three different positions for storing the superblock?  

And if putting the superblock at the end is problematic, why is it the
default?  Shouldn't version 1.1 be the default?  

Or, alternatively, update the code so that we support RAID superblocks
at BOTH the beginning and end 4k of the disk, for maximum redundancy.

I guess I need to go and read the code to figure out the placement of
0.90 and 1.0 blocks to see how they are different.  It's just not
clear to me why we have such a muddle of 1.x formats to choose from
and what the advantages and tradeoffs are between them.

John


