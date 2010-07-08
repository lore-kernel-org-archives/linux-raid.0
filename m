From: Tim Small <tim@buttersideup.com>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Thu, 08 Jul 2010 11:05:48 +0100
Message-ID: <4C35A2FC.5080402@buttersideup.com>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Daniel Pittman <daniel@rimspace.net>, linux-raid@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Wed, 7 Jul 2010, Daniel Pittman wrote:
>
>> No.  OTOH, the poor sysadmins version of the "disk identification
>> light" is:
>>
>>    sudo dd if=/dev/sdFAIL of=/dev/null
>>
>> ...plus a pair of eyes.  FWIW.
>
> Yeah, if the drive is failed or if I know what drive to access I have
> no problem identifying it (I can access the working array and see what
> drive slots blink and which don't, or try to access the failed drive).
> But I have right now no way to identify the drive on "ata14.00". I can
> from dmesg deduce that it's most likely /dev/sdj (by observing the
> order of things being identified), but I don't know for sure it seems.
>

Whilst SCSI drives have the ability to blink the activity light, I don't
think SATA drives have this (BICBW).  Are these links any use to you:

root@ermintrude:~# ls
'/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block'
sda

?

Could you access all the other drives, and thus eliminate them from your
enquiries?  Bit naff, but better than nothing...

Tim.
