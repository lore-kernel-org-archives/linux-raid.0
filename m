From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Wed, 12 Jun 2019 18:49:58 +0200
Message-ID: <20190612164958.GB31124@kroah.com>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: stable@vger.kernel.org, Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org, axboe@kernel.dk, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, sashal@kernel.org
List-Id: linux-raid.ids

On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
> +Greg, Sasha

Please resend them in a format that they can be applied in.

Also, I need a TON of descriptions about why this differs from what is
in Linus's tree, as it is, what you have below does not show that at
all, they seem to be valud for 5.2-rc1.

And I need acks from the maintainers of the subsystems.

thanks,

greg k-h
