From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Random MD Raid resyncs?
Date: Tue, 3 Nov 2009 11:05:28 +0100
Message-ID: <20091103100528.GG24791@boogie.lpds.sztaki.hu>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
 <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
 <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
 <f1ef83020911021540i4094fa1dqc87a6ff0b5b675f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f1ef83020911021540i4094fa1dqc87a6ff0b5b675f0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Wheeler <jwwstpete@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 02, 2009 at 06:40:59PM -0500, Jesse Wheeler wrote:

> AFAIK, any of the RAID devices are not mounted 'auto-read-only' by the
> kernel.  I'll double check /etc/fstab, /var/log/messages, and
> /var/log/dmesg when I get back to the site.  Unless there was a change
> by the upstream vendor, I wouldn't mount a production filesystem in
> that manner.  Of course, I've been surprised before!

auto-read-only is an internal state of the RAID array, it has nothing to
do with file systems. So you probably won't find anything in the
locations you mention above; auto-read-only is only displayed in
/proc/mdstat. Look at the mdadm man page and read the sections "Auto
Assembly" and "INCREMENTAL MODE".

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
