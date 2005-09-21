From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Good, recent FS comparison?
Date: Wed, 21 Sep 2005 16:37:03 +0100
Message-ID: <20050921153703.GB19896@mail.shareable.org>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <432A37BF.7060305@dtbb.net> <200509162258.37730.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200509162258.37730.a1426z@gawab.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Al Boldi wrote:
> ext3 is rock-solid!

If only.  Recently I had a system come up after a power cycle with a
directory where reading any file in that directory gives an I/O error.
The disk is fine, and it's using ext3 in ordered mode, with IDE
write-caching disabled to be sure.

So while ext3 is good, I'm not convinced it's rock solid.

-- Jamie
