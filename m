From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: strangre drive behaviour.
Date: Mon, 7 Mar 2005 22:21:22 +0100
Message-ID: <62b0912f050307132144db2b6b@mail.gmail.com>
References: <422AAAA7.6080106@fastmail.co.uk>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <422AAAA7.6080106@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
> Can I just make it a slave device? How will that effect performance?

AFAIR (CMIIW):
- The standards does not allow a slave without a master.
- The master has a role to play in that it does coordination of some
sort (commands perhaps?) between the slave drive and the controller.

But on the other hand, I've seen ATAPI cdrom drives working in "slave
only" configurations for years.  Hm.

It shouldn't cause performance degradation, but it's a kinky setup
which you should probably trust a bit less than a master-only setup.

If it's not the CABLE SELECT thing, it could be that the firmware on
the drive acting up is different from f/w on the other drives.  Check
versions?
