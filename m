From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Sun, 01 Sep 2013 19:05:47 +0200
Message-ID: <522373EB.6080407@arcor.de>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>	<51EED0DA.3020901@arcor.de>	<51EED102.4020503@arcor.de>	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>	<51EEF3D3.7020305@arcor.de>	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>	<51F1754B.5000905@arcor.de>	<CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>	<51FAA5C3.8030109@arcor.de>	<CAC9WiBhGyE=OJdSeL_OsPxtirhJ2=3WRsk=uBPiOTzMjBCf-dA@mail.gmail.com>	<51FBF830.5060606@arcor.de>	<CAC9WiBg8UT4iLsPCY8DgR9ysfj8OmJARnRfSuxtbUCx_+2eBDw@mail.gmail.com>	<52190167.10107@arcor.de> <CAC9WiBjQA_pTJzFDqc442hZUcupBN38qNQcnVHFz
 55bTBdA2Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjQA_pTJzFDqc442hZUcupBN38qNQcnVHFz55bTBdA2Gw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/31/2013 09:23 PM, Francis Moreau wrote:
> Hi Martin,
> 
>> You may want to retry with my latest patch set. In particular, "DDF:
>> container_content_ddf: set safe_mode_delay > 0" might help.
>>
>> Martin
> 
> Man, your my hero :)
> 
> Your latest patch set fix the issue.
> 
> good work.

Thanks for your testing!

Martin
