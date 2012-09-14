From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Small short question
Date: Fri, 14 Sep 2012 17:43:01 +0100
Message-ID: <20563.24213.638530.461182@tree.ty.sabi.co.UK>
References: <5030F07F.7000303@schinagl.nl>
	<504CFA7B.7090606@schinagl.nl>
	<20120910090829.19100cdf@notabene.brown>
	<504DA85C.6080000@schinagl.nl>
	<20120911161622.0b0fcf8c@notabene.brown>
	<505301E1.10707@schinagl.nl>
	<50531A52.7060205@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50531A52.7060205@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Since I had only one valid device to check with etc, I assume
> that if fsck -n -f /dev/md2 runs sucessfully, it is 100% safe
> to assume the array is perfectly healthy?

If the filesystem used supports both metadata and data checksums
and its 'fsck -f' does verify all of them, then yes. Otherwise
obviously no.

> [ ... ] recommended to simply create a new array, with a new
> FS on it, and copy all data over (Logically also with
> /dev/md2, /dev/sda6 missing and later adding sdb6)?

Given the number of people who ask here to recover the unique
data they have on a RAID set, perhaps it is good to restate here
that RAID does not mean "no longer need backups" :-).

>> [ ... ] I was wrong. I was so sure I made it o2, that I ruled
>> out the possibility it being f2. [ ... ] Short story short,
>> it turns out it was 128k chunks, Far2 offset. [ ... ]

While you go the lengths of choosing particular layouts on
specific filetrees, saving the output of '--scan' in
'mdadm.conf' seems strangely to have been a lower priority :-).
