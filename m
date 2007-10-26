From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 00:20:12 +0200
Message-ID: <20071026222012.GA8210@boogie.lpds.sztaki.hu>
References: <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <471E7DC6.7050206@tmr.com> <1193184555.10336.3.camel@firewall.xsintricity.com> <18207.56169.769976.512617@notabene.brown> <471FDEB1.8040401@garzik.org> <47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown> <4721F742.1090301@tmr.com> <1193424116.10336.281.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193424116.10336.281.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, David Greaves <david@dgreaves.com>, Jeff Garzik <jeff@garzik.org>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 26, 2007 at 02:41:56PM -0400, Doug Ledford wrote:

> * When using lilo to boot from a raid device, it automatically installs
> itself to the mbr, not to the partition.  This can not be changed.  Only
> 0.90 and 1.0 superblock types are supported because lilo doesn't
> understand the offset to the beginning of the fs otherwise.

Huh? I have several machines that boot with LILO and the root is on
RAID1. All install LILO to the boot sector of the mdX device (having
"boot=/dev/mdX" in lilo.conf), while the MBR is installed by
install-mbr. Since install-mbr has its own prompt that is displayed
before LILO's prompt on boot, I can be pretty sure that LILO did not
write anything to the MBR...

What you say is only true for "skewed" RAID setups, but I always
considered such a setup too risky for anything critical (not because of
LILO, but because of the increased administrative complexity).

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
