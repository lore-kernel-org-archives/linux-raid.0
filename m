From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Partitioned raid and major number
Date: Wed, 25 Feb 2004 18:46:31 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c1iqi7$glv$1@terminus.zytor.com>
References: <20040225145624.GA1513@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20040225145624.GA1513@cistron.nl>
By author:    Miquel van Smoorenburg <miquels@cistron.nl>
In newsgroup: linux.dev.raid
>
> Hello,
> 
> 	I see that Linus merged partitioned raid into bitkeeper.
> The major number of partitioned raid devices is allocated dynamically.
> 
> I want to set up a server with 2 disks in RAID1 mode, partitioned.
> To be able to boot from it, the RAID1 device needs to have a fixed
> major number (I don't want to be forced to use an initrd). Is it
> planned to ask LANANA for a fixed major number? If not, would a
> patch to pass the major number on the kernel command line be accepted ?
> 

Please ask <device@lanana.org> for a device number.  Make sure to
specify if it's 2.6-specific (and hence will be assigned a number
above 255) or not.

	-hpa
