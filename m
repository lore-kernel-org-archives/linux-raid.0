From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Sat, 29 Apr 2017 11:56:56 +0200
Message-ID: <20170429095656.GA4030@metamorpher.de>
References: <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
 <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de>
 <4c5d312b-fba6-da20-e08f-ed1a4ba5c313@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c5d312b-fba6-da20-e08f-ed1a4ba5c313@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 29, 2017 at 12:46:15AM +0200, Patrik Dahlström wrote:
> mdadm: cannot open /dev/sda: Device or resource busy

Well, normally you're not supposed to do this. :-)
Easy to wreck your data if you do.

> My overlay setup is keeping /dev/sd[abdce] busy. How do I setup the
> overlay to keep it from occupying the disks?

You could create the RAID first and the overlay afterwards.
Or you can create loop devices on the busy devices and use those.

Regards
Andreas Klauer
