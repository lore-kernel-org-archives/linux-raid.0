From: Neil Brown <neilb@suse.de>
Subject: Re: LINEAR RAID, little help
Date: Thu, 12 Apr 2007 18:08:45 +1000
Message-ID: <17949.59661.6968.6058@notabene.brown>
References: <46177DD8.9080707@pcfusion.co.uk>
	<20070407173352.GA23645@gmail.com>
	<4617E5E2.2090609@pcfusion.co.uk>
	<17948.6604.619118.556382@notabene.brown>
	<461DE4CA.9020406@pcfusion.co.uk>
	<461DE688.4070808@pcfusion.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rich on Thursday April 12
Sender: linux-raid-owner@vger.kernel.org
To: Rich <rich@pcfusion.co.uk>
Cc: gmccullagh@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 12, rich@pcfusion.co.uk wrote:
> I forgot to ask something, sorry. With RAID0 and all the odd size drives 
> I have I'd get a lot of left over unused space. Is there anyway to make 
> use of this slack?

md/raid0 makes use of all available space (modulo chunk size).
To quote from "man md"

   RAID0
       A  RAID0  array  (which has zero redundancy) is also known as a striped
       array.  A RAID0 array is configured at creation with a Chunk Size which
       must be a power of two, and at least 4 kibibytes.

       The  RAID0  driver  assigns  the  first chunk of the array to the first
       device, the second chunk to the second device,  and  so  on  until  all
       drives have been assigned one chunk.  This collection of chunks forms a
       stripe.  Further chunks are gathered into stripes in the same way which
       are assigned to the remaining space in the drives.

       If devices in the array are not all the same size, then once the small‐
       est device has been  exhausted,  the  RAID0  driver  starts  collecting
       chunks  into smaller stripes that only span the drives which still have
       remaining space.


(If you think that isn't suitable clear, you are probably correct.
Improvements always welcome).

NeilBrown
