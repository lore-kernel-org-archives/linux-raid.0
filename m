From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Building new RAID5 results in removed and failed devices
Date: Thu, 24 Jun 2010 14:03:07 -0700
Message-ID: <AANLkTil7F2gHUVzBGbqBU4tUDdKBpVThEwnOmm0RdRn4@mail.gmail.com>
References: <4C23BF79.2070009@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C23BF79.2070009@gmx.at>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Krainz <ldm@gmx.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 24, 2010 at 1:26 PM, Markus Krainz <ldm@gmx.at> wrote:
> 1. I delete my old array md0
> 2. Then I create a new one as md1
> 3. The new md1 is not ok and shows removed, faulty and spare devices.

This is expected without the --force option:

--force
              Insist that mdadm accept the geometry and layout
specified without question.
              Normally mdadm will not allow creation of an array with
only one device, and
              will  try  to create a RAID5 array with one missing
drive (as this makes the
              initial resync work faster).  With --force, mdadm will
not  try  to  be  so
              clever.

--
Dan
