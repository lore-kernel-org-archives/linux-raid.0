From: Micah Anderson <micah@riseup.net>
Subject: md device not unmounting on reboot
Date: Wed, 24 Jul 2002 13:25:54 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020724202553.GD8844@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On particular md device on our system never seems to unmount cleanly
on a restart. This causes us to have to fsck the device on EVERY boot,
which is kind of irritating because it is a large partition. 

Does anyone know why this could be happening and what we can do to
make it stop?

Thanks,
Micah
