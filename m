From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Sun, 13 Jun 2010 16:28:34 +0200
Message-ID: <201006131628.35037.bernd.schubert@fastmail.fm>
References: <4C1128C2.4020105@meetinghouse.net> <001501cb091f$07ac4e40$1704eac0$@woodlea.com> <20100611145019.6f1a5e7d@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611145019.6f1a5e7d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 11 June 2010, Neil Brown wrote:
> On Fri, 11 Jun 2010 00:31:57 -0400
> 
> "Graham Mitchell" <gmitch@woodlea.com> wrote:
> > Can you do this on a live array, or can it only be done (as the docs seem
> > to suggest), with the create, build and grow options?
> 
> As 'grow' can (and must) be used on a live array you're question doesn't
> exactly make sense.
> Yes: it can be done on a live array.

While I have done this myself a couple of times, I still do not understand 
where it takes the disk space for the bitmap journal from? Is this space mdadm 
reserved for this purpose?


Thanks,
Bernd
