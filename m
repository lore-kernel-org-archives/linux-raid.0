From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 08:43:33 +0200
Message-ID: <20090429064333.GB9372@boogie.lpds.sztaki.hu>
References: <49F68CE0.2010906@zytor.com> <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com> <1240957153.18303.689.camel@ezra> <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com> <1240963225.18303.858.camel@ezra> <49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra> <49F79F26.9060309@zytor.com> <1240965831.18303.944.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240965831.18303.944.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 29, 2009 at 12:43:51PM +1200, Daniel Reurich wrote:

> In which case your probably using a hardware raid controller anyway so
> not our problem.  Otherwise if the array is broken by a failed
> controller we probably shouldn't boot of it anyway.

I have set up a box with 8 SATA disks attached to 2 on-board
controllers. The BIOS can boot from any of the controllers, but then it
can only see the disks that are attached to the selected controller.
Which is quite reasonable if the BIOS handles the controller selection
by redirecting INT 13h (I have not checked).

With "/" on RAID1, I can boot in any failure scenarios (I've actually
tested that anno). With your setup, the box would never boot, since it
could never access enough disks in a RAID5/6 array, even if all the
disks/controllers are perfectly fine.

> What's specifically dangerous about it?  Define the failure modes that
> this scheme is unable to either cope with that it should do.

There is no need for a failure mode. Your scheme does not work even when
everything is fine.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
