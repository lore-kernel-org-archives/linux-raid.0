From: mark delfman <markdelfman@googlemail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 12:29:52 +0100
Message-ID: <66781b10910130429v5a98fae6w82ed9911dc17ff89@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
	 <20091013013352.GA24869@infradead.org>
	 <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
	 <70ed7c3e0910130409r1e1350b6yabfdc3d4f5c51edf@mail.gmail.com>
	 <66781b10910130412x309d9de2l574ba12a9ed4100a@mail.gmail.com>
	 <70ed7c3e0910130415k4da86d18kd92dce5217b8600d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910130415k4da86d18kd92dce5217b8600d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think that is an option... but we have a little time to try to
resolve this and i think it would be good if we find the core problem
(for all).



On Tue, Oct 13, 2009 at 12:15 PM, Majed B. <majedb@gmail.com> wrote:
> Mark, kindly use reply-all :)
>
> I think you could apply the patch for the LSI SAS2 support instead of
> using the whole new kernel, assuming the patch doesn't depend on othe=
r
> things...
>
> On Tue, Oct 13, 2009 at 2:12 PM, mark delfman
> <markdelfman@googlemail.com> wrote:
>> We upgrading mainly because of support for the emerging LSI SAS2 car=
ds
>> (which we are beta testing now)
> --
> =A0 =A0 =A0 Majed B.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
