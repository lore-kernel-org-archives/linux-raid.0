From: Maarten van Malland <maartenvanmalland@gmail.com>
Subject: Re: Adding journal to existing raid5 arrary
Date: Thu, 18 Aug 2016 09:51:52 +0200
Message-ID: <CAC8wJ3Fjj=ANPpL8MxN_gmcs721TjkMUOooeEh_giAONFx4q-Q@mail.gmail.com>
References: <CAC8wJ3FYKvdoLNmOerTgK+yd7p8ZhPXDLW0Z6V6Q+QpJb9MDMA@mail.gmail.com>
 <1471470369-397690-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1471470369-397690-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well that explains that then :-). Is it also planned to support
removal of the journal device? I can imagine that there are cases
(such as performance issues) that you would like to revert to the old
situation...

On Wed, Aug 17, 2016 at 11:46 PM, Song Liu <songliubraving@fb.com> wrote:
> Currently, --add-journal does not support adding journal to an existing array,
> We plan to add that soon.
>
> Song
>
