From: vinnakota chaitanya <chaitanyaa_v@yahoo.com>
Subject: Re: Implementing Encryption and Decryption in Raid Device Driver.
Date: Thu, 15 Sep 2005 00:31:18 -0700 (PDT)
Message-ID: <20050915073118.61198.qmail@web54703.mail.yahoo.com>
References: <62b0912f050914123756d1f3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f050914123756d1f3d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: molle.bestefich@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- Molle Bestefich <molle.bestefich@gmail.com> wrote:

> Use loop-aes, it's absolutely fabulous.
> 
> It works great with 2.4 as well as 2.6.
> 
> Instructions here.
> http://loop-aes.sourceforge.net/loop-AES.README
> 

Thanks for the suggestion. 
Now I've the following two issues:

1. The target device is fat filesystem formatted. The
target kernel image do not contain the fat filesystem
module. The target device [ i.e. /dev/md0 ]   is
mounted by the host through USB interface. Hence, in
this case the host's fat filesystem code is used.
	Will loop-aes work in this situation.

2. We were asked to use blow_fish algorithm instead.
So, how to go about it, are there any modules like
loop-aes or should I  consider the hooks
 raid5_make_request and raid5_end_read_request 
for encryption and decryption

Please suggest a solution.

Regards
Chaitanya..



__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
