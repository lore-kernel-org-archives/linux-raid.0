From: Dag Nygren <dag@newtech.fi>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 19:05:31 +0300
Message-ID: <1829715.RaAbOq6Xvn@eseries.newtech.fi>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <2614300.keHkAfZ48K@eseries.newtech.fi> <526A6235.2020801@turmel.org>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526A6235.2020801@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, yuji_touya@yokogawa-digital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 25 October 2013 08:21:09 Phil Turmel wrote:
> Good morning Dag,
> 
> On 10/25/2013 03:27 AM, Dag Nygren wrote:
> 
> > Just enabling scterc (which is disabled by default and will be
> > after a power down of the drive), setting the timeout 
> > and then running a repair on the array
> > fixed it for me as md was smart enough to try to rewrite the
> > sector(s) that had failed and with scterc the drive would then reallocate
> > the failed sector. 
> > I thought I had this done, but a syntax error in the script had
> > prevented it from working.. :-( )
> > 
> > The working script I ran for this was:
> > =============================
> > # Set up RAID drive timeouts
> > for x in b c d e
> > do
> >         smartctl -l scterc,70,70 /dev/sd$x
> >         echo 180 >/sys/block/sd$x/device/timeout
> > done
> > ==============================
> 
> You shouldn't do both.  You only need the long driver timeout if the
> hard disk doesn't support scterc.  Long timeouts are bad for application
> software, as you can get very long system pauses while waiting for a
> sector recovery.  But the long timeout is the only option if you have
> non-scterc drives.

Ok, Just wanted to be on the safe side.. And this array is just serving
my MythTV recordings, so not very critical.

> Some time ago I posted a similar script that checked the result code
> from smartctl.  It only resets the driver timeout if smartctl couldn't
> set scterc.

This is of course even more optimal.

Thanks!
Dag
