From: Guilherme Piccoli <gpiccoli@canonical.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Wed, 12 Jun 2019 15:48:00 -0300
Message-ID: <CAHD1Q_w76cZy9_6vTXuK-OOc-BgxXrjp_dfgox-+tZq=gA0Hnw@mail.gmail.com>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com> <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
 <20190612164958.GB31124@kroah.com> <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
 <20190612184322.GF1513@sasha-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190612184322.GF1513@sasha-vm>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
List-Id: linux-raid.ids

OK perfect, thank you both!

On Wed, Jun 12, 2019 at 3:43 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Jun 12, 2019 at 03:07:11PM -0300, Guilherme Piccoli wrote:
> >On Wed, Jun 12, 2019 at 1:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >>
> >> On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
> >> > +Greg, Sasha
> >>
> >> Please resend them in a format that they can be applied in.
> >>
> >> Also, I need a TON of descriptions about why this differs from what is
> >> in Linus's tree, as it is, what you have below does not show that at
> >> all, they seem to be valud for 5.2-rc1.
> >
> >Thanks Greg, I'll work on it. Can this "ton" of description be a cover-letter?
>
> Please just add it to the commit message. We might need to refer to it
> in the future and cover letter will just get lost.
>
> --
> Thanks,
> Sasha
