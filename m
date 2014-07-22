From: Phil Turmel <philip@turmel.org>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 11:08:32 -0400
Message-ID: <53CE7E70.2000800@turmel.org>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org> <53CE654E.2000800@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CE654E.2000800@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ron,

On 07/22/2014 09:21 AM, Ron Leach wrote:

[trim /]

> Ah, it's dawning.  Did you mean that these uuids, from the -Es command,
> and which are labelled ARRAY, are 'not' the uuids to use in fstab, but
> the other uuids from blkid, and labelled UUID, are 'ok' to use in
> fstab?  I think I've got it.
> 
> So I've got to
> 
> (i) change fstab to have blkid's listed UUIDs,
> No, there's a problem.  I don't have a UUID for /dev/md5, for my /home
> mount in fstab.
> 
> (ii) change mdadm.conf to have this new set of ARRAY statements (from
> -Es command) instead of the existing set in mdadm.conf, with md126
> replaced by md5, and
> 
> (iii) get this mdadm.conf copied into initramfs.

Yes, you've got it.

> I'm not confident about fstab, because of the missing /dev/md5
> identifier.  So I haven't made any changes, yet.
> 
> Phil, thanks for the reply, and advice; sorry to still seem so cautious,

The changes to mdadm.conf and the changes to fstab can be done
independently.  If you do (ii) and (iii), and the fstab has the
corresponding /dev/mdX for the correct filesystems, you'll be able to
boot successfully.

I'm not sure why /dev/md126 didn't show up in blkid's report.  You might
still have a problem there.  Show the content of /proc/mdstat, please.

It might also help to document your system layout with "lsdrv" [1].

Phil

[1] https://github.com/pturmel/lsdrv
