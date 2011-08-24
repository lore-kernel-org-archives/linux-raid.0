From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: mixing backup with app serving on same box
Date: Wed, 24 Aug 2011 13:49:38 +0200
Message-ID: <20110824114938.GA24464@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I recently ordered a shiny Dell R510 2U server with 12x3.5" drives.
This machine will primarily be a backup host for nightly incremental
rsync runs of a dozen other machines.

Since this is a well-spec'ed box with dual CPUs, generous bandwidth and
32G RAM I'm wondering if it could also do some medium web serving
(mod_perl + postgres).

For the main backup partition I plan in using a mdadm raid6 on 8x3T
disks and raid6 4x1T disks for the app side.

So my questions are:

- is it realistic to have mix rsync processes and web serving on the
  same host?

- am I naive in thinking I can get away with it by using distinct disks
  sets for each task?

- all 12 disks being served by the same H200 controller, will the real
  bottleneck be at the controller level?

- any other consideration I should take into account?

Thanks,
