From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Tue, 12 Aug 2014 07:55:47 +0200
Message-ID: <53E9AC63.1020809@gmail.com>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com> <53E96C21.2050309@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53E96C21.2050309@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/12/2014 03:21 AM, Larkin Lowrey wrote:
> Also, leaving spin-up to the controller is
> also not so hot since some controllers spin-up the drives sequentially
> rather than in parallel.

Sequential spin-up is a feature to some, because it avoids large power
spikes.
