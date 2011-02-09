From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: SSD - TRIM command
Date: Wed, 09 Feb 2011 01:44:31 -0600
Message-ID: <4D5245DF.4020401@hardwarefreak.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com> <4D517F4F.4060003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D517F4F.4060003@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maurice put forth on 2/8/2011 11:37 AM:
> On 2/7/2011 1:07 PM, Roberto Spadim wrote:
>> hi guys, could md send TRIM command to ssd? using ext4 discart mount option?
>> if i mix ssd and hd, could this TRIM be rewrite to non TRIM compatible disks?
>>
> I have read that using md with SSDs is not a great idea:
> Form the Fedora 14 documentation:

Using any RAID level but pure striping with SSDs is a bad idea, for the exact
reason in that documentation:  excessive writes.

SSD - Solid State Drive

Note the first two words.  Solid state device = integrated circuit.  ICs,
including those comprised of flash memory transistors, have totally different
failure modes than spinning rust disks, SRDs, or "plain old mechanical hard drives".

RAID'ing SSDs with any data duplicative RAID level, any mirroring or parity RAID
levels, _decreases_ the life of all SSDs in the array.  This is the opposite
effect of what you want:  reliability and lifespan.

People have a misconception that SSDs are like hard disks.  The only thing they
have in common is that both store data and they can have a similar interface
(SATA).  The similarities end there.

RAID is not a proper method of extending the life of SSD storage nor protecting
the data on SSD devices.  If you want to pool all the capacity of multiple SSDs
into a single logical device, use RAID 0 or spanning, _not_ a mirror or parity
RAID level.  If you want to protect the data, snap it to a single large SATA
drive, or a D2D backup array, and then to tape.

-- 
Stan
