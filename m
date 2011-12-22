From: Alexander =?utf-8?b?S8O8aG4=?= <alexander.kuehn@nagilum.de>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Thu, 22 Dec 2011 21:54:42 +0100
Message-ID: <20111222215442.Horde.VHSHGZk8pphO85kS1Gs7yvA@cakebox.homeunix.net>
References: <20111026014240.21110.28487.stgit@notabene.brown>
 <CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
 <20111215171850.335da016@notabene.brown>
 <CABE8wwtKvNamQM3VfYFHwGQ0BhV2xBtYgqV1=Rmjc=6J3Bqogw@mail.gmail.com>
 <20111220161820.0830ef18@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111220161820.0830ef18@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Zitat von NeilBrown <neilb@suse.de>:

> On Wed, 14 Dec 2011 23:14:04 -0800 "Williams, Dan J"
> <dan.j.williams@intel.com> wrote:
>
>> On Wed, Dec 14, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
>> >> f248f8c md: create externally visible flags for supporting hot-re=
place.
>> >>
>> >> 'replaceable' just strikes me as a confusing name as all devices =
are
>> >> nominally "replaceable", but whether you want it to be actively
>> >> replaced is a different consideration. =C2=A0What about "incumben=
t" to mark
>> >> the disk as currently holding a position we want it to vacate and
>> >> remove any potential confusion with 'replacement'.

'vacating' strikes me as the obvious choice, no?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
