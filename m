From: "David F." <df7729@gmail.com>
Subject: MDADM 3.3 broken?
Date: Mon, 18 Nov 2013 10:26:00 -0800
Message-ID: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

we updated our linux disk with mdadm 3.3 from 3.2.6 and customers are
finding their RAID is no longer detected.  It's only been a couple
weeks and based on the number of customers, we know there is an issue.
 We're having those with problems workaround by having them load
dmraid instead for now.

We also did tests locally and finding intermittent problems with
RAID-0 on ISW - sometimes 3.3 doesn't identify both drives as RAID
members.  3.2.6 works 100% of the time.

Also with DDF RAID - cisco server for example not detecting RAID5 -
C220M3_LFF_SpecSheet.pdf. I believe they are using the LSI MegaRaid
since DMRAID reports that.

Are these problems known - we wouldn't mind moving to the latest
version if your pretty sure it fixes it, otherwise we're going to have
to revert to 3.2.6?

TIA!!
