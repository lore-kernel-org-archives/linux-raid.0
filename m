From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: BUG: Data corruption on Raid5 in Linux 2.6.0
Date: Sun, 28 Dec 2003 09:17:22 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031228091722.B4400@nettis.grimsta>
References: <20031228000008.B2433@nettis.grimsta> <16366.28299.160756.494452@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16366.28299.160756.494452@notabene.cse.unsw.edu.au>; from neilb@cse.unsw.edu.au on Sun, Dec 28, 2003 at 04:47:55PM +1100
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 28, 2003 at 04:47:55PM +1100, Neil Brown wrote:
> On Sunday December 28, daniel.com@wtnord.net wrote:
> > I have a Raid5 system of four 160GB SATA disks. The drives
> > themselves work fine, but when large files (a few hundred
> > megs) are written to the raid disks they get corrupted after
> > a random amount of data.  The kernel is Linus 2.6.0.
> > 
> > Any hints you can give me to get this working is highly
> > appreciated.
> 
> What file system?

XFS. I've tested a "cp a b; md5sum a b" on a 500MB file on both
the Raid disk as well as a normal partition on one of the disks,
and the latter works perfectly every time while the former fails
every time.

> Are you using DeviceMapper over the raid5?

Yes.

> If you are using DeviceMapper, can you try without it?
> (I don't think there is a proble with DeviceMapper, but it drives
> raid5 slightly differently to e.g. direct ext3 and could trigger a bug
> in raid5.)

I get the same problem without it, just a few more "dma_intr:
DriveReady SeekComplete Error" in the syslog.

There seems to be various opinions on whether to use the siimage
driver or the sata_sil driver with a Sil3112 SATA card.  For me
there isn't much choice though, since the sata_sil driver makes
my machine crash when I activate the second network card.

/Basic

