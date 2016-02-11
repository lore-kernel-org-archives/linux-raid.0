From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Thu, 11 Feb 2016 18:13:40 +0100
Message-ID: <20160211171340.GA7664@EIS>
References: <20160211162959.GG13969@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160211162959.GG13969@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> gargamel:~# cryptsetup luksDump /dev/md8
> LUKS header information for /dev/md8
> 
> Version:        1
> Cipher name:    aes
> Cipher mode:    xts-plain64
> Hash spec:      sha1
> Payload offset: 3072
> MK bits:        256

Does the box have AES-NI? What's your 'cryptsetup benchmark' look like?
Sometimes there can be a problem if the AES-NI module is loaded too late.
Without AES-NI your performance will suffer either way... 

You probably don't want encryption below the RAID; that would mean 
encrypting redundancy and parity so it's even more work to do, doubtful 
whether multicore CPU can offset that to make it worth it. Maybe if 
it's a NAS that has nothing else to do...

Regards
Andreas
