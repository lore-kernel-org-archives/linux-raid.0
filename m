From: "Riley Williams" <Riley@Williams.Name>
Subject: RE: Invalid argument when creating a RAID-0 array
Date: Sun, 15 Jun 2003 09:14:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BKEGKPICNAKILKJKMHCAEEGEEFAA.Riley@Williams.Name>
References: <3EEBA9F2.7060902@debian.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EEBA9F2.7060902@debian.org>
To: Ari Pollak <ari@debian.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ari.

 >>> too small chunk_size: 4096 < 8192

 >> Maybe use a bigger chunk size, 4K is rather small. However I
 >> thought 4k would work.  Maybe you aren't using an i386, as
 >> the minimum chunk size is currently connected with the system
 >> page size. What architecture are you using?

 > Oops, I forgot to specify. I'm using an UltraSPARC on a Sun
 > Enterprise 450, using kernel 2.4.19 (I haven't had a chance to
 > try .21 yet). I was just following the Software-RAID HOWTO,
 > which said that for striping, chunk size didn't really matter.

As you've discovered, the chunk size can't be less than the system
page size, and on the UltraSPARC platform, that's 8k - and the same
is true of most platforms other than ix86.

Providing you meet the above requirement, the RAID chunk size for
striping probably is irrelevant, but the page size requirement is
one that applies irrespective of any other requirements.

Best wishes from Riley.
---
 * Nothing as pretty as a smile, nothing as ugly as a frown.

---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.489 / Virus Database: 288 - Release Date: 10-Jun-2003

