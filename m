From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 xor help
Date: Sat, 16 Oct 2004 10:29:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16752.27499.158135.485537@cse.unsw.edu.au>
References: <8f8a51940410142126557f5198@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Srinivasa S on Friday October 15
To: Srinivasa S <srinivasa.s@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 15, srinivasa.s@gmail.com wrote:
> Hello,
> 
> I was going thru the raid5 code in the linux software raid. I could
> not figure out the parity computation. The mothod 'compute_parity' is
> somehow calling functions like 'do_2' , 'do_3' , etc - but I could not
> find their defnitions anywhere. Is there any documentation about the
> raid implementations in linux? Could you please help me out in this
> regard. Thanks.

   include/asm-*/xor.h

No substantial documentation (Apart from the source).

NeilBrown

> 
> Regards,
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
