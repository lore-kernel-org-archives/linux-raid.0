From: Chris Weiss <cweiss@gmail.com>
Subject: Re: [Scst-devel] Tuning scst windows and sw raid5
Date: Fri, 22 Apr 2011 09:48:08 -0500
Message-ID: <BANLkTim3nxNne5YA++gyBpm9Wz+nwQ58Qg@mail.gmail.com>
References: <201104221608.50195.lukasz.oles@open-e.com> <BANLkTiktSichu5PT7LUb0nLzOe=chq3s1A@mail.gmail.com>
 <201104221635.38092.lukasz.oles@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104221635.38092.lukasz.oles@open-e.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?xYF1a2FzeiBPbGXFmw==?= <lukasz.oles@open-e.com>
Cc: scst-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 22, 2011 at 9:35 AM, =C5=81ukasz Ole=C5=9B <lukasz.oles@ope=
n-e.com> wrote:
> On Friday 22 of April 2011 16:19:48 you wrote:
>> On Fri, Apr 22, 2011 at 9:08 AM, =C5=81ukasz Ole=C5=9B <lukasz.oles@=
open-e.com> wrote:
>> Also xfs is much better at dealing with large files than ntfs. =C2=A0=
Best
>> apple to apples test is going to be on raw unformated partitions
> What this test(testing on raw partitions) can tell me? In the end I h=
ave to
> use filesystem.

it'll tell you that scst is being consistent.  there will always be
differences in filesystem performance, try ext3 on linux and you'll
see a huge difference from xfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
