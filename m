From: Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH 07/11] md: rewrite handle_stripe_dirtying6 in asynchronous
	way
Date: Fri, 16 Jan 2009 09:07:11 +0800
Message-ID: <91b13c310901151707x48b1ef8av1609c3a622c19565@mail.gmail.com>
References: <200812090057.33890.yur@emcraft.com>
	 <e9c3a7c20901151351p5e1b4641h1b4c8ba1ae5dcc73@mail.gmail.com>
	 <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Tue, Dec 9, 2008 at 5:57 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
> Rewrite handle_stripe_dirtying6 function to work asynchronously.


On Fri, Jan 16, 2009 at 6:21 AM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Thu, Jan 15, 2009 at 2:51 PM, Dan Williams <dan.j.williams@intel.c=
om> wrote:
>> On Mon, Dec 8, 2008 at 2:57 PM, Yuri Tikhonov <yur@emcraft.com> wrot=
e:
>> What's the reasoning behind changing the logic here, i.e. removing
>> must_compute and such?  I'd feel more comfortable seeing copy and
>> paste where possible with cleanups separated out into their own patc=
h.

>
> Ok, I now see why this change was made.  Please make this changelog
> more descriptive than "Rewrite handle_stripe_dirtying6 function to
> work asynchronously."

Ack, could you please make the changelog more descriptive?
and or add some of your benchmark results?

Thanks,

--
Cheng Renquan (=E7=A8=8B=E4=BB=BB=E5=85=A8), Shenzhen, China
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
