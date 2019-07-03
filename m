From: Guilherme Piccoli <gpiccoli@canonical.com>
Subject: Re: [4.19.y PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
Date: Wed, 3 Jul 2019 09:18:51 -0300
Message-ID: <CAHD1Q_z+V7NgL1cT3hWioWwWfpViNHDLbhpK=USbBnE=MY7X+A@mail.gmail.com>
References: <20190628221759.18274-1-gpiccoli@canonical.com> <20190703121700.GE7784@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190703121700.GE7784@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, Jay Vosburgh <jay.vosburgh@canonical.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <songliubraving@fb.com>, Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, Eric Ren <renzhengeek@gmail.com>
List-Id: linux-raid.ids

On Wed, Jul 3, 2019 at 9:17 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> [...]
> Both patches now queued up, thanks.

Thanks a lot Song and Greg!
Cheers,


Guilherme
