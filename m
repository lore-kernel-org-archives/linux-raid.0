From: Arne Brutschy <abrutschy@xylon.de>
Subject: Re: raid 5 crash and data loss
Date: Wed, 2 Jul 2003 19:23:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1846504234.20030702192325@xylon.de>
References: <1937891098.20030701164247@xylon.de>
Reply-To: Arne Brutschy <abrutschy@xylon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1937891098.20030701164247@xylon.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

reiserfsck --rebuild-sb /dev/md5
reiserfsck --rebuild-tree /dev/md5
reiserfsck --check /dev/md5

solved the problem.

Thanks anyway,
Arne

