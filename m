From: hansbkk@gmail.com
Subject: Re: Mixing mdadm versions
Date: Thu, 17 Feb 2011 21:16:43 +0700
Message-ID: <AANLkTikgDTTo-FaRB48BR04nZOrRuWsYY-46GnqQjhiV@mail.gmail.com>
References: <AANLkTi=g2V9n_AEEGX58d1PkTLRj7HtxT=AGEaLQXNz1@mail.gmail.com>
	<4D5D21BA.6060804@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D21BA.6060804@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

OK, thanks for those details.

I plan to use the running system for day-to-day serving of the data,
and to use the more modern versions (which originally created the
arrays) for any recovery/maintenance.

I believe the running system will be getting upgraded (RHEL5?) in the
next few months, so unless I have reason to think there's actually
something wrong, I think I'll leave it alone, I really don't feel like
learning another package management system at the moment - the Linux
learning curve has been making my brain ache lately 8-)

On Thu, Feb 17, 2011 at 8:25 PM, Phil Turmel <philip@turmel.org> wrote:
> On 02/17/2011 05:21 AM, hansbkk@gmail.com wrote:
>> I've created and manage sets of arrays with mdadm v3.1.4 - I've been
>> using System Rescue CD and Grml for my sysadmin tasks, as they are
>> based on fairly up-to-date gentoo and debian and have a lot of
>> convenient tools not available on the production OS, a "stable" (rea=
d:
>> old packages) flavor of RHEL, which turns out is running mdadm v2.6.=
4.
>> I spec'd v1.2 metadata for the big raid6 storage arrays, but kept to
>> 0.90 for the smaller raid1's as some of those are my boot devices.
>
> The default data offset for for v1.1 and v1.2 meta-data changed in md=
adm v3.1.2. =A0If you ever need to use the running system to "mdadm --c=
reate --assume-clean" in a recovery effort, the data segments will *NOT=
* line up if the original array was created with a current version of m=
dadm.
>
> (git commit a380e2751efea7df "super1: encourage data alignment on 1Me=
g boundary")
>
>> As per a previous thread, I've noticed on the production OS the outp=
ut
>> of mdadm -E on a member returns a long string of "failed, failed". T=
he
>> more modern mdadm reports everything's OK.
>>
>> - Also mixed in are some "fled"s - whazzup with that?
>>
>> Unfortunately the server is designed to run as a packaged appliance
>> and uses the rpath/conary package manager, so I'm hesitant to fiddle
>> around upgrading some bits, afraid that other bits will break - the
>> sysadmin tools are run from a web interface to a bunch of PHP script=
s.
>>
>> So, here are my questions:
>>
>> As long as the more recent versions of mdadm report that everything'=
s
>> OK, can I ignore the mishmosh output of the older mdadm -E report?
>
> Don't know.
>
>> And am I correct in thinking that from now on I should create
>> everything with the older native packages that are actually going to
>> serve the arrays in production?
>
> If there's a more modern Red Hat mdadm package that you can include i=
n your appliance, that would be my first choice. =A0After testing with =
the web tools, though.
>
> Otherwise, I would say "Yes", for the above reason. =A0However, the r=
everse problem can also occur. =A0You won't be able to use a modern mda=
dm to do a "--create --assume-clean" on an offline system. =A0That's wh=
at happened to Simon in another thread. =A0Avoiding that might be worth=
 the effort qualifying a newer version of mdadm.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
