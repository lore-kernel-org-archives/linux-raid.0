From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Force parity resync on raid5?
Date: Thu, 12 Aug 2004 14:16:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408121816.i7CIGw312397@watkins-home.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F013446A3@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F013446A3@otce2k03.adaptec.com>
To: "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, 'Philip Molter' <philip@corp.texas.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil once said md is smart enough to do whichever method takes less disk io.
It will read, read, write, write if it cost less than write the whole
stripe.  So a full stripe write would re-do the parity.  Maybe the dd block
size should be an even multiple of the stripe size.

From an email dated 6/9/2004:
" md sometimes does a "read-modify-write" cycle like your first example, and
sometimes does a "reconstruct-write" cycle like your second example.  It
chooses the option that generates the fewest IO requests.

NeilBrown"

A new option was added to mdadm:
"--update=resync for --assemble mode to for a resync when the
        array is assembled."

But until you can upgrade, the dd trick should be good.  If the filesystem
is not mounted and the dd block size is a multiple of the strip size.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Thursday, August 12, 2004 1:15 PM
To: Philip Molter; linux-raid@vger.kernel.org
Subject: RE: Force parity resync on raid5?

But, does this occur for full stripe writes?

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Philip Molter
Sent: Thursday, August 12, 2004 1:08 PM
To: linux-raid@vger.kernel.org
Subject: Re: Force parity resync on raid5?

No, it wouldn't.  In RAID5 implementations, parity isn't recalculated 
when you write to a RAID,  It's updated.  My understanding is that 
typical implementations are, *VERY* basically:

read the old data
xor with the new data
read the parity data
xor with the parity data
write the new data
write the new parity data

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

