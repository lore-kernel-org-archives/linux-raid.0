From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Re: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 12:31:03 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00c701c33050$00057360$7b07a8c0@pluto>
References: <3EE74472.9010505@geodev.com> <1055350640.1929.28.camel@langvan.austin.ibm.com> <3EE76EDA.1060000@geodev.com> <1055359074.1929.70.camel@langvan.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Tran <mhtran@us.ibm.com>, Matthew Mitchell <matthew@geodev.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am doing a sparc thingin. I have to build
the disk images on a x86 system, and move the
disk to my sparc, for debug/test.  Everhting works
fine, except the MD's SB.  I tweaked a bit on MD
driver, then everything is good.  I would think that
MD should take care the SB format in next release.


----- Original Message ----- 
From: "Mike Tran" <mhtran@us.ibm.com>
To: "Matthew Mitchell" <matthew@geodev.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, June 11, 2003 12:17 PM
Subject: Re: Move md raid5 from intel to sparc?


> On Wed, 2003-06-11 at 13:03, Matthew Mitchell wrote:
> 
> > What _about_ the filesystem and data, though?  Some filesystems are 
> > certainly written in a known byte-order, like ISO 9660.  Are there any 
> > of (ext3, XFS, JFS, reiserfs) that this is true for?  Or are they all 
> > written in cpu native byte-order?
> 
> Just look at the current releases of kernel, 2.4 and 2.5, all of the
> above filesytems seem to write metadata using one known byte-order (ei.
> always BE or always LE).  Now all we need is testing.
> 
> -Mike Tran
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

