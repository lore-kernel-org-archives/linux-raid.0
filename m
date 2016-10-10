From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Why not just return an error?
Date: Mon, 10 Oct 2016 22:55:49 +0100
Message-ID: <57FC0E65.1050407@youngman.org.uk>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
 <57F7DF05.8090605@yandex.ru>
 <b9e7054f-8d68-c576-41a5-aec60c53aa9b@youngman.org.uk>
 <20161010213726.GA3757@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161010213726.GA3757@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Dark Penguin <darkpenguin@yandex.ru>, Phil Turmel <philip@turmel.org>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/16 22:37, Andreas Klauer wrote:
> On Mon, Oct 10, 2016 at 09:47:04PM +0100, Anthony Youngman wrote:
>> with a list of all blocks that failed to copy. Then we need to patch the 
>> low-level disk access code so that it reads this list of "bad blocks" 
>> and returns a read error if any attempt is made to read one. If a block 
> 
> hdparm has that feature to mark sectors as bad (--make-bad-sector).
> not sure how that behaves on a re-write by md. I never tried it myself.

I'm guessing it's useless ...

The point is that the disk sector is not bad. So you don't want to mark
it as bad on the disk. But you know that the *data* in that block is
bad, so you want the disk access layer to fake a read error when you try
to read it. The intent is to deliberately trigger a rewrite by md.
> 
> Maybe you could also do something with device mapper. It does have 
> an error target, and then there's the overlay. I wish dmsetup had 
> some profiles/shortcuts/reciped to make creation of such device mapper 
> tidbits easier or another common tool for those device mapper tricks...
> 
That certainly sounds plausible ...

Cheers,
Wol

