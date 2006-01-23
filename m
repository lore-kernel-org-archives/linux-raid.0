From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 14:00:30 +0100
Message-ID: <20060123130030.GA1082@uio.no>
References: <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <20060120183621.GA2799@redhat.com> <20060120225724.GW22163@marowsky-bree.de> <20060121000142.GR2801@redhat.com> <20060121000344.GY22163@marowsky-bree.de> <20060121000806.GT2801@redhat.com> <20060121001311.GA22163@marowsky-bree.de> <20060123094418.GX2801@redhat.com> <20060123125420.GE1686@vianova.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060123125420.GE1686@vianova.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Ville Herva <vherva@vianova.fi>
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Neil Brown <neilb@suse.de>, Phillip Susi <psusi@cfl.rr.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 23, 2006 at 02:54:20PM +0200, Ville Herva wrote:
> If you really want the rest of us to convert from md to lvm, you should
> perhaps give some attention to thee brittle userland (scripts and and
> binaries).

If you do not like the LVM userland, you might want to try the EVMS userland,
which uses the same kernel code and (mostly) the same on-disk formats, but
has a different front-end.

> It is very tedious to have to debug a production system for a few hours in
> order to get the rootfs mounted after each kernel update. 

This sounds a bit like an issue with your distribution, which should normally
fix initrd/initramfs issues for you.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
