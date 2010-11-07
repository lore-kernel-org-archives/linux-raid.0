From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 08:51:12 +0100
Message-ID: <4CD65A70.2080302@computer.org>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD58640.2010606@computer.org> <4CD5AEDE.50501@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD5AEDE.50501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/10 20:39, Phil Turmel wrote:
> On 11/06/2010 12:45 PM, Jan Ceuleers wrote:
>> Controller device @ pci0000:00/0000:00:1c.1/0000:02:00.0 [ahci]
>>    SATA controller: JMicron Technology Corp. JMB360 AHCI Controller (rev 02)
>>      host4: [Empty]
>> Controller device @ pci0000:00/0000:00:1f.2 [ata_piix]
>>    IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA IDE Controller (rev 06)
>>      host0: /dev/sda ATA WDC WD20EADS-00R {SN: WD-WCAVY4080404}
>>      host1: /dev/sdb ATA ST3500418AS {SN: 9VMK33L9}
>>      host1: /dev/sdc ATA ST3500418AS {SN: 9VMM6EY4}
>> Controller device @ pci0000:00/0000:00:1f.5 [ata_piix]
>>    IDE interface: Intel Corporation 5 Series/3400 Series Chipset 2 port SATA IDE Controller (rev 06)
>>      host2: [Empty]
>>      host3: [Empty]
>>
[...]
> I'm guessing it's an artifact of IDE compatibility mode.
[...]

Spot on. After switching the BIOS to AHCI mode, output now looks like this:

Controller device @ pci0000:00/0000:00:1c.1/0000:02:00.0 [ahci]
   SATA controller: JMicron Technology Corp. JMB360 AHCI Controller (rev 02)
     host6: [Empty]
Controller device @ pci0000:00/0000:00:1f.2 [ahci]
   SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 
port SATA AHCI Controller (rev 06)
     host0: /dev/sda ATA WDC WD20EADS-00R {SN: WD-WCAVY4080404}
     host1: /dev/sdb ATA ST3500418AS {SN: 9VMK33L9}
     host2: [Empty]
     host3: /dev/sdc ATA ST3500418AS {SN: 9VMM6EY4}
     host4: [Empty]
     host5: [Empty]

So the south bridge is now seen as the single chip that it is, instead 
of two emulated-ones. It is now also controlled by the ahci driver. And 
all of the unused ports are there.

Great stuff, thanks.

Jan
