From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: 3Ware on 64bit Linux.
Date: Wed, 8 Jun 2005 14:56:45 -0700
Message-ID: <200506081456.45807.hjm@tacgi.com>
References: <602f2f2b050608100938ddad81@mail.gmail.com> <200506081156.31051.hjm@tacgi.com> <20050608213615.GC14944@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050608213615.GC14944@sam.triumf.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Olchanski <olchansk@sam.triumf.ca>
Cc: Jason Leach <jason.leach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 08 June 2005 2:36 pm, Konstantin Olchanski wrote:
> I have a 3ware 8506-12 SATA controller with 12 WD 250 GByte SATA disks,
> on an old dual opteron-242 Tyan mobo. The system disk is a
> separate 80 GB IDE disk. The SATA disks are confugured into 2
> striped (one hardware raid, one software raid) logical volumes (1.5 TB
> each). The box and the hot-swap disk enclosure is el-cheapo stuff
> from Hard Data in Edmonton, AB (works great!).
>
> This system has been rock solid from day one, running RedHat 9 (32-bit),
> then Fedora 1 (32-bit), than Fedora 2 and 3 (64-bit).

That's what you get for living the clean life in Vancouver ;)  If the 
hardware's flaky, everything else will be too.  And as KO alludes, 
reliability and cost do NOT go hand in hand.

Do you know if you're using the SD or JD versions of the disks?  

> I use the 3ware driver that comes with the Red Hat kernels, the
> additional monitoring tools from 3ware do not work. SMART monitoring
> works via "smartctl -a -d 3ware,0 /dev/twe0".

I suspect that the reason it doesn't work is that it's the 32 bit version.  
The 64b version works for me - not great, but it works.  Or are you saying 
that it IS the 64b version and it doesn't work?  The 64b version is called 
3dm2 (as opposed to the previous 3dm)

I'll try direct SMART monitoring as well - thanks for the tip.

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
