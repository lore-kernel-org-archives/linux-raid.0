From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: Re: RAID6 seemingly shrunk itself after hard power outage and
 rebuild with replacement disk
Date: Sun, 6 Mar 2011 19:22:56 +0000
Message-ID: <robbat2-20110306T191507-836226235Z@orbis-terrarum.net>
References: <robbat2-20110304T221807-988505787Z@orbis-terrarum.net>
 <4D726B96.3010501@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D726B96.3010501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, robbat2@gentoo.org
List-Id: linux-raid.ids

On Sat, Mar 05, 2011 at 11:57:58AM -0500, Phil Turmel wrote:
> I have a suspicion that 'mdadm --create --assume-clean' or some
> variant was one of those.  And that the rescue environment has a
> version of mdadm >= 3.1.2.  The default metadata alignment changed in
> that version.
Confirmed.

> The lowest device node is the last device role?  Any chance these are also out of order?
Yes, the data was confirmed to be shuffled later.

> If my suspicions are right, you'll have to use an old version of mdadm
> to redo an 'mdadm --create --assume-clean'.
Passed -e 0 with that, and corrected the order of the devices, and then
it looked much better. Some minor data corruption where the new metadata
overwrote stuff, but much easier to recover those files than the entire
35 TiB.

Thanks everybody for the help.

-- 
Robin Hugh Johnson
Gentoo Linux: Developer, Trustee & Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85
