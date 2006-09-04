From: Neil Brown <neilb@suse.de>
Subject: Re: Superblock checksum problems
Date: Mon, 4 Sep 2006 15:12:21 +1000
Message-ID: <17659.46517.979409.131348@cse.unsw.edu.au>
References: <1157236610.8070.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Josh Litherland on Saturday September 2
Sender: linux-raid-owner@vger.kernel.org
To: josh@temp123.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday September 2, josh@temp123.org wrote:
> 
> Attempting to build a new raid5 md array across 4 hard drives.  At the
> exact moment that the drive finishes rebuilding, the superblock checksum
> changes to an invalid value.  During the rebuild, mdadm -E for the 4
> drives shows:
> 
>        Checksum : 70c0863a - correct
>        Checksum : 70c0864c - correct
>        Checksum : 70c0865e - correct
>        Checksum : 70c08670 - correct
> 
> The instant it finishes:
> 
>        Checksum : 70c0bc47 - expected 70c0bc27
>        Checksum : 70c0bc59 - expected 70c0bc39
>        Checksum : 70c0bc6b - expected 70c0bc4b
>        Checksum : 70c0bc7d - expected 70c0bc5d
> 
> Kernel is 2.6.17.11.

Very odd.
It this repeatable?
Does the checksum stay wrong? 
i.e. if you run 'mdadm -E' again, a few seconds later, does it still
report the wrong number?

If you stop the array and run 'mdadm -E' on the drives, what values do
they have now.

NeilBrown

-- 
VGER BF report: U 0.5
