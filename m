From: Phil Turmel <philip@turmel.org>
Subject: Re: proactive disk replacement
Date: Wed, 22 Mar 2017 10:32:23 -0400
Message-ID: <b5d52a2a-2662-86bf-5b65-10f3770a7d3a@turmel.org>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
 <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
 <58D126EB.7060707@hesbynett.no>
 <09f4c794-8b17-05f5-10b7-6a3fa515bfa9@thelounge.net>
 <58D13598.50403@hesbynett.no> <58D145F9.1080405@youngman.org.uk>
 <58D14998.1060601@hesbynett.no>
 <f90b9218-85ef-6af1-fa78-e3641a307566@turmel.org>
 <CAJH6TXjXR1BM6UojbbgTNpCdyyMhfO4VOG0dxYUAV59PEY+O2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjXR1BM6UojbbgTNpCdyyMhfO4VOG0dxYUAV59PEY+O2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/22/2017 09:53 AM, Gandalf Corvotempesta wrote:

> Last years i've lose a server due to 4 (of 6) disks failures in less
> than an hours during a rebuild.
> 
> The first failure was detected in the middle of the night. It was a
> disconnection/reconnaction of a single disks.
> The riconnection triggered a resync. During the resync another disk
> failed. RAID6 recovered even from this double failure
> but at about 60% of rebuild, the third disk failed bringing the whole raid down.
> 
> I was waked up by our monitoring system and looking at the server,
> there was also a fourth disk down :)
> 
> 4 disks down in less than a hour. All disk was enterprise: SAS 15K,
> not desktop drives.

You should win a prize, Gandalf.  In the several years I've participated
on this mailing list, you are the first to describe such a catastrophe
where the drives really were at fault, instead of timeout mismatch,
power supplies, cables, or controllers.

All four disks had permanent "FAILED" smartctl status after this, yes?

Phil
