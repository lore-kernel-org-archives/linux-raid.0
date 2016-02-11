From: Marc MERLIN <marc@merlins.org>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Thu, 11 Feb 2016 09:40:26 -0800
Message-ID: <20160211174026.GH13969@merlins.org>
References: <20160211162959.GG13969@merlins.org>
 <20160211171340.GA7664@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160211171340.GA7664@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 11, 2016 at 06:13:40PM +0100, Andreas Klauer wrote:
> > gargamel:~# cryptsetup luksDump /dev/md8
> > LUKS header information for /dev/md8
> > 
> > Version:        1
> > Cipher name:    aes
> > Cipher mode:    xts-plain64
> > Hash spec:      sha1
> > Payload offset: 3072
> > MK bits:        256
> 
> Does the box have AES-NI? What's your 'cryptsetup benchmark' look like?
> Sometimes there can be a problem if the AES-NI module is loaded too late.
> Without AES-NI your performance will suffer either way... 

It's a quad core HT CPU
model name      : Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
 
As far as I can tell, AES-NI is working:

gargamel:~# cryptsetup benchmark
# Tests are approximate using memory only (no storage IO).
PBKDF2-sha1       420102 iterations per second
PBKDF2-sha256     250137 iterations per second
PBKDF2-sha512      87148 iterations per second
PBKDF2-ripemd160  394795 iterations per second
PBKDF2-whirlpool  125068 iterations per second
#  Algorithm | Key |  Encryption |  Decryption
     aes-cbc   128b     1.2 MiB/s  1939.8 MiB/s
 serpent-cbc   128b    29.8 MiB/s   284.4 MiB/s
 twofish-cbc   128b    77.0 MiB/s   339.0 MiB/s
     aes-cbc   256b   451.2 MiB/s  1491.7 MiB/s
 serpent-cbc   256b    85.7 MiB/s   286.7 MiB/s
 twofish-cbc   256b   188.7 MiB/s   358.4 MiB/s
     aes-xts   256b  1572.1 MiB/s  1725.3 MiB/s
 serpent-xts   256b   272.8 MiB/s   291.2 MiB/s
 twofish-xts   256b   289.8 MiB/s   331.7 MiB/s
     aes-xts   512b  1355.1 MiB/s  1385.5 MiB/s
 serpent-xts   512b   318.4 MiB/s   299.8 MiB/s
 twofish-xts   512b   326.6 MiB/s   336.3 MiB/s

> You probably don't want encryption below the RAID; that would mean 
> encrypting redundancy and parity so it's even more work to do, doubtful 
> whether multicore CPU can offset that to make it worth it. Maybe if 
> it's a NAS that has nothing else to do...

It does other work, and I agree that encryption below the raid doesn't
sound like a great idea, which is why I haven't used it so far.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
