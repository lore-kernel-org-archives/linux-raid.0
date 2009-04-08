From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID halting
Date: Wed, 08 Apr 2009 09:45:37 +0100
Message-ID: <49DC6431.2020404@anonymous.org.uk>
References: <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/04/2009 18:47, Leslie Rhorer wrote:
> [...]  What puzzles me
> (among other things) is why do 5 of the drives show zero reads while 5 of
> them show very low levels of read activity, and always the same 5 drives?

Can you identify how these drives are connected? If I recall correctly, 
you're using port multipliers (because you have to); is there anything 
like a pattern between the activity of drives and the PMPs or PMP 
channels they're connected to?

To borrow your expression, PMPs have left me with a bad taste in my 
mouth. Actually ReiserFS has too, though that was much longer ago.

Anyway, apologies for my last mini-flame (is that a smoulder?), and best 
of luck getting to the cause of your problem.

Cheers,

John.

