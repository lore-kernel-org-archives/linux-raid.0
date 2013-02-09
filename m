From: Joseph Glanville <joseph.glanville@orionvm.com.au>
Subject: Re: [PATCH] mdadm: fix portability issues encountered while building
 against musl libc
Date: Sun, 10 Feb 2013 10:40:09 +1100
Message-ID: <CAOzFzEhkwXiFN=GwPrdXL1O0JaG3WR8iarzKnpFfNQ-tH3DJ0A@mail.gmail.com>
References: <5116D8A7.6070409@barfooze.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5116D8A7.6070409@barfooze.de>
Sender: linux-raid-owner@vger.kernel.org
To: John Spencer <maillist-mdadm@barfooze.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10 February 2013 10:15, John Spencer <maillist-mdadm@barfooze.de> wrote:
>

Hi,

Inline patches are prefered to ease review, you can use git send-email
to send the patches directly from the command line following a
tutorial like this:
http://blog.bisect.de/2012/01/how-to-send-patches-via-git-send-email.html

That aside I don't think removing Werror is the correct choice, mdadm
is primarily compiled with gcc + glibc.
If you are using a non-default compiler collection, chances are you
can handle removing Werror yourself or correcting the issues and
posting the patches here such as you did.


-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
