From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: 'resync=PENDING', 'auto-read-only' on raid1 creation
Date: Sat, 4 Jan 2014 17:44:00 +0000
Message-ID: <BLU0-SMTP170A5558CBF293E3A7E67D998B50@phx.gbl>
References: <52C80C81.3040004@tesco.net> <52C83903.8020204@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C83903.8020204@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Ron Leach <ronleach@tesco.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2014-01-04 at 11:38 -0500, Phil Turmel wrote:

> 
> "auto-read-only" is a safety measure that prevents any writes to an
> array until something in the data area is written.  I don't remember the
> rules MD uses to determine if any given assemble/create operation
> qualifies, but it isn't an error.

That explains an issue I had when creating a brand new raid6 and it
failed to start a sync as I expected it to... I probably went round the
house to "fix" it and ended up using a "missing" then adding the missing
drive which started the sync.

I guess its one of the problems, that isn't, that "just happens" when
you start to keep too close an eye on things, such as a "watch
proc/mdstat" in another window where as before I probably would have
just created it, added a file system, and been none the wiser :-/

> 
> Just perform pvcreate on the array as you intended, and that'll switch
> the array to rw (and start the resync).
> 
> HTH,
> 
> Phil

