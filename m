From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Mon, 05 Mar 2007 18:32:32 -0500
Message-ID: <45ECA890.5000701@laurelnetworks.com>
References: <45E82EF8.9000106@laurelnetworks.com> <9782.20070302161004.GE31010@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9782.20070302161004.GE31010@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gabor Gombas wrote:
> On Fri, Mar 02, 2007 at 09:04:40AM -0500, Mike Accetta wrote:
> 
>> Thoughts or other suggestions anyone?
> 
> This is a case where a very small /boot partition is still a very good
> idea... 50-100MB is a good choice (some initramfs generators require
> quite a bit of space under /boot while generating the initramfs image
> esp. if you use distro-provided "contains-everything-and-the-kitchen-sink"
> kernels, so it is not wise to make /boot _too_ small).
> 
> But if you do not want /boot to be separate a moderately sized root
> partition is equally good. What you want to avoid is the "whole disk is
> a single partition/file system" kind of setup.

Yes, we actually have a separate (smallish) boot partition at the front of
the array.  This does reduce the at-risk window substantially.  I'll have to
ponder whether it reduces it close enough to negligible to then ignore, but
that is indeed a good point to consider.
-- 
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
