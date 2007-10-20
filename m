From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 22:38:55 +0400
Message-ID: <471A4B3F.907@msgid.tls.msk.ru>
References: <18200.49267.763509.924873@stoffel.org>  <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>  <18200.53593.687483.120827@stoffel.org>  <1192810534.1666.68.camel@firewall.xsintricity.com>  <18200.56684.14194.630264@stoffel.org>  <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>  <18200.57042.989520.666476@stoffel.org>  <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>  <1192813477.1666.74.camel@firewall.xsintricity.com>  <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan> <1192814581.1666.87.camel@firewall.xsintricity.com> <Pine.LNX.4.64.0710191347080.10857@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710191347080.10857@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Doug Ledford <dledford@redhat.com>, John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> On Fri, 19 Oct 2007, Doug Ledford wrote:
> 
>> On Fri, 2007-10-19 at 13:05 -0400, Justin Piszcz wrote:
[]
>>> Got it, so for RAID1 it would make sense if LILO supported it (the
>>> later versions of the md superblock)
>>
>> Lilo doesn't know anything about the superblock format, however, lilo
>> expects the raid1 device to start at the beginning of the physical
>> partition.  In otherwords, format 1.0 would work with lilo.
> Did not work when I tried 1.x with LILO, switched back to 00.90.03 and
> it worked fine.

There are different 1.x - and the difference is exactly this -- location
of the superblock.  In 1.0, superblock is located at the end, just like
with 0.90, and lilo works just fine with it.  It gets confused somehow
(however I don't see how really, because it uses bmap() to get a list
of physical blocks for the files it wants to access - those should be
in absolute numbers, regardless of the superblock locaction) when the
superblock is at the beginning (v 1.1 or 1.2).

/mjt
