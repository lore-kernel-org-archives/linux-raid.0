From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Random Seek on Array as slow as on single disk
Date: Mon, 17 Jul 2006 09:23:38 +0200 (MEST)
Message-ID: <Pine.GSO.4.64.0607170918450.23815@montezuma.acc.umu.se>
References: <20060716153736.E36C5200967@smtp.funpic.de>
 <20060716163931.D95FE200970@smtp.funpic.de> <20060716164930.5DBFF200973@smtp.funpic.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060716164930.5DBFF200973@smtp.funpic.de>
Sender: linux-raid-owner@vger.kernel.org
To: "A. Liemen" <maillist@liemen.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 16 Jul 2006, A. Liemen wrote:

> Hardware Raid.
>
> http://www.areca.com.tw/products/html/pcix-sata.htm

If you want to see even worse performance with bonnie, try running several 
parallel in sync, somewhere around 6-15 simultaneous read sessions[*] 
should give you rather horrible performance numbers.

That said, synthetic benchmarks isn't everything. Check if it is an issue 
with realistic load too. In some cases there can be quite a difference.

/Mattias Wadenstein

[*] Exact numbers may vary, for me it was as low as 6 on a 12-disk raid6 
where the throughput dropped from ~300M/s to ~30M/s, but smaller raidsets 
had a breakoff point up close to 8-10 reading procseses.

> Jeff Breidenbach schrieb:
>>> Controller: Areca ARC 1160 PCI-X 1GB Cache
>> 
>> Those numbers are for Arica hardware raid or linux software raid?
>> --Jeff
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
