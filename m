From: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Subject: Re: dd version I used is 5.2.1, but...
Date: Wed, 02 Mar 2005 10:43:05 +0100
Message-ID: <42258AA9.9090000@variant.ch>
References: <4224C871.2000802@variant.ch> <20050302074533.GA5347@middle.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050302074533.GA5347@middle.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi

Jurriaan wrote:
> - please group messages in the same thread, thank you.

sorry for that.

> - if there is no answer within a day, wait some more - not everybody is
>   constantly reading this list, you know.

thanks for the tip.

> - wrt your question: how are those raid-controllers on your motherboard?

actually, I could not find very much info about this. all I know is:

1. the SiI 3114 chip is (by specification of the chip, found at SiI's 
site) connected by a PCI bus, 32bit wide, at 66mhz. however, I don't 
know whether Asus chose to connect it at 33mhz. lspci says it's 66mhz, 
but is this information trustworthy? nvidia tech specs of nforce4 sli 
(the chipset I have) says its PCI bridges are 33mhz only [1].

2. the nforce4 sata ports are (to my knowledge) directly connected to 
the nforce4 chipset.

>   If they are all connected through a single pci-bus, the speed is
>   reasonable. The best way to test if it's your motherboard or your
>   raid, is to start multiple dd processes on different disks, or
>   multiple bonnie++ processes on different disks, all concurrently, of
>   course.

good idea (thought about it too). results of concurrent reads on all 
eight drives show that the nforce4 sata ports perform quite well at 
211MiB/s (52MiB/s per drive), however the SiI 3114 seemed to saturate at 
129MiB/s (32MiB/s per drive). added, this gives at total throughput of 
340MB/s.

non-concurrent dd gives for both controllers values seemingly bound by 
drive performance of 60MiB/s.

thanks & regards
nicola

[1]: http://nvidia.com/page/pg_20041015917263.html
