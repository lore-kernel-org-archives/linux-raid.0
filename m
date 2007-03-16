From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 09:33:43 -0700
Message-ID: <e9c3a7c20703160933m4df67620n75570f4b3d75ab45@mail.gmail.com>
References: <e9c3a7c20703152255q16563803q33a5893c210634d1@mail.gmail.com>
	 <20070316101658.61685352604@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070316101658.61685352604@atlas.denx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/16/07, Wolfgang Denk <wd@denx.de> wrote:
> In message <e9c3a7c20703152255q16563803q33a5893c210634d1@mail.gmail.com> you wrote:
> >
> > They are in -mm (git-md-accel.patch).  I'll review this driver and and
> > integrate it into my next push to Andrew, along with some further
> > cleanups.
>
> Thanks.
>
> We're doing some cleanup now based on the feedback we receive.
>
> What is easier for you to handle  -  a  complete  new  patch,  or  an
> incrementan  one  on  top  of  what  we  submitted  now?  (I'd prefer
> incremental, but will do whatever works better for you).
>
I can handle incremental, but I will probably fold everything together
in the patch that goes to -mm.

Check out Stacked GIT (http://www.procode.org/stgit/) when you get a
chance, it handles this situation well.

> Best regards,
>
> Wolfgang Denk
>

Dan
