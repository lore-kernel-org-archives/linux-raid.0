From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: anybody using the gc-ramdisk?
Date: Mon, 4 Jan 2010 21:24:55 -0700
Message-ID: <201001042124.56019.tfjellstrom@shaw.ca>
References: <xuu2aawtfu4c.fsf@nowhere.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <xuu2aawtfu4c.fsf@nowhere.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Megacz <adam@megacz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon January 4 2010, Adam Megacz wrote:
> Has anybody tried using the GC-Ramdisk (aka iRAM -- four DDR DIMMs on a
> PCI card with a battery backup)
> 
>  
>  http://www.gigabyte.com.tw/Products/Storage/Products_Overview.aspx?Produ
> ctID=2180 http://en.wikipedia.org/wiki/I-RAM
> 
> Performance is much better than flash memories, but the price per
> gigabyte is much greater and maximum capacity is far less.  It's really
> closer to the nvram cache on a hardware raid card than an SSD.  The fact
> that it loses data after 16 hours without power is a little worrisome,
> although it uses a standard nimh battery so you can replace that with
> something that lasts a lot longer...
> 
> Anyways, I'd be interested in hearing about anybody's experience with it.
> 
> I'm thinking of using this for my md write intent bitmap and ext4
> journal, with "-o data=ordered" so close() and fsync() return as soon as
> the data hits the DIMMs -- no need to wait for the disk to rotate around.
> 
> Any comments?
> 
> So often I hear debates about "hardware raid" versus "software raid"
> which are actually debates over whether or not you ought to have some
> sort of battery-backed write cache around.

If I had one I might use it as a fs-cache.

>   - a
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
