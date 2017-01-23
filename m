From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Input/Output error reading from a clean raid
Date: Mon, 23 Jan 2017 17:23:49 +0000
Message-ID: <58863C25.9020200@youngman.org.uk>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
 <20170123010334.GA7546@metamorpher.de>
 <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
 <22662.14390.551624.557189@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22662.14390.551624.557189@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/01/17 17:07, John Stoffel wrote:
> You have bad disks in your array.  First thing off is that I would go
> buy replacements and then use 'ddrescue' to copy the data from the old
> disks to new disks.  Then I'd try to assemble the NEW disks only into
> an array, and then I'd fsck the filesystem(s).
> 
> You're going to lose data, no doubt about it.  You're now in the mode
> where you're trying to save as much as you can as quickly as possible.
> 
> Personally, I'd be setting up a RAID6 array for your new setup.  Then
> I would also be setting up weekly checks of the raid array as well.
> 
> You're going to lose data no matter what.  So get new disks and start
> copying what you can.

Go read the raid wiki. https://raid.wiki.kernel.org/index.php/Linux_Raid

Especially replacing a failed drive
https://raid.wiki.kernel.org/index.php/Replacing_a_failed_drive

And please - can you get ddrescue's error log that it mentions and email
me a copy. If you've got some Perl or Python or shell skills, maybe you
could even write that script it mentions (which is described in a bit
more detail in programming projects
https://raid.wiki.kernel.org/index.php/Programming_projects) Otherwise
I'll try and write it - might be a good way of learning Python :-) but
at the moment I think I'm learning by jumping in out of my depth, so
we'll see how far I get :-)

Cheers,
Wol


