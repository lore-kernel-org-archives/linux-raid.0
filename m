From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Fri, 22 Jun 2007 08:12:58 -0700 (PDT)
Message-ID: <244245.14152.qm@web55804.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>, greenjelly <big_green_jelly_Bean@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Brad Campbell brad@wasp.net.au

> I've got 2 boxes. One has 14 drives and a 480W PSU and the other has 15 drives and a 600W PSU. It's 
> not rocket science.

Where did you find reasonably priced cases to hold so many drives? Each of my home servers top out at 8 data drives each - plus a 20Gb one to boot from.


Graham


----- Original Message ----
From: Brad Campbell <brad@wasp.net.au>
To: greenjelly <big_green_jelly_Bean@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, 20 June, 2007 4:52:38 PM
Subject: Re: Software based SATA RAID-5 expandable arrays?


greenjelly wrote:

> The options I seek are to be able to start with a 6 Drive array RAID-5
> array, then as my demand for more space increases in the future I want to be
> able to plug in more drives and incorporate them into the Array without the
> need to backup the data.  Basically I need the software to add the
> drive/drives to the Array, then Rebuild the array incorporating the new
> drives while preserving the data on the original array.

I've got 2 boxes. One has 14 drives and a 480W PSU and the other has 15 drives and a 600W PSU. It's 
not rocket science. Put a lot of drives in a box, make sure you have enough sata ports and power to 
go around (watch your peak 12V consumption on spin up really) and use linux md. Easy.. Oh, but make 
sure the drives stay cool!

For a cheap-o home server (which is what I have) I'd certainly not bother with a dedicated RAID 
card. You are not even going to need GB ethernet really.. I've got 15 drives on a single PCI bus, 
it's as slow as a wet week in may (in the southern hemisphere), but I'm streaming to 3 head units 
which total a combined 5MB/s if I'm lucky.. Rebuilds can take up to 10 hours though.

> QUESTIONS
> Since this is a media server, and would only be used to serve Movies and
> Video to my two machines It wouldn't have to be powered up full time (My
> Music consumes less space and will be contained on two seperate machines). 
> Is there a way to considerably lower the power consumption of this server
> the 90% of time its not in use?

Yes, don't poll for SMART and spin down the drives when idle (man hdparm). Use S3 sleep and WOL if 
you are really clever. (I'm not, my boxes live in a dedicated server room with its own AC, but 
that's because I'm nuts). I also have over 25k hours on the drives because I don't spin them down. I 
figure the extra power is a trade off for drive life. They've got less than 50 spin cycles on them 
in over 25k hours..

> Can Linux support Drive Arrays of Significant Sizes (4-8 terabytes)?

Yes, easily (6TB here)

> Can Linux Software support RAID-5 expandability, allowing me to increase the
> number of disks in the array, without the need to backup the media, recreate
> the array from scratch and then copy the backup to the machine (something I
> will be unable to do)?

Yes but get a cheap UPS at least (it's cheap insurance)

> I know this is a Linux forum, but I figure many of you guys work with
> Windows Server.  If so does Windows 2003 provide the same support for the
> requested requirements above?

Why would you even _ask_ ??

Read the man page for mdadm, then read it again (and a third time). Then google for "Raid-5 two 
drive failure linux" just to familiarise yourself with the background.

What you are doing has been done before many, many times. There are some well written sites out 
there relating to building exactly what you want to build with great detail.

If you are serious about using windows, I pity you.. Linux (actually a combination of the kernel md 
layer and mdadm) makes it so easy you'd be nuts to beat your head against the wall with the alternative.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


		
___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
