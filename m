From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active
	devices)
Date: Tue, 15 Jul 2008 00:58:16 +0200
Message-ID: <20080714225816.GS4314@kiste.smurf.noris.de>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com> <20080625161357.GH23944@skl-net.de> <18532.50062.63173.620773@notabene.brown> <48680586.609@tmr.com> <g5fam0$8oe$1@ger.gmane.org> <487B7B74.3010903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <487B7B74.3010903@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

David Greaves:
> I've found that once a disk starts to go bad there is a very strong
> tendency for it to continue to deteriorate.
> 
In my experience, that's true for older disks, but not necessarily for
those that are new and simply have a spot or two where the magnetizable
layer is a wee bit too thin.

However, even if they do in fact continue to deteriorate, the ability to
re-map the offending areas and continue gives me an order of magnitude
more time to deal with the problem.

In fact, as I said, there may be problems lurking on other disks which I
just haven't found yet (how often do you read all 5TB of your data?),
which means that a feature like this is the difference between being
able to recover and certain data loss, RAID-6 nonwithstanding.


NB, one other problem I've observed (older kernel, I don't know if it's
been fixed) is that a resync is restarted from the beginning when a
fault on a second disk is encountered. BAD idea.


NB2, my ideal RAID recovery scenario looks like this:
* When a disk access fails, the offender is switched to write-only mode.
  I.e., the kernel ignores it when reading, but still tries to write
  correct data when something's updated.
* In order to re-sync a new disk, simply duplicate the old one if it
  hasn't been removed yet; of course, you need to do "real" recovery for
  the bad spots, and you need the aforementioned write-only code to
  update both (when writing to the area that's already synced up).

The _huge_ advantage of this process would be that a re-sync does not
affect the array's read performance at all (other than the higher CPU
usage). For some people, that can be quite important.

Now where can I get the largish chunk of time required to implement all
of this ... oh well.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
The way to a man's heart is through the left ventricle.
