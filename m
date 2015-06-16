From: wiebittewas <wiebittewas@googlemail.com>
Subject: Re: seagate-"archive"-disks with raid6?
Date: Tue, 16 Jun 2015 04:58:54 +0200
Message-ID: <557F90EE.5060608@googlemail.com>
References: <557C5330.1090605@gmail.com> <alpine.DEB.2.02.1506132207180.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1506132207180.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 13.06.2015 22:11 schrieb "Mikael Abrahamsson" bzgl. "Re: seagate-"archive"-disks with raid6?":

> http://www.spinics.net/lists/linux-ide/msg50641.html

thanks for this link, which shows us, that there might be better solutions in near future.

> These drives are different beasts than regular HDDs, and we seem to be seeing problems with them just the way SSDs were problematic in the beginning.

if "different" means that they use SMR - yes, we know this. Our current use is mostly write-once/read-many, so the described additional timeouts might not happen here.
nevertheless, the cooperation beetween filesystem and disk, which is mentioned at the given link, sounds better, so we'll try to wait some weeks or might find a temporary solution.
(perhaps this new series will have ERC/TLER enabled, when they let the kernel do the SMR-control...)

regards

w.

