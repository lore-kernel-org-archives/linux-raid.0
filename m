From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: MD driver document
Date: Wed, 24 Oct 2007 11:56:12 -0700
Message-ID: <e9c3a7c20710241156g341e37b2x6b413dccd4efc6c6@mail.gmail.com>
References: <107098.90117.qm@web81302.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <107098.90117.qm@web81302.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/24/07, tirumalareddy marri <tirumalareddymarri@yahoo.com> wrote:
>
>  Hi,
>    I am looking for best way of understanding MD
> driver(including raid5/6) architecture. I am
> developing driver for one of the PPC based SOC. I have
> done some code reading and tried to use HW debugger to
> walk through the code. But it was not much help.
>
>   If you have any pointers or documents, I will
> greatly appreciate if you can share it.
>

I started out with include/linux/raid/raid5.h.  Also, running it with
the debug print statements turned on will get you familiar with the
code flow.

Lastly, I wrote the following paper which is already becoming outdated:
http://downloads.sourceforge.net/xscaleiop/ols_paper_2006.pdf

> Thanks and regards,
>  Marri
>

--
Dan
