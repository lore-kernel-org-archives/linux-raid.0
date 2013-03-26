From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 19:11:07 -0600
Message-ID: <6B4029D8-5139-4FCE-B7FE-4C5D6057E969@colorremedies.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com> <5150E665.2090902@gmail.com> <843EA420-6F4A-41DF-BDED-7F35D6263A87@colorremedies.com> <5150F101.6020205@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5150F101.6020205@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 25, 2013, at 6:51 PM, maurice <mhilarius@gmail.com> wrote:

> On 3/25/2013 6:40 PM, Chris Murphy wrote:
>> ..No. It'll be fine with that. It does partition drives though, not arrays. Chris Murphy
> 
> Are you saying that it could not create the partitions on the RAID?

The only partition layout I've seen any version of anaconda create is partitioning physical devices, and then adding those partitions as member devices in an array. Maybe partitionable arrays are possible with kickstart.

> So, would I have to prepare the RAID first on another machine?

I haven't tried doing this with the old anaconda, so I don't know if it will see a pre-created array that it doesn't create itself; let alone if it will honor the partitions in the array.


Chris Murphy