From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Raid 10 Issue
Date: Sun, 8 Mar 2015 14:59:07 +0000
Message-ID: <BLU436-SMTP14223DDFE1692D64CB12C24981A0@phx.gbl>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de>
	 <54F8B792.9060206@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F8B792.9060206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2015-03-05 at 15:07 -0500, Phil Turmel wrote:
> On 03/05/2015 12:56 PM, Stefan Lamby wrote:
> > Hello List.
> > 
> > I was setting up a new machine using ubuntu 14.04.02 lts using its installer,
> > configuring a raid 10 with 2 disks and lvm on top of it. I was using 2 disks and
> > now I like to add 2 more disks to the array so i want to end up with 4 disks, no
> > spare.
> > 
> > Searching the internet I found that I am not able to --grow the array with the
> > mdadm version this ubuntu is using (v3.2.5).
> > Is that right?
> > 
> > So I decided to build a new array that way and try to move my data afterwards,
> > which failed:
> > (Is it OK to do it that way or do you recommend another?)
> 
> No, you should be able to do this.  Probably without any shutdown.
> Please show the full layout of your drives, partitions, and lvm.
> 
> I suggest lsdrv[1] for working layouts.  If your email is set to use
> utf8, just paste the result in a reply.
> 
> Regards,
> 
> Phil Turmel
> 
> [1] https://github.com/pturmel/lsdrv

OT: What a fantastic little script, a couple of my biggest annoyances
with my set up was that it was a pain to track "os disk designation" to
"serial no." making identifying the physical device a chore. 

Also one of my cheap "4 port sata" cards doesn't identify port number on
the device and while it was possible to work it out by tracing device
serial-sata cable-socket then mentally comparing sd*-device serial=port
it was something I was putting off as "a pain" but also being bugged by
my md member devices numbers being out of whack with my sd designations:
sda[4] sdb[2] sdc[1] sdd[3] and with 12 devices the last thing you want
when something is failing is to have to hunt around to work out which
device physically relates to which os identified device. 

With this I can now easily mark my disks with a simple set of
identification, likewise the cable on both ends, and make a sketch of
ports and their sequences and which disk in which slot relates.

Obviously if I was starting my system from scratch I would have done all
this from the get go... but after 4 cases, various upgrades and
additions, differing numbers of MB sata ports, and various sata cards
and multiple variations of md's/partition layouts it all became a huge
muddle and one elegant script has made it simple to finally do what I
have put of for far to long.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


