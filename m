From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid0/jbod/lvm, sorta?
Date: Wed, 30 Dec 2009 07:13:02 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912300712090.27231@uplift.swm.pp.se>
References: <20091230000357.GA23485@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091230000357.GA23485@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 29 Dec 2009, Matt Garman wrote:

> I know I could do this manually with symlinks.  E.g., have a directory 
> like /bigstore that contains symlinks into /mnt/drive1, /mnt/drive2, 
> /mnt/drive3, etc.  And then if one drive dies, the whole store isn't 
> trashed.  This seems fairly simple, so I wonder if there's not some 
> automatic way to do it.  Hence, this email.  :)

Unionfs will do this for you.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
