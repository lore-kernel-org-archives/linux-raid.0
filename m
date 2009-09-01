From: Alex Butcher <linraid@assursys.co.uk>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Tue, 1 Sep 2009 08:34:11 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0909010831350.5545@sbhezbfg.of5.nffheflf.cev>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anil Raj <anil.calvin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 31 Aug 2009, Anil Raj wrote:

> Hi all,
> I have a dell PowerEdge 1850 server with 146gb HDs setup using (I
> think) hardware RAID.
>
> 1. Is there anyway that I can confirm if the HDs are indeed setup
> using hardware RAID? (hopefully without rebooting the system) And if
> so, how do I determine the tech details of the RAID setup?
>

Assuming things haven't changed since I last used Dell's hardware RAID
controllers, you'll need 'dellmgr' from the driver kit/utils. You should
have received this on one of the CDs, or you can use the Dell tag to look up
the appropriate downloads for the machine on Dell's support site.

> 2. I'm planning on buying additional dell drives and was wondering how
> I could go about growing/expanding the current RAID setup to include
> the new drives. Is there any documentation on expanding hardware RAID?
> ( I found doc on growing software RAID on the mailing list's wiki but
> none on hardware RAID.)

I don't think this is possible; I think you'll need to backup, upgrade, then
restore onto the new discs. Again, using the Dell support site will find you
the manuals for the RAID controller installed in your machine.

> I really really hope someone can help me with these questions, please.
> Also, if this is not the right forum (and there is a more relevant
> forum) for these questions, please do let me know.
>
> Thanks much in advance!
>
> Best,
> Anil

HTH,
Alex
