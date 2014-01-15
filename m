From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original
 devices show no md superblock
Date: Wed, 15 Jan 2014 12:50:19 +0000
Message-ID: <BLU0-SMTP2298EF7EE934F21F583ECCA98BE0@phx.gbl>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>
	 <52D183B5.3060006@turmel.org>
	 <1389632980.11328.104.camel@achilles.aeskuladis.de>
	 <52D4337F.4050307@turmel.org>
	 <1389695513.11328.158.camel@achilles.aeskuladis.de>
	 <52D5384E.6030408@turmel.org>
	 <BLU0-SMTP57BD7000137CADA6A976CA98BF0@phx.gbl>
	 <52D58539.7090501@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52D58539.7090501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "=?ISO-8859-1?Q?=22Gro=DFkreutz=2C?= Julian\"" <Julian.Grosskreutz@med.uni-jena.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, 2014-01-14 at 13:43 -0500, Phil Turmel wrote:
> On 01/14/2014 12:47 PM, Wilson Jonathan wrote:
> 
> [trim /]
> 
> > I understand the issue of "timeout" on drives that might perform long
> > error checking which then causes mdadm, via the device (block?) driver
> > issuing a time out, to then kick the drive. In this instance you allow
> > some time for a drive to try and fix things at the expense of a hung
> > array for a longer period of time.
> > 
> > I also understand that with scterc the drive gives up (in effect timing
> > its self out) when it hits the 7 second, or there about, mark and
> > subsequently mdadm kicks the drive out. In this specific instance the
> > idea is to kill a drive quickly to that the raid doesn't hang longer
> > than a few seconds.
> 
> No.  The intent is to fail the read without failing the controller channel.

Arrr, thanks for the clarification... I hadn't realised that instead of
the drive returning a "Error, I can't get the data, I'm dead in the
water" message it instead returned a "warning, I can't get the data, you
deal with it and get back to me, I'm still working" kind of affair.

> 
> > However surely these things (bar the amount of time) result in the same
> > final result of a drive being kicked out. Even in a non-madam hardware
> > raid set up, the drive is either kicked because it didn't return in 7
> > seconds, or the drive kicks its self because it gave up before 7
> > seconds.
> 
> No.  Upon a failed read, MD will obtain/reconstruct the problem sector
> from remaining redundancy, then write the correct data back.  Occasional
> read errors of this type are normal, and fix themselves when the sector
> is written again.  MD will only fail a drive after *multiple* read
> errors, not just one.  (Isolated bursts of up to 20, then ~ ten per hour.)
> 

I see now... I had totally the wrong idea of what happened and how they
differed. 

> [trim /]
> 
> > Surely, unless I'm missing something, rebuilding a failed drive's data
> > means that you want the system to not kick if at all possible and having
> > scterc enabled or a short timeout (shorter than the drives max time,
> > unless that time is indefinite retry) is the last thing you want?
> 
> What you are missing is what happens when the controller channel times
> out.  The original read is reported failed to MD while the driver tries
> to revive the unresponsive drive.  MD proceeds to obtain/reconstruct the
> missing data, then write back.  But the device is not communicating--the
> driver has reset the channel, and will continue not communicating until
> the drive firmware finally gives up on the original read.  So the
> *write* fails instantly, kicking the drive out of the array.
> 
> When you, the admin, get around to looking, the drive is idle but
> apparently fine.  (It gains a "pending" sector, which stays until the
> drive is told to write over that spot.)
> 
> HTH,

It does, thanks for the information :-)

> 
> Phil
> 

Jon


