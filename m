From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: "Enhanced" MD version 0.8.0 now available
Date: Thu, 25 Mar 2004 07:31:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <887380000.1080225097@aslan.btc.adaptec.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

An updated snapshot of the Enahanced MD project is now available here:

	http://people.freebsd.org/~gibbs/linux/SRC/emd-0.8.0-tar.gz

and as diffs relative to the current 2.6 MD implementation:

	http://people.freebsd.org/~gibbs/linux/SRC/emd-2.6-20040425-diffs.gz

A version of "emdadm" is also avaible to for this driver:

	http://people.freebsd.org/~gibbs/linux/SRC/emdadm-0.00.1.tgz

This snapshot includes support for RAID0, RAID1, and the Adaptec
ASR and DDF meta-data formats.  Additional RAID personalities and
support for the Super90 and Super 1 meta-data formats will be added
in the coming weeks, the end goal being to provide a superset of
the functionality in the current MD.

This drop adds the ability to create, delete, and monitor DDF and
Adaptec ASR meta-data based arrays from emdadm in addition to including
several bug fixes.  

This release is still structured as an MD replacement.  While this
makes the diffs supplied above more relevant from a review standpoint,
we believe that it makes more sense at this stage in EMD development
to provide it as a separate driver.  This change will be reflected
in our next release.  The hope is for EMD and MD to merge as EMD is
reviewed and altered to suite the communities needs.

As always, your questions, comments, and suggestions for EMD are
greatly appreciated.

--
Justin

