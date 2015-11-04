From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Advice requested re: hard drive setup for RAID arrays
Date: Wed, 4 Nov 2015 19:42:15 +0000
Message-ID: <563A5F97.2060107@youngman.org.uk>
References: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
 <563A0462.9000200@turmel.org>
 <CACsGCyQGChMLXfQ3G-DN+Y7mh9w7wFkmQ9274VFKBzSoOgaoUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyQGChMLXfQ3G-DN+Y7mh9w7wFkmQ9274VFKBzSoOgaoUQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/15 19:36, Edward Kuns wrote:
> Is there a reasonable way of finding out if a shorter setting is
> appropriate for any specific drive?  Or would you say in general it's
> not worth the effort of trying to find out?  Would you expect this
> behavior to be any different for an SSD?

aiui,what matters is that the linux-level timeout is longer than the
disk timeout. Given that, the length of the linux timeout is irrelevant
- once the disk times out linux will handle the problem.

SSDs - I wouldn't have a clue ...

Cheers,
Wol
