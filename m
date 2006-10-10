From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 11:55:24 +0200
Message-ID: <20061010095524.GF7416@boogie.lpds.sztaki.hu>
References: <20061009125700.GA10191@piper.madduck.net> <20061009134946.GA26122@harddisk-recovery.com> <1160411520.2917.76.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1160411520.2917.76.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Erik Mouw <erik@harddisk-recovery.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 09, 2006 at 12:32:00PM -0400, Doug Ledford wrote:

> You don't really need to.  After a clean install, the operating system
> has no business reading any block it didn't write to during the install
> unless you are just reading disk blocks for the fun of it.

What happens if you have a crash, and fsck for some reason tries to read
into that uninitialized area? This may happen even years after the
install if the array was never resynced and the filesystem was never
100% full... What happens, if fsck tries to read the same area twice but
gets different data, because the second time the read went to a
different disk?

And yes, fsck is exactly an application that reads blocks just "for the
fun of it" when it tries to find all the pieces of the filesystem, esp.
for filesystems that (unlike e.g. ext3) do not keep metadata at fixed
locations.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
