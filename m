From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: avoiding the initial resync on --create
Date: Thu, 12 Oct 2006 01:24:06 +0400
Message-ID: <452D60F6.5060000@tls.msk.ru>
References: <20061009125700.GA10191@piper.madduck.net>	 <20061009134946.GA26122@harddisk-recovery.com>	 <1160411520.2917.76.camel@fc6.xsintricity.com>	 <37950.192.168.0.1.1160421056.squirrel@bymeinc.com> <1160423139.2917.112.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1160423139.2917.112.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Rob Bray <raid@bymeinc.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Mon, 2006-10-09 at 15:10 -0400, Rob Bray wrote:
[]
> Probably the best thing to do would be on create of the array, setup a
> large all 0 block of mem and repeatedly write that to all blocks in the
> array devices except parity blocks and use a large all 1 block for that.
> Then you could just write the entire array at blinding speed.  You could
> call that the "quick-init" option or something.  You wouldn't be able to
> use the array until it was done, but it would be quick.  If you wanted
> to be *really* fast, at least for SCSI drives you could write one large
> chunk of 0's and one large chunk of 1's at the first parity block, then
> use the SCSI COPY command to copy the 0 chunk everywhere it needs to go,
> and likewise for the parity chunk, and avoid transferring the data over
> the SCSI bus more than once.

Some notes.

First, raid array gets created sometimes in order to repair a broken array.
Ie, you had an array, you lose it for whatever reason, and re-create it,
avoiding initial resync (--assume-clean option), in a hope your data is
still here.  For that, you don't want to zero-fill your drives, for sure! :)

And second, at least SCSI drives have FORMAT UNIT command, which has a
range argument (from-sector and to-sector), and, if memory serves me
right, also "filler" argument as well (the data, 512-byte block, to
write to all the sectors in the range).  (Well, it was long ago when
I looked at that stuff, so it might be some other command, but it's
here anyway).  I'm not sure it's used/available in block device layer
(most probably it isn't).  But this is the fastest way to fill (parts
of) your drives with whatever repeated pattern of bytes you want.
Including this initial zero-filling.

But either way, you don't really need to do that in kernel space --
Userspace solution will work too.  Ok ok, if kernel is doing it after
array creation, the array is available immediately for other use,
which is a plus.

And yes, I'm not sure implementing it is worth the effort.  Unless
you're re-creating your multi-terabyte array several times a day ;)

/mjt
