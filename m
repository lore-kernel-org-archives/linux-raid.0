From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 2 Jan 2009 15:26:38 -0500
Message-ID: <87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	 <fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	 <49580061.9060506@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49580061.9060506@yahoo.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Mark Lord <liml@rtr.ca>, Redeeman <redeeman@metanurb.dk>, piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Dec 28, 2008 at 5:40 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Mark Lord wrote:
>
>> There's a separate effort, involving drive vendors and kernel hackers,
>> to provide end-to-end CRC protection of data.  I forget what it was
>> called,
>> but that's the future of this stuff for high-reliability requirements.
>
> Are you thinking of BLK_DEV_INTEGRITY which tries to support T10/SCSI Data
> Integrity Field or the T13/ATA External Path Protection?
>

I see that my Opensuse kernel has CONFIG_BLK_DEV_INTEGRITY enabled and
that block layer changes have been implemented and documented in

Documentation/block/data-integrity.txt

I also see Device Mapper support was discussed in Oct.  (My 2.6.27
kernel does not have those patches).

Is there a more comprehensive write-up / resource that describes the
current status of the overall INTEGRITY support is, especially as it
relates to ATA devices?

ie.
Do actual ATA hardware devices that support "T13/ATA External Path
Protection" exist yet?  Does it require HDD and controller support?
Or just HDD?

Does libata support those devices and the extra INTEGRITY bio that
holds the CRC field.

Does mdraid?  Device Mapper?

Thanks
Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
