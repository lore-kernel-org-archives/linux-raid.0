From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: swap on raid 1
Date: Tue, 14 Oct 2003 15:36:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310141536.30248.dusty@strike.wu-wien.ac.at>
References: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu>
Content-Disposition: inline
To: skopel@english.fsu.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 14 October 2003 13:34, skopel@english.fsu.edu wrote:
> I have been following the discussion of swap on raid 1 and I just want to
> clarify something... I have my swap on /dev/md1, which is a raid1 device
> consisting of /dev/hda2 and /dev/hdc2.
> If one of the drives fails (either hda or hdc), I think the swap will be
> duplicated on the other and the box will continue merrily on, right?
> thanks

Basically, that's what I hope.

Anyway - what exactly happens when a PATA harddisk dies? Will this only lead 
to logentries in the syslog, or will this crash the machine due to hardware 
reasons? Probably there would also be a difference if you would do RAID on 
the same channel (e.g. hda, hdb) as a mulfunction of one device could jam the 
whole IDE channel.

The same thing can apply to SCSI, too - I once experienced this myself when a 
fautly SCSI-CDROM jammed the whole SCSI-bus and crashed my machine.

I hope that SATA will be a lot less critical, it should support hotplugging 
(at least with SATA 1.1, it's a pity that it's not supported with 1.0 right 
away) and there is only one device per channel.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

