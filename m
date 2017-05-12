From: Maarten van Malland <maartenvanmalland@gmail.com>
Subject: Re: Adding journal to existing raid5 arrary
Date: Fri, 12 May 2017 15:19:27 +0200
Message-ID: <CAC8wJ3G+ETxMX-0FWbJBdDEPHjX1Mth7huOj_g5J_27Yg+3Y2g@mail.gmail.com>
References: <CAC8wJ3FYKvdoLNmOerTgK+yd7p8ZhPXDLW0Z6V6Q+QpJb9MDMA@mail.gmail.com>
 <1471470369-397690-1-git-send-email-songliubraving@fb.com>
 <CAC8wJ3Fjj=ANPpL8MxN_gmcs721TjkMUOooeEh_giAONFx4q-Q@mail.gmail.com> <0599434D-7C37-48D9-A04F-6A86CF0BF38F@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0599434D-7C37-48D9-A04F-6A86CF0BF38F@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was wondering if this is now possible to do with kernel 4.11? It's
not completely clear to me from the release notes.

Thank you,

Maarten

On Thu, Aug 18, 2016 at 6:03 PM, Song Liu <songliubraving@fb.com> wrote:
> Yes, we do plan to add removal as well.
>
> Thanks,
> Song
>
>>> On 8/18/16, 12:51 AM, "Maarten van Malland" <maartenvanmalland@gmail.com> wrote:
>
>     Well that explains that then :-). Is it also planned to support
>     removal of the journal device? I can imagine that there are cases
>     (such as performance issues) that you would like to revert to the old
>     situation...
>
>     On Wed, Aug 17, 2016 at 11:46 PM, Song Liu <songliubraving@fb.com> wrote:
>     > Currently, --add-journal does not support adding journal to an existing array,
>     > We plan to add that soon.
>     >
>     > Song
>     >
>
>
