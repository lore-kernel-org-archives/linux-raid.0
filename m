From: aragonx@dcsnow.com
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 08:17:26 -0500 (EST)
Message-ID: <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
    <4B5EB5BD.7070406@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B5EB5BD.7070406@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> In theory if you stop the current resync, try to recreate it in all
> possible permutations of 5 drives using --assume-clean during creation
> so to prevent any resyncs (and just mount readonly!) then try mounting
> it or try fsck -n to see if data makes sense, you might be able to get
> data out of it. I have never tried this technique, I read it from a post
> by Neil Brown in this ML, date 12/04/2009 10:12 PM, subject "Re: RAID5
> demise or coma? after re-creating with a spare" try looking for it in
> the archives

Wow.

I tried several times to assemble the array but I was not aware that it
has to be in the same order.  That explains a lot.  Time for a hardware
RAID controller.  :)  Thank you for the information.

---
Will Y.


