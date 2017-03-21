From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 15:31:48 +0000
Message-ID: <58D14764.60909@youngman.org.uk>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <58D1244E.3040204@hesbynett.no>
 <CAJH6TXih4wv10WDGOA2PT-b8FSetx06D237HS_cpT4+Ap0d0dg@mail.gmail.com>
 <58D1381E.1080101@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D1381E.1080101@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 14:26, David Brown wrote:
> It is possible that if there are a large number of UREs from a drive,
> that the RAID system will consider the whole drive bad and drop it.  But
> other than that, UREs will be treated independently.

Doesn't mdadm have a setting that does exactly that? Too many UREs and
the drive gets dropped? I'm sure I've come across that interfering with
rebuilds.

Cheers,
Wol
