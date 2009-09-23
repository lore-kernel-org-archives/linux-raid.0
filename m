From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Wed, 23 Sep 2009 15:42:43 +0100
Message-ID: <4ABA33E3.4050403@anonymous.org.uk>
References: <200909230956588.SM01420@trainer>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909230956588.SM01420@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: Sunpyo Hong <sunpyo.hong@amac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/09/2009 14:56, Sunpyo Hong wrote:
> I actually know the physical order of each HD. I was able to pull them out
> of the NAS in the order specified in the NAS. (Each HD enclosure was
> labeled) In the actual sata ports, this is what the hds are in.
> 
> SATA 0: HD1
> SATA 1: HD2
> SATA 2: HD3
> SATA 3: HD4
> SATA 4: CD-ROM
> 
> I think that linux reads the sata ports like.. 0 = sda, 1=sdb.. etc. So I
> assume that HD1 = /dev/sda (missing), HD2 = /dev/sdb, HD3 = /dev/sdc, HD4 =
> /dev/sdd so a create command should look like this:
> 
> #mdadm -Cv -level=5 --raid-disks=4 missing /dev/sdb4 /dev/sdc4 /dev/sdd4
> 
> This is exactly how I wrote the create command. Again I knew the physical
> order of the Raid and put them together in that order. Tell me if I'm doing
> something wrong. 

If HD1 is really missing, and you've rebooted, then HD2 will now be sda, 
HD3 sdb, HD4 sdc, and your command is

#mdadm -Cv -level=5 --raid-disks=4 missing /dev/sda4 /dev/sdb4 /dev/sdc4

Cheers,

John.
