From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Random MD Raid resyncs?
Date: Tue, 3 Nov 2009 16:45:14 +0100
Message-ID: <20091103154513.GM24791@boogie.lpds.sztaki.hu>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
 <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
 <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
 <f1ef83020911021540i4094fa1dqc87a6ff0b5b675f0@mail.gmail.com>
 <20091103100528.GG24791@boogie.lpds.sztaki.hu>
 <f1ef83020911030644j140c1cfft81540ddd769a46f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f1ef83020911030644j140c1cfft81540ddd769a46f7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Wheeler <jwwstpete@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 03, 2009 at 09:44:50AM -0500, Jesse Wheeler wrote:

> Interesting.  I just got done reading that section in the manpage; if
> anything, I didn't know mdadm would process an array in that fashion.
> However, I don't see this behavior listed in my /proc/mdstat output.
> If it's there, I'm missing it:

auto-read-only goes away with the first write request. If you have a
file system on the RAID device, just mounting it R/W causes the superblock
to be updated and that in turn ends auto-read-only mode. Unless you have
an unused RAID device, it's not that easy to catch the moment when the
array is still in auto-read-only mode.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
