From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 15:02:12 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025220212.GA30613@sam.triumf.ca>
References: <1098733380.5399.39.camel@duxeon.cobite.com> <200410252029.i9PKTEN26833@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200410252029.i9PKTEN26833@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'David Mansfield' <md@dm.cobite.com>, 'Jure Pe_ar' <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 25, 2004 at 04:29:09PM -0400, anybody wrote:
> 1 disk has a bad sector and another disk fails, game over.

On a single-disk, 1 bad sector kills just the one unlucky file.
On a degraded RAID0 or RAID5, 1 bad sector kills the filesystem.
On a healthy RAID0 or RAID5, 2 bad sectors on different disks kill the filesystem.

Does this make sense?
RAID is less fault tolerant than a single disk?

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
