From: Neil Brown <neilb@suse.de>
Subject: Re: simple question: where is internal bitmap stored?
Date: Wed, 13 May 2009 20:42:34 +1000
Message-ID: <18954.42010.122591.899035@notabene.brown>
References: <4A0A86B8.5030905@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Wednesday May 13
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 13, eyal@eyal.emu.id.au wrote:
> If I have a live raid and want to enable bitmap then I do
> 	mdadm --grow /dev/md0 --bitmap=internal
> Does this bitmap use space in the already present header? If so then
> does this mean that the headers have enough reserve for this? Why
> not always use the bitmap then?

1/ Yes.
2/ Yes.
3/ because there are other reasons for not wanting a bitmap.
   Using a write-intent bitmap can cause a reduction in throughput.

   It is conceivable that having a bitmap should be the default, but
   it should definitely be options.

   In fact, ever array does has a default bitmap.  However that bitmap
   contains exactly one bit, and it cover the whole array.  It is the
   clean/active flag.  Defaulting to a few more bits is possibly a
   good idea...
> 
> If it carves extra space from the device which already has data
> (e.g. a fs) then surely this will be problematic.

Yes.  It surely would be.

NeilBrown
