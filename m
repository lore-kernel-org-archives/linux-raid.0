From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disks never stop spinning
Date: Mon, 08 Dec 2014 15:38:55 -0500
Message-ID: <54860C5F.3070306@ubuntu.com>
References: <54610788.6060103@gautschi.net> <21604.47814.651762.246947@tree.ty.sabi.co.uk> <54657187.6020306@gautschi.net> <5480B726.8070103@ubuntu.com> <54831DC7.4070304@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54831DC7.4070304@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/6/2014 10:16 AM, P. Gautschi wrote:
>> Are you running udisks?  If so then that is the culprit.  It
>> polls the drive's SMART stats every 10 minutes unless the drive
>> is already asleep, so if the timeout is>= 10 minutes ( which it
>> seems WD drives refuse to go any lower anyhow ), then the drive
>> will never go to standby.  I posted some patches to fix this a
>> while back on the devkit-devel mailing list but I think the
>> udisks maintainer has still not gotten around to applying them.
> 
> This is indeed the cause in my case. There are the two problems
> that overlap: if a shorter time then 10 minutes is set as a standby
> time, the WD disk rounds this up to 10 minutes. And Kubuntu is
> using udisksd. It is started during a KDE login and never stopped
> when logging out.
> 
> Is it possible to configure udisks to not do any polling or at a
> much longer interval? Or is it possible to safely disable udisksd
> somehow? I'm still looking for a practical solution.

You can build and install my patched version.  See:

https://launchpad.net/bugs/1281588


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUhgxfAAoJENRVrw2cjl5RGxYH/3x1szkPGfky9XKg+rImoVS7
1W8pWCuIww1qLXGTrbapu8+9u5DWteTaLTkvrJvG4V8Gy4NrK1AwbrvF9N9Ox1Nx
aRzI3HuNaFCdqPBDkOAtcguflO2sbEr41NzWtqoW1zytVzcFOlPzOhIitTAh0BR6
ng3QuWf6DrDfLIdQoDkkYOFnaZydGKYMMhIFEMqPWrlJ760Yjrb9GUEVR3g0C2yP
pVmFoL7g4lRyfw4+eXu4+XQFHtjeB+SFvn7nRBIo7ZVWYVimBjX3HmobrIwsJJJ0
nY/AVswj5gMfJAzdmDDiIEJZtzwIbnO9Ogh8Oghdl7Fxg55V/i4Krp9Kvp0GSB0=
=dlgf
-----END PGP SIGNATURE-----
