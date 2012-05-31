From: Sven Hartrumpf <hartrumpf@gmx.net>
Subject: Re: Using a newer mdadm version just for re-adding a device
Date: Thu, 31 May 2012 19:24:14 +0200 (CEST)
Message-ID: <20120531.192414.2085541500628127947.hartrumpf@gmx.net>
References: <20120530.193815.809240125288589880.hartrumpf@gmx.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120530.193815.809240125288589880.hartrumpf@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To answer my own question (about a RAID-1):

Wed, 30 May 2012 19:38:15 +0200 (CEST), I wrote:
> Is it safe to mix mdadm versions in the following scenario?
...
> Now my question is:
> Can I safely use the resulting binary (renamed to mdadm325 to avoid confusion)
> to re-add the device and then continue to use the 3.2.2 package from openSUSE?

I made a backup and tried the above: it worked perfectly.

Sven
