From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Thu, 13 Sep 2012 14:13:05 -0600
Message-ID: <DA01BB41-EA5A-4023-B8EA-D2778DF537F6@colorremedies.com>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <CABYL=TpKNm9NAnrpdu5GWb-4cAVX24pwY6-1uLn_aGhy+FQL+w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TpKNm9NAnrpdu5GWb-4cAVX24pwY6-1uLn_aGhy+FQL+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 13, 2012, at 11:39 AM, Roberto Spadim wrote:

>> "check" records errors, no action is taken by the md driver to correct it, although the disk firmware itself may try reallocation. So far, that appears to not be the case.
>> 
>> "repair" causes the md driver to write correct data (from copy or reconstructed from parity), which should force the disk firmware to reallocate the affected LBAs from bad physical sectors to good ones.
>> 
>> It seems in this case "repair" is indicated.
>> 
> Or replace the bad disk =)

Yes or replace the disk. But from the SMART info provided, it's just a few sectors that are affected. None of the attribute values have even budged so far.

Chris Murphy