From: Andrew Walrond <andrew@walrond.org>
Subject: Re: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Sat, 8 Oct 2005 17:39:35 +0100
Message-ID: <200510081739.35566.andrew@walrond.org>
References: <200510071111.46788.andrew@walrond.org> <200510081555.41159.andrew@walrond.org> <17223.61190.917668.850611@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932149AbVJHQji@vger.kernel.org>
In-Reply-To: <17223.61190.917668.850611@smtp.charter.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, Molle Bestefich <molle.bestefich@gmail.com>, htejun@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 October 2005 17:08, John Stoffel wrote:
>
> Hmm... I've been watching those 3ware discussions with interest as
> well, but I haven't seen any commments on how well they work as JBOD
> controllers, esp if you get smaller ones with fewer channels and
> stripe/mirror between controllers.  If you pair disks between
> controllers, then that should limit the downtime, and also improve
> performance.

My application has hundreds/thousands of threads doing simultaneous small 
reads, with infrequent small writes. Any problems would probably be mitigated 
by having loads of ram for linux to use as disk cache, but this does seem to 
be an access model at which the 3ware hardware is not good at handling. Of 
course, it never hurts to remind them in a public forum; nothing focuses the 
corporate mind better than bad press ;)

Andrew Walrond
