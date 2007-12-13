From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: mdadm break / restore soft mirror
Date: Wed, 12 Dec 2007 20:00:39 -0800
Message-ID: <e03b90ae0712122000m439069y8ccad65c59cf4de9@mail.gmail.com>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
	 <18272.34965.638276.892803@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18272.34965.638276.892803@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Brett Maton <Brett.Maton@simplyhealth.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Proposed solution is to use software raid mirror.  Before backup starts,
>break the soft mirror unmount and backup partition

I use this method for backup once a week.

One challenge is drives aren't great at steaming data quickly (for the resync)
while also doing a lot of random access. Having a little extra redundancy (think
3 or more drives in the RAID-1) can really help.

>If you can be certain that the device that you break out of the mirror
>is never altered, then you could add an internal bitmap while the
>array is split and the rebuild will go much faster.

Is this also a viable speedup for the "kep rotating backup drives through
the array" strategy? If so, how much speedup are we talking about? Assume
the array changes by 1% before a backup drive gets rotated in again.

Jeff
