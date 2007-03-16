From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 11:16:58 +0100
Message-ID: <20070316101658.61685352604@atlas.denx.de>
References: <e9c3a7c20703152255q16563803q33a5893c210634d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Thu, 15 Mar 2007 22:55:26 MST."
             <e9c3a7c20703152255q16563803q33a5893c210634d1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <e9c3a7c20703152255q16563803q33a5893c210634d1@mail.gmail.com> you wrote:
>
> They are in -mm (git-md-accel.patch).  I'll review this driver and and
> integrate it into my next push to Andrew, along with some further
> cleanups.

Thanks.

We're doing some cleanup now based on the feedback we receive.

What is easier for you to handle  -  a  complete  new  patch,  or  an
incrementan  one  on  top  of  what  we  submitted  now?  (I'd prefer
incremental, but will do whatever works better for you).

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH, HRB 165235 Munich, CEO: Wolfgang Denk
Office:  Kirchenstr. 5,       D-82194 Groebenzell,            Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
You may call me by my name, Wirth, or by my value, Worth.
- Nicklaus Wirth
