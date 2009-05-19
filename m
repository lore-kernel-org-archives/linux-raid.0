From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Tue, 19 May 2009 11:09:00 -0700
Message-ID: <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
References: <1241300764.5607.36.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1241300764.5607.36.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@013.net>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Sat, May 2, 2009 at 2:46 PM, raz ben yehuda <raziebe@013.net> wrote:
> Neil Hello
> The bellow is the raid0 grow code.I have decided to fix raid0 and not
> perform the transformation raid0-raid4-raid0 due to two reasons:
> 1. raid0 zones. this patch support any zone transformations.
> 2. Undesired dependency of raid0 over raid4 re-striping code.

Hi Raz,

Can you explain a bit more about why the raid4 approach is
undesirable?  I think making reshape only available to raid0 arrays
where all the members are the same size is a reasonable constraint.
We then get the nice benefit of reusing the raid5 reshape
infrastructure.  In other words I am not convinced that the benefits
of reimplementing reshape in raid0 outweigh the costs.

Thanks,
Dan
