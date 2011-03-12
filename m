From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Sat, 12 Mar 2011 09:40:43 -0500
Message-ID: <4D7B85EB.60505@turmel.org>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com> <AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com> <alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/12/2011 12:56 AM, Mikael Abrahamsson wrote:
> On Fri, 11 Mar 2011, Rory Jaffe wrote:
> 
>> 3. Is there something I did that caused the crash?
> 
> Mdadm has no concept of filesystem, it works on the block device.
> 
> From your text you give no indication that you shrunk the filesystem before shrinking the block device. Did you?
> 

Also, you didn't say what kind of filesystem it is.  Some don't support shrinking at all (XFS is one), or don't support shrinking while running (most of them).

You will very likely need to do this from a LiveCD of one form or another.  If your filesystem cannot be shrunk, you'll need to make a fresh backup, reformat, and restore.

(You do have a backup, don't you?)

Phil
