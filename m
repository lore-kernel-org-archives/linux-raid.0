From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: unknown partition table starting with 2.6.28
Date: Fri, 15 Jan 2010 16:58:06 -0700
Message-ID: <4B51010E.9090800@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to update my kernel from 2.6.26.8 to the current .32. 
Starting at .27 I get an acpi conflict:

ACPI: Power Button (CM) [PWRB]
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
ACPI: I/O resource nForce2_smbus [0x1c40-0x1c7f] conflicts with ACPI 
region SM01 [0x1c40-0x1c45]
ACPI: Device needs an ACPI driver
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
ACPI: Expecting a [Reference] package element, found type 0
thermal LNXTHERM:01: registered as thermal_zone0

Starting with .28 I am getting an error about unknown partition table 
for all 3 md's. md0 is boot and main programs, md1 is swap, md2 is 
mostly recordings storage for vdr. All 3 are raid 1 and raid is built in.

dmesg for .28 boot: http://pastebin.com/m1a459731
dmesg for .29 boot: http://pastebin.com/m419d7207


I tried to go directly to .32.2 but it didn't even mount md2. But that 
might have been an error by me. So was stepping through kernels to see 
where/if it stopped mounting.

The acpi error was known and seemed to effect all nforce chipset boards. 
I'm hoping that one is fixed.
