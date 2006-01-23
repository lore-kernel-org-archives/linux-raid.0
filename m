From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Selective spin-up
Date: Mon, 23 Jan 2006 17:09:25 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0601231648480.14030@shaka.acc.umu.se>
References: <43D2EBC1.1000007@xs4all.nl> <43D32E3A.4020508@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D32E3A.4020508@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: John Hendrikx <hjohn@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 22 Jan 2006, Brad Campbell wrote:

> John Hendrikx wrote:
>> I recently extended my raid array with a 9th drive, and I find that the 300 
>> watt PSU I use is insufficient to start the system.  What happens is that I 
>> activate the machine, the machine starts powering up for 3 seconds orso 
>> (spinning all the hard drives up about half way) then power cuts out.  I've 
>> heard that it is possible to spin up disks one at a time or in groups, but 
>> cannot find any such option in the BIOS (Asus A8N-E board).  Any ideas?

And just in response to the original question, this is called "staggered 
spin-up" and is usually a feature of larger raid/scsi controllers and 
intelligent backplanes. Usually not found in cheap hardware.

> I had a similar problem with a 480W PSU and my 15 drive array..
> I looked for selective spinup and other hacks, but to be honest I figured 
> that even if the trip point is under spin up load only, I was running the PSU 
> too close to the wire to be comfortable.
> I bought a 600W unit and re-wired it's dual 12V rails to do the job.. Problem 
> solved.

Heh, I just did this for an 18 drive machine too. Much better than the old 
duct-taped 2 PSU "solution":

http://www.acc.umu.se/~maswan/bilder/20060117-Kryddis/

> I also run a smart check every morning (6 days short 1 day long) 
> simultaneously on all drives to make sure the system behaves under load.
>
> Do yourself a favour and grab a shiny new PSU.. I have 14 Drives hanging off 
> a 420W unit in my other box that behave perfectly..
>
> Just look at the the 12V rail capacity on any PSU you choose and make sure it 
> will cope with the spool up load. I grabbed Maxtor's docs on these drives, 
> calculated the load for 15 drives and worked from there.. My practical 
> measurements came to within about 15% of the theoretical so the docs are not 
> to bad.

Don't forget to take a look at the 5V load too. The last batch of drives I 
got for that machine was hitatchi sata drives which claims 1.3A in "max 
r/w load". Lots of PSUs even with high W-ratings (600/800) have only 20 or 
30A rated 5V load, and you want some left over for the rest of the system.

Now, if I could only get rid of these load-induced sata_sil (or whatever 
it is) cold hangs everything would be awesome. :)

/Mattias Wadenstein
