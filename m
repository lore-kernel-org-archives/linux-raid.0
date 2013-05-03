From: "John Stoffel" <john@stoffel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 3 May 2013 15:29:36 -0400
Message-ID: <20868.4128.968574.378273@quad.stoffel.home>
References: <51839E4F.7050102@midgaard.us>
	<5183A1C7.5000905@mpstor.com>
	<20130503124023.GB27548@cthulhu.home.robinhill.me.uk>
	<20867.49429.400548.184315@quad.stoffel.home>
	<alpine.DEB.2.00.1305031826270.24367@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1305031826270.24367@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Mikael" == Mikael Abrahamsson <swmike@swm.pp.se> writes:

Mikael> On Fri, 3 May 2013, John Stoffel wrote:
>> We've got all these compute cycles kicking around that could be used to 
>> make things even more reliable, we should be using them in some smart 
>> way.

Mikael> I would like to see mdadm tell the user that RAID5 is not a recommended 
Mikael> raid level for component drives over 200 TB in size and recommend people 
Mikael> to use RAID6, and ask for confirmation from the operator to go ahead and 
Mikael> create RAID5 anyway if operator really wants that.

200T?  Isn't that a little big?  *grin*  Actually I think the warning
should be based on both number of devices in the array and the size of
members and the speed of the individual devices.  

Makeing a RADI5 with 10 RAM disks that are 10Gb each in size and can
write at 500MB/s might not that bad a thing to do.  I'm being a little
silly here, but I think the idea is right.  We need to account for all
three factors of a RAID5 array:  number of devices, size, and speed of
each devices.

John
