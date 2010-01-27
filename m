From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: How can I tell what drive is sdb?
Date: Thu, 28 Jan 2010 01:21:53 +1100
Message-ID: <18879E40-1CB7-47B0-90C5-1F4483729E3D@crc.id.au>
References: <1264601024.29409.19.camel@thor> <bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com> <4B604B2B.7070602@computer.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B604B2B.7070602@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 28/01/2010, at 1:18 AM, Jan Ceuleers wrote:

> Matt Garman wrote:
>>> Is there a way to identify what drive is what?
>> 
>> Sometimes you can infer from dmesg.  E.g., type "dmesg | less" then
>> scroll until you see where sdb is initialized; it might show the model
>> and serial number of the drive.
>> 
>> Another approach is to use smartctl, i.e.: "sudo smartctl -a
>> /dev/sdb".  This will definitely show you the model and serial number.
>> You can also use hdparm for the same effect: "sudo hdparm -I
>> /dev/sdb".
>> 
>> I'm sure there's more ways, but those are the first that come to mind.
> 
> I'm guessing that the OP is looking for ways to identify disks without disassembling them all.
> 
> In the networking world, you can ask the system to tell you which network interface is which, by blinking the network LEDs (using ethtool -p). Is there something similar for disks?

I used a similar method. I have a SATA enclosure that takes 3 x 5.25" bays and gives me 4 x hot swap SATA bays.

As each bay has a power and an activity LED I can do something simple like:
			dd if=/dev/sdb of=/dev/null

The bay that has sdb will have a constantly on activity light.

If you don't have enclosures, then this becomes somewhat difficult.

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299






