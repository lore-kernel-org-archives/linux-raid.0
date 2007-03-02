From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Fri, 2 Mar 2007 17:10:04 +0100
Message-ID: <20070302161004.GE31010@boogie.lpds.sztaki.hu>
References: <45E82EF8.9000106@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45E82EF8.9000106@laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 02, 2007 at 09:04:40AM -0500, Mike Accetta wrote:

> Thoughts or other suggestions anyone?

This is a case where a very small /boot partition is still a very good
idea... 50-100MB is a good choice (some initramfs generators require
quite a bit of space under /boot while generating the initramfs image
esp. if you use distro-provided "contains-everything-and-the-kitchen-sink"
kernels, so it is not wise to make /boot _too_ small).

But if you do not want /boot to be separate a moderately sized root
partition is equally good. What you want to avoid is the "whole disk is
a single partition/file system" kind of setup.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
