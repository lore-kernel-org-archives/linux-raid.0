From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: stripe_cache_size and performance
Date: Mon, 25 Jun 2007 12:48:21 -0400
Message-ID: <467FF1D5.6080007@tmr.com>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>  <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>  <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig> <5d96567b0706220801v76c1c19cl7448050e62e0860b@mail.gmail.com> <Pine.LNX.4.64.0706221110220.4196@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706221110220.4196@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Raz <raziebe@gmail.com>, jnelson-linux-raid@jamponi.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> I have found a 16MB stripe_cache_size results in optimal performance 
> after testing many many values :)

We have discussed this before, my experience has been that after 8 x 
stripe size the performance gains hit diminishing returns, particularly 
for typical write instead of big aligned blocks, possibly with O_DIRECT. 
I would suggest that as a target even on a low memory machine.

Do your tests show similar? I was only able to test three and four drive 
setups using dedicated drives.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

