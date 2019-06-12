From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Wed, 12 Jun 2019 14:43:22 -0400
Message-ID: <20190612184322.GF1513@sasha-vm>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
 <20190612164958.GB31124@kroah.com>
 <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Guilherme Piccoli <gpiccoli@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
List-Id: linux-raid.ids

On Wed, Jun 12, 2019 at 03:07:11PM -0300, Guilherme Piccoli wrote:
>On Wed, Jun 12, 2019 at 1:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
>> > +Greg, Sasha
>>
>> Please resend them in a format that they can be applied in.
>>
>> Also, I need a TON of descriptions about why this differs from what is
>> in Linus's tree, as it is, what you have below does not show that at
>> all, they seem to be valud for 5.2-rc1.
>
>Thanks Greg, I'll work on it. Can this "ton" of description be a cover-letter?

Please just add it to the commit message. We might need to refer to it
in the future and cover letter will just get lost.
