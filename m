From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [mdadm PATCH 0/2] Improvement: new logging library for
	mdadm/mdmon
Date: Fri, 29 Jan 2010 23:19:56 -0800
Message-ID: <4877c76c1001292319s526ed6e4l1ff66509286a759c@mail.gmail.com>
References: <20100128155922.32091.12709.stgit@awojcik-linux>
	 <20100129205242.62e4049d@notabene>
	 <1264781188.2788.99.camel@awojcik-linux> <4B635FE7.4040908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B635FE7.4040908@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Wojcik, Artur" <artur.wojcik@intel.com>, Neil Brown <neilb@suse.de>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 2:23 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> Wojcik, Artur wrote:
>>
>> On Fri, 2010-01-29 at 09:52 +0000, Neil Brown wrote:
>>>
>>> I'd probably need a lot of convincing to add something like this to
>>> mdadm.
>>>
>>
>> I did not expect this patch to be accepted without convincing you or=
 at
>> least without a lot of explanations :). What interest you the most?
>>
>> The reason for this improvement/patch is:
>>
>> 1) to unify the way mdadm and mdmon log messages,
>
> Unification implies code reduction, this is currently just code movem=
ent.
>
>> 2) to have logs from mdadm and mdmon applications at the same time
>> 3) to be able to capture log messages when system is booting, 4) to
>> simplify the source code.
>
> The only one that would be interesting from a debug perspective is 3,=
 but
> syslog is not available in the initramfs and I currently do not see h=
ow it
> would be much better than just redirecting the console to the serial =
port
> and logging it there. =A0The dprintf() calls in mdmon are sometimes u=
seful,
> but I am skeptical of needing those on all the time.
>

3) If you're worried about the kernel messages look in to netconsole.

If you're worried about where system logs go after startup, isn't that
what the various syslog daemons are for (in fact on my 24/7 linux
system my syslog /captures/ netconsole logs from any other machine I
care to set up sending from)?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
