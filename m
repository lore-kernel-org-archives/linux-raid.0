From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: I'm Astounded by How Good Linux Software RAID IS!
Date: Tue, 25 Nov 2003 00:45:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311250045.18770.dusty@strike.wu-wien.ac.at>
References: <172.22899f68.2cf365fc@aol.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <172.22899f68.2cf365fc@aol.com>
Content-Disposition: inline
To: AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 24 November 2003 14:47, AndyLiebman@aol.com wrote:
>> Hmmm, here are some of my thoughts, maybe some of my assumptions are wrong
>> as I am no RAID expert. If so, please correct me!
>>
>> - Maximum FW-Speed = 400Mbit/s, that's with the protocol overhead ~ 35Mb/s
>> - Theoretical PCI-Bandwidth: 133 MB/s
>
>
> Do you think this 35 MB/sec applies, even though I am using 5 separate
> Firewire PCI cards? That's 5 separate channels, each of which has a 400
> Mbit/sec speed. Keep in mind that EACH drive on the RAID 5 is on it's own
> separate PCI card.

I already assumed that you use one drive on each channel. Nevertheless, the 
maximum throughput from a drive to the CPU is limited by the 400Mbit/s 
Firewire speed, that's around 35Mbyte/s.

On a first glance this is no limitation as normal IDE-Drives don't deliver 
much more than that but the interface speed can be much higher - and that's 
my point: Transfers from the internal harddisk cache to the CPU are also 
limited by the firewire speed.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

