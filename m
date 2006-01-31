From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [klibc] Re: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 22:49:07 -0800
Message-ID: <20060131064907.GA10934@taniwha.stupidest.org>
References: <43DEB4B8.5040607@zytor.com> <17374.47368.715991.422607@cse.unsw.edu.au> <43DEC095.2090507@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43DEC095.2090507@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 30, 2006 at 05:42:45PM -0800, H. Peter Anvin wrote:

> What about non-DOS partitions?

Is something like libblkid suitable as a starting point of something
you can cut-down-to-size?

   text    data     bss     dec     hex filename
  24978    2272      12   27262    6a7e /lib/libblkid.so.1
