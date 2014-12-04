From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Good drive got kicked out - does mdadm assemble across suspend/resume
 like it does across reboots?
Date: Thu, 04 Dec 2014 14:10:04 -0500
Message-ID: <5480B18C.8030405@ubuntu.com>
References: <543ABC82.5020901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <543ABC82.5020901@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/12/2014 1:38 PM, Ram Ramesh wrote:
> While this is not a disaster, I wonder if my understanding is
> correct? Does this mean mdadm does not scan to assemble as part of
> resume? More importantly, how should I rectify the situation like
> this? Reboot or simply stop md0 and scan in a live system? Further,
> how do I use /dev/sdf1 (that was /dev/sdg1 before this problem)?
> zero-superblock and add back to md0?

Of course it does not reassemble the array after a suspend -- the
point of suspend/resume is that the system picks up exactly where it
left off.  Since the array is never torn down, it is not built back
up.  In other words, yanking out drives while suspended isn't really
any different than doing it while running -- not a good idea.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUgLGMAAoJENRVrw2cjl5RLOkH/iZVwQ6FC664CN4y2hGiIOYD
FX4VLtRdEDy517sdqm15nv4LTqfGucZjfiEDtwRs5rQZsIyCOelah8RvxYUOTNrJ
xbURswZTaNhvaEG1/gwIlJoQ5cawVetZKeL6PnMWHpSLHQuoIaqe/wDO3pevcTDD
7vggJvYMr8S4aVKnt8/Ksk/E6DVCsGvCuySvHOr3eGecJuLF4CPZYFZy5G0qqRuo
piI918gushh6CgriFOCdBWice3HwK6V1Nb12kjkVY89l0bQlrIRUo6e6aG1c1M9P
eVmQJOzedtQB8qgsAhc2oXEwtuR/VNWNwxNTPTHCND3nk8FcaTDgzE3MMFmi1OY=
=EXWL
-----END PGP SIGNATURE-----
