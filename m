From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 13:53:13 +0200
Message-ID: <edc08e93-8af7-a48d-3dbf-f49df399622b@thelounge.net>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <58FC91B8.5090603@youngman.org.uk>
 <69b83c56-4d88-bd6d-1189-02f9d231bb00@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <69b83c56-4d88-bd6d-1189-02f9d231bb00@powerlamerz.org>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, Wols Lists <antlists@youngman.org.uk>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 23.04.2017 um 13:47 schrieb Patrik Dahlström:
> 
> 
> On 04/23/2017 01:36 PM, Wols Lists wrote:
>> On 23/04/17 12:12, Patrik Dahlström wrote:
>>> At least I now know in what order that I should assemble my original 5
>>> drives:
>>> sda, sdb, sdd, sdc, sde
>>> It would only be logical for the new drive (sdf) to be last in that list.
>>
>> And, as the raid wiki tells you, download lspci and run that. That will
>> hopefully tell us a lot about what's left of the various headers on your
>> disks.
> I didn't find that part on the wiki. Here's the output of lspci

"lspci" is surely nonsense but even "lsscsi" by looking at the 
helpoutput hardly shows "various headers on your disks", so when someone 
recommends a command and it's only useful with a defined set of 
non-default params he should mention that clearly instead point to some 
random command

> 00:00.0 Host bridge: Intel Corporation Sky Lake Host Bridge/DRAM Registers (rev 07)
> 00:14.0 USB controller: Intel Corporation Sunrise Point-H USB 3.0 xHCI Controller (rev 31)
> 00:14.2 Signal processing controller: Intel Corporation Sunrise Point-H Thermal subsystem (rev 31)
> 00:16.0 Communication controller: Intel Corporation Sunrise Point-H CSME HECI #1 (rev 31)
> 00:17.0 SATA controller: Intel Corporation Sunrise Point-H SATA controller [AHCI mode] (rev 31)
> 00:1c.0 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root Port #5 (rev f1)
> 00:1c.5 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root Port #6 (rev f1)
> 00:1c.6 PCI bridge: Intel Corporation Sunrise Point-H PCI Express Root Port #7 (rev f1)
> 00:1f.0 ISA bridge: Intel Corporation Sunrise Point-H LPC Controller (rev 31)
> 00:1f.2 Memory controller: Intel Corporation Sunrise Point-H PMC (rev 31)
> 00:1f.4 SMBus: Intel Corporation Sunrise Point-H SMBus (rev 31)
> 01:00.0 PCI bridge: ASPEED Technology, Inc. AST1150 PCI-to-PCI Bridge (rev 03)
> 02:00.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED Graphics Family (rev 30)
> 03:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
> 04:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)

