From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm with data offsets
Date: Tue, 15 Dec 2015 08:44:36 -0500
Message-ID: <56701944.1040505@turmel.org>
References: <CAH_hVdp4mGE-AZ1ww81u9vS0xri4xR+LrpaRSbaUb6VRohZ_Rg@mail.gmail.com>
 <566E0440.70801@turmel.org> <566E05B2.20803@turmel.org>
 <CAH_hVdo43dSuaeJT-QGN14LhiRnR1zYVFwqvueV6vxthHYYU9g@mail.gmail.com>
 <566EBC38.7060205@turmel.org>
 <CAH_hVdqMdrPTAz1LcDzZNDMdGKFOpwo32mh0E+mFZtcCBEBqJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_hVdqMdrPTAz1LcDzZNDMdGKFOpwo32mh0E+mFZtcCBEBqJg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "TheGerwazy ." <gerardlesiuk@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/15/2015 06:30 AM, TheGerwazy . wrote:

> The main problem is the data offsets are not stored elsewhere than in
> superblock. I have some drives from debian 6.0.5 and some were changed
> in debian 7.5. In 6.0.5 default data offset was at 2048 sector while
> int 7.5 it is 262144.

There have been other defaults, and various adjustments to the
algorithms that handle special cases.  The purpose of the superblock is
to store the data needed by the features supported.  Where else
would/could you store this information?

This highlights why --create is such a terrible way to recover an array,
and highlights the danger posed by well-intentioned bloggers who
cavalierly suggest using it.

Pretty much everyone who comes here for advice *before* trying --create
has been successfully helped.  The results after --create are decidedly
mixed.

> Thanks for Phil

You're welcome.

Phil

