From: Marco Scoffier <marco@metm.org>
Subject: Re: old raid0run
Date: Sun, 11 Feb 2007 02:45:30 -0500
Message-ID: <pan.2007.02.11.07.45.23.972989@metm.org>
References: <pan.2007.02.11.06.33.05.974944@metm.org> <45CEBED1.6000702@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 11 Feb 2007 09:59:29 +0300, Michael Tokarev wrote:

> Marco Scoffier wrote:
>> Hello all,
>> 
>> I have an old raid0 with no superblocks.
>> 

> Well, mdadm is able to assemble it.  It's called 'build' (--build) --
> 
>   mdadm --build -n 2 -c 128 -l 0 /dev/md0 /dev/hde1 /dev/hdg1
>

Thanks for the clarification Micheal.  Reading the docs, I got a little
confused about what --build was for.

>> or should I build a new raid0 and then upgrade that to a raid0 with
>> superblocks (how would I do that?)
> 
> I think the best option is to convert it to raid0-with-superblocks. For
> that, I'd go this route:
> 
>   - build the array as above
>   - fsck the filesystem on it
>   - resize the filesystem to be, say, 1Mb smaller - stop the array -
>   create new array as you've shown above with -C - and finally resize
>   the filesystem to utilize all available space
> 

Thanks for these steps.  I am running them now.

Thanks for an amazingly fast and clear response.

-- 
Marco

