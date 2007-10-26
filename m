From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 00:30:46 +0200
Message-ID: <20071026223046.GB8210@boogie.lpds.sztaki.hu>
References: <1192810534.1666.68.camel@firewall.xsintricity.com> <18200.56684.14194.630264@stoffel.org> <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com> <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com> <20071026095417.GC32550@percy.comedia.it> <1193424779.10336.287.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193424779.10336.287.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 26, 2007 at 02:52:59PM -0400, Doug Ledford wrote:

> In fact, no you can't.  I know, because I've created a device that had
> both but wasn't a raid device.  And it's matching partner still existed
> too.  What you are talking about would have misrecognized this
> situation, guaranteed.

Maybe we need a 2.0 superblock that contains the physical size of every
component, not just the logical size that is used for RAID. That way if
the size read from the superblock does not match the size of the device,
you know that this device should be ignored.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
