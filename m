From: Eric Smith <eric.d.bald.smith@gmail.com>
Subject: Re: 4 drive raid 5 array with 2 drives down
Date: Fri, 11 Oct 2013 22:25:52 -0400
Message-ID: <CAJJ2cgQy+NSrPLyOQvzSaRg1riCW6yzqUo++pSf_2kdBAEa+QA@mail.gmail.com>
References: <CAJJ2cgSy8J2tSy0g6YWJOYdfEp13Fu7jxgwtxp1qt7Z4jL+JtA@mail.gmail.com>
	<alpine.DEB.2.02.1310110657000.20065@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310110657000.20065@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

using ddrescure -f -vvvv -r 3 /dev/sda /dev/sdb

it's rescued 0 B  seems to be trying to copy 4142 MB but has not
copied any thing

So is there some setting I can try other than above that might extract
something.

Thanks for any help.

On Fri, Oct 11, 2013 at 1:00 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Thu, 10 Oct 2013, Eric Smith wrote:
>
>> I had a functional 4 drive Raid5 array.  I lost one drive called support
>> to warranty it and in the time that it was coming to me a second drive died
>> also.
>
>
> Use ddrescue to try to get data out of the failed drives. If you have 2 out
> of 4 drives that are totally dead and no data can be taken from them, then
> you basically have 1/3 of your data completely gone, spread over the entire
> filesystem. You won't be able to recover much more than sporadic file
> contents...
>
> If indeed the drives are not totally dead and you can get most of the data
> out using ddrescue, then there is more hope. Do this then, and post new
> information to the list depending on how much data you were able to extract.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
