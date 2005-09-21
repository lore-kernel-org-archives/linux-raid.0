From: Al Boldi <a1426z@gawab.com>
Subject: Re: Good, recent FS comparison?
Date: Thu, 22 Sep 2005 00:34:42 +0300
Message-ID: <200509220034.42284.a1426z@gawab.com>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <200509162258.37730.a1426z@gawab.com> <20050921153703.GB19896@mail.shareable.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20050921153703.GB19896@mail.shareable.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Jamie Lokier wrote:
> Al Boldi wrote:
> > ext3 is rock-solid!
>
> If only.  Recently I had a system come up after a power cycle with a
> directory where reading any file in that directory gives an I/O error.
> The disk is fine, and it's using ext3 in ordered mode, with IDE
> write-caching disabled to be sure.

2.4 or 2.6?

In 2.4 try a reboot and force an fsck before mounting.

--
Al

