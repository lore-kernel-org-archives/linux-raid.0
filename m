From: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Subject: Re: partitioned raid 5 and proper partition alignment
Date: Sat, 8 Aug 2009 13:09:59 +0200
Message-ID: <200908081309.59049.ml_linux_raid@mortal-soul.de>
References: <200908080812.45509.ml_linux_raid@mortal-soul.de> <87skg2vius.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87skg2vius.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

On Saturday 08 August 2009 09:56:59 you wrote:

> But each stripe only holds 128k of data. You have to align to that.

I beg to differ. There are two data chunks and one parity chunk, thus a whole 
stripe is 192k long if you've a 64k chunk size. If you align to 128k and you 
put e.g. ext4 on it with the correct fs stride and stripe-width settings, 
you'll probably end up with worse performance since you start in the middle of 
a stripe even though properly aligned to a chunk boundary. Or am I totally on 
the wrong track here...?!

> No, nothing special about sector 0. 

So sector 0 gets striped like all the others meaning that it counts to the 
first 192k stripe? So in order to get everything properly stripe aligned it 
was correct to leave a 196.096 byte span free after sector 0.

Best regards,
matthias.
