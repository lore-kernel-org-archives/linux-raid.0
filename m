From: Dave Jones <davej@redhat.com>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Tue, 20 Jan 2009 15:07:41 -0500
Message-ID: <20090120200741.GA1020@redhat.com>
References: <200901032104.15242.bs@q-leap.de> <496436C4.4070305@kernel.org> <49643FD4.9080100@shaw.ca> <200901071632.02264.bs@q-leap.de> <49693E08.3050209@shaw.ca> <49694094.60501@shaw.ca> <496A9D42.4000302@kernel.org> <20090119184304.GB30365@redhat.com> <49753BDE.8050403@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49753BDE.8050403@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: Tejun Heo <tj@kernel.org>, Bernd Schubert <bs@q-leap.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 19, 2009 at 08:50:06PM -0600, Robert Hancock wrote:
 
 > > Given the corruption happens at high block numbers, I'm wondering
 > > if maybe there's some kind of wraparound bug happening here.
 > > (Though why only the 0x00 pattern fails would still be a mystery).
 > 
 > Yeah, that seems a bit bizarre.. Apparently somehow zeros are being 
 > converted into non-zero.. Can you try zeroing out the partition by 
 > dd'ing into it from /dev/zero or something, then dumping it back out to 
 > see what kind of data is showing up?

Hmm, it seems the failed firmware update has killed the eeprom.
It no longer reports the right PCI vendor ID.

	Dave

-- 
http://www.codemonkey.org.uk
