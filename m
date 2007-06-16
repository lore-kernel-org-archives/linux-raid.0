From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 13:47:07 +1000
Message-ID: <18035.23867.576212.859440@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<20070616020320.GB2002@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wakko Warner on Friday June 15
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 15, wakko@animx.eu.org wrote:
 
>                                                   As I understand the way
> raid works, when you write a block to the array, it will have to read all
> the other blocks in the stripe and recalculate the parity and write it out.

Your understanding is incomplete.
For raid5 on an array with more than 3 drive, if you attempt to write
a single block, it will:

 - read the current value of the block, and the parity block.
 - "subtract" the old value of the block from the parity, and "add"
   the new value.
 - write out the new data and the new parity.

If the parity was wrong before, it will still be wrong.  If you then
lose a drive, you lose your data.

With the current implementation in md, this only affect RAID5.  RAID6
will always behave as you describe.  But I don't promise that won't
change with time.

It would be possible to have a 'this is not initialised' flag on the
array, and if that is not set, always do a reconstruct-write rather
than a read-modify-write.  But the first time you have an unclean
shutdown you are going to resync all the parity anyway (unless you
have a bitmap....) so you may as well resync at the start.

And why is it such a big deal anyway?  The initial resync doesn't stop
you from using the array.  I guess if you wanted to put an array into
production instantly and couldn't afford any slowdown due to resync,
then you might want to skip the initial resync.... but is that really
likely?

NeilBrown
