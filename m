From: Neil Brown <neilb@suse.de>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Tue, 22 May 2007 10:50:23 +1000
Message-ID: <18002.15951.765872.809204@notabene.brown>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	<17995.46536.195175.894763@notabene.brown>
	<632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
	<632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
	<632b79000705162050w70a2feb1w14919fde6e98818c@mail.gmail.com>
	<632b79000705211232gfb57e0focae8cdd0bf25bef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Don Dupuis on Monday May 21
Sender: linux-raid-owner@vger.kernel.org
To: Don Dupuis <dondster@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 21, dondster@gmail.com wrote:
> On 5/16/07, Don Dupuis <dondster@gmail.com> wrote:
> >
> > I am still trying to get where I had the low recover rate with the
> > bitmap turned on. I will get back with you
> > Don
> >
> Any new updates Neil?
> Any new things to try to get you additional info?
> THanks
> 
> Don

You said "I will get back with you" and I was waiting for that... I
hoped that your further testing might reveal some details that would
shine a light on the situation.

One question:  Your description seems to say that you get corruption
after the resync has finished.  Is the corruption there before the
resync starts?
I guess what I would like it:
   Start with fully active array.  Check for corruption.
   Remove one drive.  Check for corruptions.
   Turn off system.  Turn it on again, array assembles with one
   missing device.  Check for corruption.
   Add device, resync starts.  Check for corruption.
   Wait for resync to finish.  Check for corruption.

NeilBrown
