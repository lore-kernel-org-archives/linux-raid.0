From: Tom Walsh <tom@openhardware.net>
Subject: Re: array always resyncs on boot
Date: Sat, 29 Nov 2008 21:21:03 -0500
Message-ID: <4931F88F.9000300@openhardware.net>
References: <4931B2C5.5060403@openhardware.net> <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan> <4931E75D.5080905@openhardware.net> <alpine.DEB.1.10.0811292015010.7720@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811292015010.7720@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> 
> On Sat, 29 Nov 2008, Tom Walsh wrote:
> 
>> Justin Piszcz wrote:
>>>
> 
> [ .. snip .. ]
> 
>> From your dmesg, you need to figure out why it is assembling only 5
> out of the 6 disks, is it kicking a non-fresh one out of the array, or..?
> 

[...]
> 
> 1. Remove quiet from the boot options (in lilo.conf or grub.conf)
> 2. Send an updated e-mail with the boot message.
> 3. Try to capture all of the dmesg/syslog when you shutdown and send 
> that as well.
> 
> 
> Also see below, are all of these drives on the -SAME- controller?
> http://www.newegg.com/Product/Product.aspx?Item=N82E16813128347
> 

Yes, they are.  Something keeps nagging at me.  I think that about 3 
months ago I did a urpmi update and it replaced the kernel, or I allowed 
it to.  The system that I had back then, that was working with the ICH10 
chip was a 2.6.22 kernel (Mandriva customized).

I've noticed in the dmesg output that the 'md:' does not finish scanning 
the sata drives before the raid10 module starts, as evidenced here in 
this dmesg snippet:


ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: SSDT 7FEE8700, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20040311)
ACPI: CPU3 (power states: C1[C1] C2[C2])
processor ACPI0007:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
md: bind<sdf5>
md: bind<sde5>
md: bind<sdb5>
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
md: bind<sda5>
md: bind<sdc5>
md: raid10 personality registered for level 10
raid10: raid set md0 active with 5 out of 6 devices
md: bind<sdd5>
RAID10 conf printout:
  --- wd:5 rd:6
  disk 0, wo:0, o:1, dev:sda5
  disk 1, wo:0, o:1, dev:sdb5
  disk 2, wo:0, o:1, dev:sdc5
  disk 3, wo:1, o:1, dev:sdd5
  disk 4, wo:0, o:1, dev:sde5
  disk 5, wo:0, o:1, dev:sdf5
md: recovery of RAID array md0

================================================


If you notice, '^raid10: ...' announcement preceeds the '^md: 
bind<sdd5>' announcement?  Then, the raid10 conf printout shows that a 
different status for the dev:sdd5 ??  I googled this message and it 
seems to tie in with what may be happening here, see:

http://archive.netbsd.se/?ml=linux-ide&a=2008-08&t=8302899

In that message, he talks about "hard resetting link" problems and 
failing to properly assemble the array.

In all this madness of mine in these past 5..6 days, I'd forgotten that 
I put the drive array onto an old AMD Sempron system here and installed 
Mandriva 2008 onto it.  That seemed to work without a problem.  That is 
a 2.6.22 kernel.

I'm going to focus briefly on the kernel version as I see sometime 
around either 2.6.24 or 2.6.26 that some work on the ICH10 driver was 
being done.  Prior to that version, the ide_generic was used with the 
ICH10 and you had to enable the AHCI Bios on the motherboard.

I'll let you know...  This may be a driver issue.

TomW


-- 
Tom Walsh - WN3L - Embedded Systems Consultant
http://openhardware.net http://cyberiansoftware.com http://openzipit.org
"Windows? No thanks, I have work to do..."
----------------------------------------------------

