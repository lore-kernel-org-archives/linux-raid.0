From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE - mdadm 0.8 - candidate for 1.0
Date: Thu, 11 Apr 2002 09:57:15 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15540.53595.552654.565603@notabene.cse.unsw.edu.au>
References: <15539.36803.487505.398985@notabene.cse.unsw.edu.au>
	<20020410203945.99811.qmail@web10405.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from BOIK MOON on Wednesday April 10
To: BOIK MOON <mooasun@yahoo.com>
Cc: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 10, mooasun@yahoo.com wrote:
> 
>  Neil,
>  
> I tried with "mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/hda1 --fail /dev/hdc1"
> to make a MD device with a faulty device. However, It did not work what I expected.
> I do not want to include /dev/hdc1 yet because it has the system image, but it tried to
> include it.
> Any suggestion?

Yes. If you don't want /dev/hdc1 to be included, don't include it.
If you say:

# mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/hda1

It will say:

mdadm: You haven't given enough devices (real or missing) to create this array

The word "missing" is meant to be a hint, but I don't think it is
documented (I've just made a TODO note to fix that - thanks).

The command:

# mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/hda1 missing

will create your array with /dev/hda1 in the first slot, and no device
in the second slot.

NeilBrown
