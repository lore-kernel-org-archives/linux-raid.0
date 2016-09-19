From: Anthony DeRobertis <anthony@derobert.net>
Subject: Bug#837964: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Mon, 19 Sep 2016 12:32:29 -0400
Message-ID: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
Reply-To: Anthony DeRobertis <anthony@derobert.net>, 837964@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.837964.B837964.147430275124008@bugs.debian.org>
Content-Disposition: inline
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: linux-raid@vger.kernel.org
Cc: 837964@bugs.debian.org
List-Id: linux-raid.ids

(please cc me, I'm not subscribed.)

mdadm 3.4 can not manage to add a spare to my array, it fails like:

   # mdadm -a /dev/md/pv0 /dev/sdc3
   mdadm: add new device failed for /dev/sdc3 as 8: Invalid argument

and the kernel logs:

   md: sdc3 does not have a valid v1.0 superblock, not importing!
   md: md_import_device returned -22

This worked in 3.3.4. I performed two git bisects and found that:

a) it was broken by 95a05b37e8eb2bc0803b1a0298fce6adc60eff16
b) it is sort-of fixed by 81306e021ebdcc4baef866da82d25c3f0a415d2d
   (which AFAIK isn't yet released)

I say sort of fixed in that it adds it to the array, but spits out some
worrying errors (and I have no idea if it'd actually work, e.g., if it'd
assemble again):

   # ./mdadm -a /dev/md/pv0 /dev/sdc3 
   mdadm: Warning: cluster md only works with superblock 1.2
   mdadm: Failed to write metadata to /dev/sdc3

I'm not using (or at least not on purpose!) cluster md, as these are
internal SATA drives accessible by only one machine.

I wasn't able to reproduce it on a new (small) test array, so it might
be something specific to this array.

I've reported this bug to Debian, and that bug report contains a lot of
system information that I won't repeat here (because it's quite long):

	https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=837964

that contains mdadm -E output, the mdadm.conf, etc.
