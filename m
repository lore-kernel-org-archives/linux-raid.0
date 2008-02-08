From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Any inexpensive hardware recommendations for PCI interface cards?
Date: Fri, 08 Feb 2008 07:56:02 -0500
Message-ID: <47AC5162.4080700@tmr.com>
References: <11ae01c86a44$aff357a0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11ae01c86a44$aff357a0$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steve Fairbairn wrote:
> Can anyone see any issues with what I'm trying to do?
>   

No.

> Are there any known issues with IT8212 cards (They worked as straight
> disks on linux fine)?
>   

No idea, don't have that card.

> Is anyone using an array with disks on PCI interface cards?
>   

Works. I've mixed PATA, SATA, onboard, PCI, and firewire (lack of 
controllers is the mother of invention). As long as the device under the 
raid works, the raid should work.

> Is there an issue with mixing motherboard interfaces and PCI card based
> ones?
>   

Not that I've found.

> Does anyone recommend any inexpensive (probably SATA-II) PCI interface
> cards?
>   

Not I. Large drives have have cured me of FrankenRAID setups recently, 
other than to build little arrays out of USB devices for backup.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


