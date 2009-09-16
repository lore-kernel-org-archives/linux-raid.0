From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Wed, 16 Sep 2009 11:41:15 +0200
Message-ID: <87ws3z5iro.fsf@frosties.localdomain>
References: <h8nbt5$n8p$1@ger.gmane.org>
	<alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nfoe$n8p$3@ger.gmane.org>
	<alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nreb$n8p$4@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h8nreb$n8p$4@ger.gmane.org> (Matthias Urlichs's message of "Tue,
	15 Sep 2009 10:48:43 +0000 (UTC)")
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs <matthias@urlichs.de> writes:

> On Tue, 15 Sep 2009 08:37:52 +0100, Alex Butcher wrote:
>
>> Either way, it's not
>> suitable for data I even care a little bit about.
>
> Ordinarily I'd agree with you. In this case, however, the data is mostly 
> read-only and on backup media. So I don't really care if the disks fall 
> off the edge of a cliff; the data will survive.
>
> I can justify a moderate amount of time working on this, with the 
> hardware I have. I can't really justify buying eight new disks.
>
> NB: Please don't dismiss this kind of setup out of hand. I know that 
> disks are cheap enough these days that the typical professional user 
> won't ever need to worry about not being able to replace hardware which 
> behaves like this. However, many people happen to be in a different 
> situation. :-/

How about making it re-read repaired blocks so it catches when the
disk didn't remap?

I'm assuming the following happens:

1) disk read fails
2) raid rebuilds the block from parity
3) raid writes block to bad disk
4) disk writes data to the old block and fails to detect a write error
   that would trigger a rempapping
5) re-read of the data succeeds because the data is still in the
   drives disk cache
6) later read of the data fails because nothing was remapped

So you would need to write some repair-check-daemon that remembers
repaired blocks, waits for enough data to have passed through the
drive to flush the disk cache and then retries the block again.
And again and again till it stops giving errors.


Alternatively write a re-map device-mapper target that reserves some
space of the disk and remaps bad blocks itself.

MfG
        Goswin
