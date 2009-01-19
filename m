From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 14:30:16 -0600
Message-ID: <cccedfc60901191230h29aed03dpe465c667866d5ac4@mail.gmail.com>
References: <18763.7881.300921.177207@notabene.brown>
	 <20081230191250.70701c5c@absurd>
	 <18803.53032.383350.741460@nbeee.brown>
	 <20090119122505.GB23623@rap.rap.dk>
	 <8CB487FD08E50F2-152C-7B6@webmail-dx12.sysops.aol.com>
	 <cccedfc60901191200q30ed8bcdqde2a547fc7f33df9@mail.gmail.com>
	 <87f94c370901191218u42c39716u294b92da2887d374@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370901191218u42c39716u294b92da2887d374@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: thomas62186218@aol.com, keld@dkuug.dk, neilb@suse.de, janek_listy@wp.pl, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It needn't be all that difficult. Consider the following:

you have a block layer driver which performs the following duties:

it manages a pool of N block devices
it exposes a portion of that storage as a single block device
the unexposed portion goes towards parity (in the vein of providing at
least N bits of parity protection)
the level of parity protection is applied to each block of size X. For
example a 64K block might consist of 48K of data and 16K of parity.
on top of that, the data+parity could be mirrored on N other devices,
anywhere, so long as it is mirrored on at least M other devices.

I'm just kinda thinking out loud. The duplicate block stuff could just
as easily be an md1 or md10 layer, so a new raid level might only have
to handle the parity stuff.


On Mon, Jan 19, 2009 at 2:18 PM, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> On Mon, Jan 19, 2009 at 3:00 PM, Jon Nelson
> <jnelson-linux-raid@jamponi.net> wrote:
>> I guess what I'd like to see more than anything else is not raid5 or
>> raid6 but raidN where N can be specified at the start and grown. While
>> I'm not a fan of ZFS's rulebreaking one thing it does (or claims to
>> do) strikes me as "the future" - the ability to specify X protection
>> bits and to increase or decrease X as needs see fit. It also strikes
>> me that there are several ways to do this but fundamentally it boils
>> down to "we don't trust our drives anymore and there we wish to
>> protect our data against their failure". Given 5 or 10 or 50 drives
>> how does one really protect their data effectively and allow their
>> data pool to grow without large quantities of hoop-jumping?
>>
>> I'd really like to see a re-thinking of data protection (parity or
>> data duplication) at the block layer - it need not be RAID as we know
>> it but IMO something has to be done - rapidly do we near the
>> precipice!
>
> If I understand what your saying, HP started supporting "Raid
> Equivalent" protection in some of their storage arrays years ago.
>
> You simply put a bunch of disk drives in the unit, then tell you want
> a 50GB logical volume with Raid 5 equivalent protection, etc.
>
> I think it might for example allocate 10 GB from each of 6 disk
> drives.  (ie. 5 for data + 1 for parity).
>
> Then you ask for 30 GB with raid 10 equivalent protection and it might
> allocate 10GB more from those same 6 drives.
>
> Then you go back and increase the size of th 50GB raid5 and it would
> allocate more space on the drives as required, but always ensuring the
> data was protected at least at raid5 levels.
>
> I sort of thought of it as an integrated LVM and Raid manager.
>
> I suspect putting that together is a pretty large amount of effort.
>
> Greg
> --
> Greg Freemyer
> Litigation Triage Solutions Specialist
> http://www.linkedin.com/in/gregfreemyer
> First 99 Days Litigation White Paper -
> http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf
>
> The Norcross Group
> The Intersection of Evidence & Technology
> http://www.norcrossgroup.com
>



-- 
Jon
