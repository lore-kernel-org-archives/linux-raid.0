From: Francisco Parada <cisco@abitofthisabitofthat.com>
Subject: Re: RAID 6 Reshape Woes
Date: Wed, 18 Nov 2015 21:45:42 -0500
Message-ID: <6D622406-5CAB-4096-987B-AA45AF9F448A@abitofthisabitofthat.com>
References: <41BC47FD-C02B-4DDA-BF1C-75032831AA29@abitofthisabitofthat.com> <564D249C.308@turmel.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564D249C.308@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Heh, but let me fix that typo:  Damn Apple ;-)
:-D I set myself up for that one!

> Time to toss some enclosures and/or cables.
Yeah, going to have to get some new toys for the holidays :-)

> Uhm, what?  What command or action did you take?  Or are you simply
> doing a "flashback" to the start of this process?
Yeah, I was just narrating my actions along with my syslog events.

> Stop the array completely.  Use --assemble --force with all of the
> drives, including the new one.  Include the same --backup-file.
Thanks, I unmounted, but my "mdadm --stop /dev/md126" command isn't exiting ... Going to give it a few more minutes. According to "ps -ef" the "/lib/systemd/systemd-udev" commanf is keeping it busy. I tried killing that PID with the "-9" argument as the root user, but no such luck.

> Likely.  Are the port multipliers capable of the same speeds as the
> drives and controllers?
I believe the enclosure's backplanes are 1.5Gbps, and maybe mismatched with my 3Gbps multiplier might be the bane of my issue.

>> What do you guys think?
> 
> New enclosures & controllers so you can ditch the port multipliers?
Yeah, I'm thinking of just building a 4U and using an LSI RAID controller I have laying around, use it as JBOD letting mdadm do the lifting, and stop with these damn cases already. I was just trying to do the best with what I had, but going this Port Multiplier route is what's getting me into this mess. I have a couple of SunFire x2270 1U systems fully spec'ed out that I wanted to take advantage of, and by using these external enclosures, I was getting around the 4 hard drive bay limitation. I guess I'll build something that's cheap just to mount the drives and share via Samba and NFS onto the SunFire systems, then do the heavy CPU lifting from there instead.

Thanks,

Cisco
