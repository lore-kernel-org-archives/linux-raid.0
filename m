From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Strange behaviour on "toy array"
Date: Mon, 16 May 2005 14:54:01 -0700
Message-ID: <42891679.2090902@ucolick.org>
References: <20050516184049.90DDA11416@smtp.ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050516184049.90DDA11416@smtp.ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ruth Ivimey-Cook wrote:

>
>Yes, I believe this interpretation is correct. Moreover, I've seen this happen
>"for real": when two drives died on my raid5 array while I was playing, I
>started to see some I/O errors, but only for things that hadn't just been
>accessed: recently accessed things were returned fine. As time went by, even
>those disappeared.
>
>I must admit, it's rather disconcerting, but it is a logical result of having a
>block cache.
>  
>
This makes sense, however, I would have expected /proc/mdstat or 
something telling me the array is DEAD. It seems "clean, degraded" is 
not a proper description of a raid5 without any working drives... Or 
would this not happen until I tried to write to it (which I haven't 
gotten to yet)?

I must admit I don't remember seeing in the FAQ or anywhere what is 
supposed to happen when you lose more than one drive. I sort of expected 
to have the entire array go offline, but it seems it just limps along 
like a normal faulty drive would do?

/Patrik

