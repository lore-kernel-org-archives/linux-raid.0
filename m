From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Tue, 30 Mar 2010 19:46:14 -0700
Message-ID: <h2w4877c76c1003301946l417431f6u35b4409607d57aa3@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <4877c76c1003241947k63ce9959ta0345012b2556392@mail.gmail.com>
	 <20100331121815.48cbdf4b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100331121815.48cbdf4b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 6:18 PM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 24 Mar 2010 19:47:59 -0700
> Michael Evans <mjevans1983@gmail.com> wrote:
>
>
>
>> I believe that the default action should be to do /nothing/. =A0That=
 is
>> the only safe thing to do. =A0If an administrative framework is desi=
red
>> that seems to fall under a larger project goal which is likely bette=
r
>> covered by programs more aware of the overall system state. =A0This
>> route also allows for a range of scalability.
>
> I agree that /nothing/ should be the default action for a device with
> unrecognised content.
> If the content of the device is recognised, it is OK to have a defaul=
t with
> does what the content implies - i.e. build a device into an array.
> But maybe that it what you meant.
>
> I think there is useful stuff that can be done entirely inside mdadm =
but it
> is worth thinking about where to draw the line. =A0I'm not convinced =
that mdadm
> should "know" about partition tables and MBRs. =A0Possible the task o=
f copying
> those is best placed in a script.
>
> Thanks,
> NeilBrown
>

My larger context was looking at non-recognized devices; assembling
pre-marked containers is fine.  With the provision that pass basic
safety checks validate that outcome; is the uuid correct, does the
home-host match the current array, is the update count valid (or else
add as a prior stale member that should be marked as hot spare).

=46or anything else mdadm might be better off taking the approach that
an administratively selected set of actions should be performed.  If
the task is JUST doing stuff that mdadm would already be invoked to do
anyway then it is tolerable for those reactions to be configurable
within the .conf file, though I fear the syntax may be uglier than
assuming there's also at least a basic /bin/sh that could interpret a
set of more standard commands.  It would also provide a good example
to extend in to custom scripts.

Another advantage of using a shell script instead is that
administrators can hack in whatever tricks they want.  If they have a
partition tool or method they like they can script it and get the
results they want.  More complicated tricks could also be performed,
such as first preparing the disc for cryptographic storage by filling
it with random data, or performing SMART checks, or any other
operation of their choice.

Alternatively, if an administrator or device maker needs something
different they could produce a binary to run instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
