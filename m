From: Benjamin Davenport <ben@monkeysushi.net>
Subject: Re: Questions about the speed when MD-RAID array is being initialized.
Date: Fri, 11 May 2007 21:24:12 -0500
Message-ID: <4645254C.6000802@monkeysushi.net>
References: <20070508170441.GB4333@scavenger.homeip.net>  <f1sc2p$33q$1@sea.gmane.org> <BAY125-DAV2F4ABCF54BCB7458BA3D7933A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY125-DAV2F4ABCF54BCB7458BA3D7933A0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Liang Yang <multisyncfe991@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

When mdadm creates a raid5 array, it creates it in degraded mode.  Then it kicks
in the last device and runs the rebuild code, which reads from the other n-1
disks and writes to the nth disk as appropriate to satisfy parity requirements.
 This allows you to max out the write bandwidth on a single disk, and is the
quickest way to make the array consistent.

The speed reported by mdstat is the speed at which the array resync is
completing.  That is, it is the speed at which new areas of the disk are being
brought into a consistent state.  Because that speed is, absent other IO or high
CPU load or other constraint, limited by the write bandwidth of your disk,
that's what you're seeing.  The speed decreases as you progress across the disk
because the disk's write speed decreases across the disk.

If you run iostat, you'll see that one of the raid's component disks is
sequentially writing and the others are sequentially reading, all at the same
speed (modulo a small amount of jitter caused by quantized timing).  If you
think about the algorithm involved, there's no faster way to do it, despite your
initial gut feeling that an 8-disk array should be able to resync faster than that.

- -Ben
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGRSVMcsocGMHJ2H8RCt8mAKCYPDi6t0Zi4ZKxiJvWSg26L3vsoACfS3MD
J8JTSSL3AukSprVlpLTJr50=
=YZrE
-----END PGP SIGNATURE-----
