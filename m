From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 13 Feb 2005 20:27:40 -0800
Message-ID: <421028BC.6040902@nsr500.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com> <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:
> 
> Anyone using Tyan Thunder K8W motherboards???
> 
> I now know, there is a K8S (server?) version of that mobo, but at the time
> it was all orderd, I wasn't aware of it - my thoughts are there there is
> some sort of PCI/PCI-X problem with either the motherboard or the chipset,
> and in all probability the K8S mobo will have the same chipsset and same
> problems anyway...

I'm using a K8W at work as a driver client for NAS testing.  Onboard 
Broadcom GigE, Linksys Marvell GigE, 2xWD1200JD + 2xMaxtor Maxline Plus II 
as RAID-0 and RAID-5 using the Sil_3114, 2.4.29, raidtools 1.0.  2+2x1GB 
PC-2700 in first and third slots for each CPU.  All PCI-X/HT configs set to 
  Auto in BIOS and Jumpers, 2.02b BIOS.  No issues except for a bad SATA cable.

Striping yields ~90MB/s, RAID-5 about 65r, 55w on 8GB Bonnie++ runs, 2GB dd 
reads on raw devices yields ~55MB/s

Fedora Core 2 tests next week.



-- 

