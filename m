From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: libata hotplug and md raid?
Date: Tue, 17 Oct 2006 10:11:55 +0200
Message-ID: <20061017081155.GF11884@boogie.lpds.sztaki.hu>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com> <4507E2A9.7070306@emc.com> <4507E641.7090508@gmail.com> <c384c5ea0609140524ofed0dd8v6f1b89a6b4d67f75@mail.gmail.com> <45342287.407@pobox.com> <17716.14507.187306.941214@cse.unsw.edu.au> <20061017080707.GE11884@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061017080707.GE11884@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mark Lord <mlord@pobox.com>, linux-raid@vger.kernel.org, Leon Woestenberg <leon.woestenberg@gmail.com>, Tejun Heo <htejun@gmail.com>, Ric Wheeler <ric@emc.com>, Greg KH <gregkh@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 17, 2006 at 10:07:07AM +0200, Gabor Gombas wrote:

> Vanilla 2.6.18 kernel. In fact, all the /sys/block/*/holders directories
> are empty here.

Never mind, I just found the per-partition holders directories. Argh.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
