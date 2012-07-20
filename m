From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: commit backport request
Date: Fri, 20 Jul 2012 10:38:50 +0800
Message-ID: <CA+sTkh43mpEiL5bUhx=tak3gO+Mg1W3-3A3zbScR8op2iKKyXQ@mail.gmail.com>
References: <20120709140230.3cf926ec@notabene.brown> <1342065131.25597.352.camel@deadeye.wl.decadent.org.uk>
 <CA+sTkh6Nnfx3OAF0CN0CfRCUHUg2XEtivY-DmTXrRGwnPLgY2Q@mail.gmail.com> <1342496902.11373.33.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1342496902.11373.33.camel@deadeye.wl.decadent.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, stable@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>
List-Id: linux-raid.ids

On 17 July 2012 11:48, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Tue, 2012-07-17 at 11:26 +0800, Igor M Podlesny wrote:
>> On 12 July 2012 11:52, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > On Mon, 2012-07-09 at 14:02 +1000, NeilBrown wrote:
>> [...]
>> > Queued up for 3.2.y, thanks.
>> >
>> > Ben.
>>
>>    Hm, it looks like 3.2.23 misses it =E2=80=94 at least my during r=
ebase the
>> cherry-picked fix applied again cleanly.
>
> I queued it up some hours after tagging that release.  I *announced* =
the
> release later, but that's because uploading tarballs etc. involves a
> round trip via Greg.
>
> Ben.

   JFYI, 3.4.6 doesn't have it either...

commit 1c8f63c2758096c3b6425f4ecb274901151d6f17
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu Jul 19 12:11:49 2012 -0700

    Linux 3.4.6

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
