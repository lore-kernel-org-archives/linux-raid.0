From: Phil Turmel <philip@turmel.org>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 13:00:06 -0400
Message-ID: <b53e8bc9-89ca-0315-3f64-63e49a773739@turmel.org>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <58D1244E.3040204@hesbynett.no>
 <CAJH6TXih4wv10WDGOA2PT-b8FSetx06D237HS_cpT4+Ap0d0dg@mail.gmail.com>
 <58D1381E.1080101@hesbynett.no> <58D14764.60909@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D14764.60909@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, David Brown <david.brown@hesbynett.no>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/21/2017 11:31 AM, Wols Lists wrote:
> On 21/03/17 14:26, David Brown wrote:
>> It is possible that if there are a large number of UREs from a
>> drive, that the RAID system will consider the whole drive bad and
>> drop it.  But other than that, UREs will be treated independently.
> 
> Doesn't mdadm have a setting that does exactly that? Too many UREs
> and the drive gets dropped? I'm sure I've come across that
> interfering with rebuilds.

Yes.  MD maintains a per-member-device counter of read errors and drops
the device when the counter reaches 20 (twenty).  The counter is
decremented by 10 (ten) once an hour.  A short burst of less than 20
read errors will be tolerated, as long as they don't continue at more
than 10/hour.

Last I checked, this behavior is hard-coded.

Phil

